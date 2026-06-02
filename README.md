# FocusFlow (productivity-app)

FocusFlow is a modern AI-powered student productivity app built with Flutter and Firebase. This repository contains a skeleton that implements app structure, theming, onboarding, splash screen, and basic auth stubs.

## What I created
- Flutter project skeleton with Material 3 theming
- Riverpod state management setup
- Firebase initialization (add your platform files)
- Splash and Onboarding screens
- Auth service stub and Login screen
- Folder structure according to the spec

## Next steps (you must perform locally)
1. Install Flutter SDK (latest stable)
2. Configure Firebase for iOS and Android and add `google-services.json` / `GoogleService-Info.plist`.
3. Run `flutter pub get`.
4. Run the app with `flutter run`.

## Firebase setup
Follow the official Firebase Flutter docs to add Android and iOS apps. After adding, download the config files and add them to the platform directories. Also generate `firebase_options.dart` using `flutterfire` CLI and place it in `lib/`.

### Google Sign-In and OAuth
To enable Google Sign-In you must configure OAuth client IDs in the Google Cloud Console and add the required platform configuration:

- Android: add `google-services.json` to `android/app/` and configure the SHA-1/SHA-256 fingerprints for the app in Firebase console.
- iOS: add `GoogleService-Info.plist` to `ios/Runner/` and configure reversed client id in the Info.plist if necessary.

After platform config is in place, the app will use the `google_sign_in` package to perform OAuth and Firebase Auth to sign in. The AuthService implements `signInWithGoogle()` which expects Firebase to be initialized.

## Project structure
See `lib/` for a full feature-ready structure:
- lib/core/
- lib/models/
- lib/services/
- lib/providers/
- lib/screens/
- lib/widgets/
- lib/utils/
- lib/theme/

## Notes
This is a starting point. I can continue implementing each feature screen-by-screen, add Firestore models, services, offline support, and tests. Tell me which screen or feature you'd like implemented next or say "implement all features" and I'll proceed iteratively.

## How to run locally (Mac/Linux)

1. Install Flutter (stable) following https://flutter.dev/docs/get-started/install
2. From the project root:

```bash
flutter pub get
flutter run
```

If you don't have Firebase configured, the app will run with local fallbacks (Hive + SharedPreferences). To enable full Firebase features (Auth, Firestore, FCM), follow the Firebase setup section above.

## Publish to GitHub
1. Create a new repository on GitHub (web UI or use `gh repo create`).
2. From the project root:

```bash
git init
git add .
git commit -m "Initial commit: FocusFlow starter"
git branch -M main
git remote add origin https://github.com/<your-username>/focusflow.git
git push -u origin main
```

If you use the GitHub CLI (`gh`) you can create and push in one command:

```bash
gh repo create <your-username>/focusflow --public --source=. --remote=origin --push
```

## CI
A simple GitHub Actions workflow is included at `.github/workflows/flutter.yml` that runs `flutter analyze` and `flutter test` on pushes to `main`.

## Next steps I can implement for you
- Background Pomodoro notifications (Android/iOS)
- Planner (AI study planner integration)
- Analytics dashboard (charts for weekly/monthly productivity)
- Polish UI animations and dark mode toggle

Tell me which feature you want next and I'll implement it and prepare a PR-ready branch.
>>>>>>> 600ebfb (chore: initial commit - FocusFlow starter)
