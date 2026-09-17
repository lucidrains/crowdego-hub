from io import StringIO

from django.core.management import call_command
from django.test import SimpleTestCase

from hub import trajectory


class TrajectoryExtensionTests(SimpleTestCase):
    def test_path_length(self) -> None:
        self.assertEqual(trajectory.path_length([]), 0.0)
        self.assertEqual(trajectory.path_length([[1.0, 2.0, 3.0]]), 0.0)
        corner = [[0.0, 0.0], [3.0, 0.0], [3.0, 4.0]]
        self.assertAlmostEqual(trajectory.path_length(corner), 7.0)


class NimCheckCommandTests(SimpleTestCase):
    def test_nim_check(self) -> None:
        out = StringIO()
        call_command("nim_check", stdout=out)
        self.assertIn("path_length(4 points) = 3.0", out.getvalue())
