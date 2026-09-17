from django.test import SimpleTestCase
from django.urls import reverse


class HelloWorldTests(SimpleTestCase):
    def test_home(self) -> None:
        response = self.client.get(reverse("home"))
        self.assertContains(response, "Hello, world!")
        self.assertContains(response, 'id="vue-app"')
        self.assertContains(response, 'hx-get="/greeting/"')
        self.assertContains(response, "/static/dist/main.js")
        self.assertTemplateUsed(response, "home.html")

    def test_greeting(self) -> None:
        response = self.client.get(reverse("greeting"), HTTP_HX_REQUEST="true")
        self.assertContains(response, "loaded from Django with HTMX")
        self.assertNotContains(response, "<!doctype html>")
        self.assertTemplateUsed(response, "partials/greeting.html")

    def test_post_not_allowed(self) -> None:
        for name in ("home", "greeting"):
            with self.subTest(name=name):
                self.assertEqual(self.client.post(reverse(name)).status_code, 405)
