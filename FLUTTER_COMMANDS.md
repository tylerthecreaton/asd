# Flutter Commands Cheat Sheet

## Development

### Run App

```bash
# Run on Windows
flutter run -d windows

# Run on Chrome
flutter run -d chrome

# Run on Android emulator
flutter run

# Run with hot reload
flutter run --hot
```

### Build App

```bash
# Build for Windows
flutter build windows

# Build APK for Android
flutter build apk

# Build for Web
flutter build web
```

## Testing

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/core/utils/validators_test.dart
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

## Code Quality

### Analyze Code

```bash
flutter analyze
```

### Format Code

```bash
flutter format .
```

### Fix Code Issues

```bash
dart fix --apply
```

## Clean & Get Dependencies

### Clean Build Files

```bash
flutter clean
```

### Get Dependencies

```bash
flutter pub get
```

### Upgrade Dependencies

```bash
flutter pub upgrade
```

### Check Outdated Packages

```bash
flutter pub outdated
```

## Riverpod Code Generation

### Generate Code Once

```bash
flutter pub run build_runner build
```

### Watch and Generate Code

```bash
flutter pub run build_runner watch
```

### Clean and Regenerate

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Useful Commands

### Check Flutter Version

```bash
flutter --version
```

### Check Connected Devices

```bash
flutter devices
```

### Doctor (Check Environment)

```bash
flutter doctor
```

### Create New Page/Widget

```bash
# Create a new Dart file
# Use: File > New File in VS Code
```

## Authentication Feature Quick Commands

### Run Login Page Directly

```bash
# Modify main.dart to navigate to login first
# Then run: flutter run -d windows
```

### Test Validators

```bash
flutter test test/core/utils/validators_test.dart
```

### Analyze Authentication Code

```bash
flutter analyze lib/features/authentication/
```

## Git Commands (Optional)

### Stage Changes

```bash
git add .
```

### Commit Changes

```bash
git commit -m "Add authentication feature"
```

### Push to Remote

```bash
git push origin main
```

## VS Code Shortcuts

- `Ctrl + Shift + P` - Command Palette
- `Ctrl + .` - Quick Fix
- `F5` - Start Debugging
- `Shift + F5` - Stop Debugging
- `Ctrl + Space` - Trigger Suggestions
- `Alt + Shift + F` - Format Document
