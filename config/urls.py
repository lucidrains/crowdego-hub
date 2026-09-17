from django.http import HttpRequest, HttpResponse
from django.shortcuts import render
from django.urls import path
from django.views.decorators.http import require_GET


@require_GET
def home(request: HttpRequest) -> HttpResponse:
    return render(request, "home.html")


@require_GET
def greeting(request: HttpRequest) -> HttpResponse:
    return render(request, "partials/greeting.html")


urlpatterns = [
    path("", home, name="home"),
    path("greeting/", greeting, name="greeting"),
]
