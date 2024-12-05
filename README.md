<div align="center">
    <h1>ChatAja</h1>
    <p>An application for chatting with the purpose of learning.</p>
</div>

---

<p align="center">
  <img src="screenshots/login.jpg" width="30%" />
  <img src="screenshots/register.jpg" width="30%" />
  <img src="screenshots/home.jpg" width="30%" />
  <img src="screenshots/find.jpg" width="30%" />
  <img src="screenshots/chat.jpg" width="30%" />
</p>

## Features
- Login
- Register
- Find User
- Chatting

## Tech Stack & Library
- [injectable](https://pub.dev/packages/injectable) for Dependency Injection.
- [Bloc](https://pub.dev/packages/bloc) for BLoC Design Pattern (Business Logic Component).
- [Retrofit](https://pub.dev/packages/retrofit) for HTTP Client.
- [dart_mappable](https://pub.dev/packages/dart_mappable) for creating models.
- [logger](https://pub.dev/packages/logger) for A logger.
- [easy_localization](https://pub.dev/packages/easy_localization) for Localization.
- Used AndroidX, Jetpack Compose, Material Design Components 3, and any more libraries.

## Data Source
ChatAja using the [BASE_URL](.env) for constructing RESTful API.<br>
BASE_URL provides a RESTful API interface to highly detailed objects built from thousands of lines of data related to stories.