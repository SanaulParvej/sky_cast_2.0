# Sky Cast

A weather forecasting application built with Flutter.

## Getting Started

This project is a weather forecasting application built with Flutter. It provides current weather information, forecasts, and location-based services.

## Project Optimization

This project has been optimized for publication with the following changes:
- Removed unused code and files
- Optimized dependencies in pubspec.yaml
- Verified app icon configuration
- Cleaned up project structure

For detailed information about the optimizations performed, see [PROJECT_OPTIMIZATION_SUMMARY.md](PROJECT_OPTIMIZATION_SUMMARY.md).

## Setting up the App Icon

To properly set up your app icon:

1. Create a high-resolution app icon (at least 1024x1024 pixels) in PNG format
2. Save it as `assets/icon/app_icon.png`
3. Run the following commands:

```bash
flutter pub get
flutter pub run flutter_launcher_icons:main
```

For detailed requirements and best practices for app icons, see [APP_ICON_REQUIREMENTS.md](APP_ICON_REQUIREMENTS.md).

This will automatically generate all required icon sizes for both Android and iOS platforms.