# Command: flutter-run
**Description:** Runs the Flutter application targeting the Chrome web browser for portfolio testing.

**Steps:**
1. Navigate to the `frontend` or Flutter root directory.
2. Run `flutter clean` if requested by the user.
3. Run `flutter pub get` to ensure dependencies are updated.
4. Execute `flutter run -d chrome --web-renderer canvaskit`.