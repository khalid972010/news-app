# News & Insight App

A Flutter application that fetches live news articles, supports infinite scrolling, and allows users to bookmark their favorite articles.

## Features

* Fetch articles from a live API
* Infinite scrolling pagination
* Article detail view
* Bookmark favorite articles
* Favorites persistence using local storage
* Error handling with retry support

## Tech Stack

* Flutter
* Cubit (flutter_bloc)
* Dio for networking
* SharedPreferences for persistence
* Clean architecture (datasource → repository → cubit → UI)


## Getting Started

```bash
flutter pub get
flutter run
```

## Screens

* Home – list of articles with pagination
* ArticleDetail – full article view with bookmark option
* Favorites – list of saved articles
