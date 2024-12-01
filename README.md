# Flutter App - README

## Description

This is a simple Flutter application that supports both **iOS** and **Android** platforms. The app is designed to demonstrate Flutter's flexibility in handling user interfaces and communication between Dart code and native code via **Method Channels** and **Custom Widgets**.

## Key Features

- Local notifications management using the **flutter_local_notifications** package.
- Creation and updating of **custom widgets** on the device's home screen using the **home_widget** package.
- Communication between Dart code and native code (iOS/Android) via **MethodChannel**.
- Handling asynchronous data with **FutureBuilder** for dynamic updates to the user interface.

## Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (version 3.x or later)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development)
- [Android Studio](https://developer.android.com/studio) (for Android development)

### Project Structure

- lib/: Contains the source code of the app, including files for managing widgets, notifications, and asynchronous logic.
-  ios/: Contains the configuration files for iOS, including AppDelegate.swift and configuration for the iOS widget.
-  android/: Contains the configuration files for Android, including AndroidManifest.xml and MainActivity.java.


## Installation

### 1. Clone the repository

```bash
git clone https://gitlab.switch.ch/hslu/edu/bachelor-computer-science/moblab/projects/2024/2024-sa35-flutter.git
cd 2024-sa35-flutter
```

### 2. Install dependencies
```bash
    flutter pub get
```

### 3. Run the app
```bash
    flutter run
```