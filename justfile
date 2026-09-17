set shell := ["bash", "-uc"]

android-sdk := env_var_or_default("ANDROID_HOME", "/opt/homebrew/share/android-commandlinetools")
adb := android-sdk + "/platform-tools/adb"
emulator := android-sdk + "/emulator/emulator"
avd-name := env_var_or_default("AVD_NAME", "crowdego")

[private]
default:
    @just --list

[doc('Install Python, JS, Flutter, and Nim dependencies')]
setup:
    uv sync
    bun install
    just mobile-setup
    just nim-setup

[doc('Start the PostgreSQL container')]
[group('database')]
db:
    docker compose up -d --wait db

[doc('Stop the PostgreSQL container')]
[group('database')]
db-down:
    docker compose down

[doc('Apply database migrations')]
[group('database')]
migrate:
    uv run python manage.py migrate

[doc('Create new migrations')]
[group('database')]
makemigrations *args:
    uv run python manage.py makemigrations {{ args }}

[doc('Open the Django shell')]
[group('database')]
shell:
    uv run python manage.py shell

[doc('Run Django and the asset watcher together')]
[group('web')]
dev: db migrate
    #!/usr/bin/env bash
    set -euo pipefail
    bun run dev &
    assets=$!
    trap 'kill $assets 2>/dev/null || true' EXIT
    uv run python manage.py runserver

[doc('Run the Django development server')]
[group('web')]
web:
    uv run python manage.py runserver

[doc('Build frontend assets')]
[group('web')]
assets:
    bun run build

[doc('Build assets and collect static files')]
[group('web')]
build: assets
    uv run python manage.py collectstatic --noinput

[doc('Run Django tests')]
[group('web')]
test *args:
    uv run python manage.py test {{ args }}

[doc('Lint Python and JS')]
[group('web')]
lint:
    uv run ruff check .
    bun run lint

[doc('Format Python and JS')]
[group('web')]
fmt:
    uv run ruff format .
    bunx biome check --write frontend

[doc('Type-check with mypy')]
[group('web')]
typecheck:
    uv run mypy .

[doc('Run lint, typecheck, and tests')]
[group('web')]
check: lint typecheck test

[doc('Install the Nim compiler needed to build the .nim extension')]
[group('nim')]
nim-setup:
    ./scripts/install-nim.sh

[doc('Compile and run the Nim extension through Django')]
[group('nim')]
nim-check:
    uv run python manage.py nim_check

[doc('Fetch Flutter packages')]
[group('mobile')]
[working-directory('mobile')]
mobile-setup:
    flutter pub get

[doc('Run the app on the Android emulator, booting it if needed')]
[group('mobile')]
[working-directory('mobile')]
mobile-run:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! {{ adb }} devices | grep -q '^emulator-'; then
        echo "Booting Android emulator ({{ avd-name }})..."
        nohup {{ emulator }} -avd {{ avd-name }} >/tmp/emulator.log 2>&1 &
        {{ adb }} wait-for-device
        until [[ "$({{ adb }} shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" == "1" ]]; do
            sleep 2
        done
    fi
    device=$({{ adb }} devices | grep -m1 '^emulator-' | cut -f1)
    echo "Running on $device"
    exec flutter run -d "$device"

[doc('Run Flutter tests')]
[group('mobile')]
[working-directory('mobile')]
mobile-test:
    flutter test

[doc('Analyze the Flutter app')]
[group('mobile')]
[working-directory('mobile')]
mobile-analyze:
    flutter analyze

[doc('Format Dart code')]
[group('mobile')]
[working-directory('mobile')]
mobile-fmt:
    dart format .

[doc('Build the Android APK')]
[group('mobile')]
[working-directory('mobile')]
mobile-build-apk:
    flutter build apk

[doc('Build the iOS app')]
[group('mobile')]
[working-directory('mobile')]
mobile-build-ios:
    flutter build ios

[doc('Check the mobile app (analyze + test)')]
[group('mobile')]
mobile-check: mobile-analyze mobile-test
