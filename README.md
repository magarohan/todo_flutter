# Offline Todo

A simple offline todo application built with Flutter. The app lets users create todos, assign due dates, set urgency levels, view todo details, and mark tasks as complete. Todo data is stored locally using SQLite, so tasks remain available without an internet connection.

## Features

* Add new todos with a title, description, due date, and urgency level
* View saved todos in a clean task list
* Open a todo detail screen to see full task information
* Mark todos as complete or incomplete
* Store todos locally using SQLite
* Custom handwritten-style UI using local assets and fonts

## Tech Stack

* **Flutter**
* **Dart**
* **SQLite** with `sqflite`
* **path** and **path_provider** for local database path handling
* Local image and font assets

## Project Structure

```text
lib/
├── core/
│   ├── constants/
│   │   └── enums.dart
│   └── handler/
│       └── baseDbClient.dart
├── data/
│   ├── models/
│   │   └── todo_model.dart
│   └── repositories/
│       ├── database_helper.dart
│       └── todo_repository.dart
├── presentation/
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── todo_detail_screen.dart
│   └── widgets/
│       ├── custom_todo_dialog.dart
│       └── custom_todo_tile_widget.dart
└── main.dart
```

## Getting Started

### Prerequisites

Make sure you have Flutter installed on your machine.

Check your Flutter installation:

```bash
flutter doctor
```

### Installation

Clone the repository:

```bash
git clone https://github.com/magarohan/todo_flutter.git
cd todo_flutter
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

## Database

The app uses a local SQLite database named:

```text
todo_data.db
```

The main `todo` table stores:

| Field         | Type    | Description                             |
| ------------- | ------- | --------------------------------------- |
| `id`          | TEXT    | Unique todo ID                          |
| `title`       | TEXT    | Todo title                              |
| `description` | TEXT    | Todo description                        |
| `dueDate`     | TEXT    | Due date stored as an ISO date string   |
| `updatedAt`   | TEXT    | Last updated timestamp                  |
| `urgency`     | TEXT    | Todo urgency level                      |
| `isComplete`  | INTEGER | Completion status, stored as `0` or `1` |

## Urgency Levels

Todos can have one of the following urgency levels:

```dart
low
medium
high
none
```

## Available Commands

Run the app:

```bash
flutter run
```

Analyze the project:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Build APK:

```bash
flutter build apk
```

## Future Improvements

* Add todo delete functionality
* Add todo edit functionality
* Filter todos by today’s due date
* Add search and sorting
* Improve validation for due dates and empty fields
* Add screenshots to the README
* Add release builds for supported platforms
