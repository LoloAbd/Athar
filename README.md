# Athar

See [SOFTWARE_DOCUMENTATION.md](SOFTWARE_DOCUMENTATION.md) for the full software design document, including requirements, architecture, data model, and UML diagrams.

Athar is a bilingual Flutter app for discovering and sharing kind, inspiring messages. Its name means “impact” or “trace”: the idea is that a thoughtful message can brighten someone’s day and leave a lasting impression. Users can receive a rotating message, save messages they like, and exchange private notes with other users.

The app supports English and Arabic, including right-to-left layouts, and offers light and dark themes. Firebase Authentication and Cloud Firestore provide accounts and app data.

## Features

- Sign up and sign in with email and password or Google.
- Recover access with the forgot-password flow.
- Discover a featured message on the home screen. The app selects messages from its Firestore library and records viewed messages in the user’s history.
- Save and revisit favorite messages.
- Send private messages to users and compose messages for later delivery.
- View the inbox, mark messages as read, and respond to incoming requests.
- Manage profile details and account settings.
- Switch between English and Arabic and between light and dark appearance.

## Screens

| Screen | What it does |
| --- | --- |
| Splash | Entry point with access to the app’s language and appearance choices. |
| Sign up | Creates an account with a name, username, email, and password. |
| Login | Signs in with email and password or Google. |
| Forgot password | Starts the account recovery flow. |
| Home | Shows a featured message and quick actions; offers the inbox, language, theme, settings, About, and sign-out options. Pull down to refresh the home content. |
| Favorites | Lists saved messages. |
| History | Shows previously viewed featured messages. |
| Account / profile | Displays account information and links to profile editing. |
| Edit profile | Updates profile details. |
| Random message | Opens the flow for finding and sending a random message. |
| Random person | Helps discover a recipient for a message. |
| Schedule message | Composes a message to be delivered later. |
| Notifications / inbox | Shows incoming and scheduled messages, read state, and actions for pending requests. |
| About | Explains Athar’s story and purpose. |

The main app navigation keeps Home, Favorites, History, and Account available in a bottom navigation bar. Some actions, including message composition and the inbox, open as separate screens.

## Tech stack

- Flutter and Dart
- Firebase Core, Firebase Authentication, Cloud Firestore, and Firebase Storage
- Google Sign-In
- Flutter localization with generated English and Arabic localization classes
- Provider and other Flutter packages listed in [`pubspec.yaml`](pubspec.yaml)

## Requirements

- Flutter SDK compatible with the Dart constraint in `pubspec.yaml` (`^3.12.2`)
- A platform toolchain for the target you want to run: Android Studio / Android SDK, Xcode for iOS and macOS, or the relevant desktop toolchain
- A Firebase project with Authentication and Cloud Firestore enabled

## Run locally

1. Clone the repository and enter the project directory:

   ```sh
   git clone <repository-url>
   cd athar
   ```

2. Install dependencies:

   ```sh
   flutter pub get
   ```

3. Confirm Firebase is configured for your Firebase project. This repository includes `lib/firebase_options.dart`, Android’s `google-services.json`, and `firebase.json`; those files must contain valid configuration for the project you intend to use. If using a different Firebase project, regenerate platform options with the FlutterFire CLI and replace the platform-specific Firebase configuration files. Enable the authentication providers used by your build (Email/Password and Google) and set up Firestore.

4. Generate localization code if needed:

   ```sh
   flutter gen-l10n
   ```

5. See the available targets and launch the app:

   ```sh
   flutter devices
   flutter run
   ```

   To choose a specific target, use `flutter run -d <device-id>`.

On web, configure Firebase for the web app in the Firebase project and make sure the Google Sign-In provider’s authorized domains and client settings match your deployment. Native Google Sign-In also relies on platform-specific OAuth configuration and signing identifiers.

## Message data

At startup, `MessageSyncService` downloads the JSON message list from the URL defined in `lib/services/message_sync_service.dart` and writes the documents to the Firestore `messages` collection. Each record needs a unique, non-empty string `id`; the rest of the fields are supplied by the message data (including localized text where applicable). The app also reads reminder records from the Firestore `reminders` collection.

User accounts and their related message data are stored in Firestore. The current services use a `user/{uid}` document with subcollections such as `favorites`, `history`, and message/inbox records. Set Firestore security rules for your own deployment so users can only access data they are allowed to read and update.

## Localization

Translations are maintained in `lib/l10n/app_en.arb` and `lib/l10n/app_ar.arb`. The project uses `l10n.yaml` and Flutter’s generated localization support. Add or update strings in both ARB files, then run `flutter gen-l10n`.

## Project layout

```text
lib/
  main.dart                 App initialization, themes, locale, and routes
  screens/                  Authentication, home, profile, and message screens
  services/                 Firebase access, auth, and message synchronization
  theme/                    Shared colors and theme values
  widgets/                  Reusable UI components
  l10n/                     English and Arabic localization resources
assets/images/              App artwork and interface images
```

## Useful commands

```sh
flutter pub get       # Install packages
flutter gen-l10n      # Generate localization classes
flutter analyze       # Run static analysis
flutter run           # Build and launch on a connected target
```

## License

No license file is currently included. Add a `LICENSE` file before redistributing this project under an open-source license.
