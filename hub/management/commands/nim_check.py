from django.core.management.base import BaseCommand

from hub import trajectory

SAMPLE_DEMO = [
    [0.0, 0.0, 0.0],
    [1.0, 0.0, 0.0],
    [1.0, 1.0, 0.0],
    [1.0, 1.0, 1.0],
]


class Command(BaseCommand):
    help = "Compute a demo metric with the Nim extension to verify the toolchain."

    def handle(self, *args: object, **options: object) -> None:
        length = trajectory.path_length(SAMPLE_DEMO)
        self.stdout.write(f"path_length({len(SAMPLE_DEMO)} points) = {length}")
        self.stdout.write(self.style.SUCCESS("Nim extension compiled and executed."))
