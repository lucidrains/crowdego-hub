#!/usr/bin/env bash
set -euo pipefail

MIN_MAJOR=2

installed=""
if command -v nim >/dev/null 2>&1; then
    installed="$(nim --version 2>/dev/null | sed -n 's/^Nim Compiler Version \([0-9][0-9.]*\).*/\1/p' | head -n1)"
fi

if [ -n "$installed" ] && [ "${installed%%.*}" -ge "$MIN_MAJOR" ]; then
    echo "Nim $installed is already installed at $(command -v nim)"
    exit 0
fi

if [ -n "$installed" ]; then
    echo "Nim $installed is too old; nimporter_plus needs Nim $MIN_MAJOR or newer."
fi

if [ "$(uname -s)" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
    echo "Installing Nim with Homebrew..."
    brew install nim
else
    echo "Installing Nim with choosenim..."
    curl -sSf https://nim-lang.org/choosenim/init.sh | sh -s -- -y
    export PATH="$HOME/.nimble/bin:$PATH"
fi

if ! command -v nim >/dev/null 2>&1; then
    echo "Nim was installed but is not on PATH; add \$HOME/.nimble/bin to PATH and retry." >&2
    exit 1
fi

echo "Installed $(nim --version | head -n1)"
echo "Nimpy is installed automatically by nimporter_plus on first import."
