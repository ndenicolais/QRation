# QRation — Full documentation

> Copyright © 2026 Nicola De Nicolais — All Rights Reserved. Source-available, non-commercial license (see [LICENSE](LICENSE)).

---

## Table of contents

1. [App overview](#1-app-overview)
2. [Architecture and tech stack](#2-architecture-and-tech-stack)
3. [Project structure](#3-project-structure)
4. [Data models](#4-data-models)
   - [CodeModel](#codemodel)
   - [CodeSocial](#codesocial)
   - [Standard barcode types](#standard-barcode-types)
   - [UserModel](#usermodel)
   - [Local preferences](#local-preferences)
   - [Security rules](#security-rules)
5. [Screens and features](#5-screens-and-features)
   - [5.1 Splash](#51-splash)
   - [5.2 Onboarding](#52-onboarding)
   - [5.3 Welcome](#53-welcome)
   - [5.4 Authentication](#54-authentication)
   - [5.5 Home](#55-home)
   - [5.6 Scanner](#56-scanner)
   - [5.7 Code creation](#57-code-creation)
   - [5.8 Code details](#58-code-details)
   - [5.9 Favorites](#59-favorites)
   - [5.10 History](#510-history)
   - [5.11 Profile](#511-profile)
   - [5.12 Settings](#512-settings)
   - [5.13 Database](#513-database)
6. [State management](#6-state-management)
7. [Services](#7-services)
   - [7.1 AuthController and SessionStore](#71-authcontroller-and-sessionstore)
   - [7.2 CodesService](#72-codesservice)
   - [7.3 ChangelogService](#73-changelogservice)
   - [7.4 BackupHistory](#74-backuphistory)
   - [7.5 Public Downloads copy](#75-public-downloads-copy)
   - [7.6 CSV export](#76-csv-export)
   - [7.7 Excel export](#77-excel-export)
   - [7.8 PDF export](#78-pdf-export)
8. [Theme and style](#8-theme-and-style)
9. [Navigation](#9-navigation)
10. [Localization](#10-localization)
11. [Dependencies](#11-dependencies)
12. [System requirements](#12-system-requirements)
13. [Build and distribution](#13-build-and-distribution)
- [License](#license)

---

## 1. App overview

**QRation** is an Android app, built with Flutter, for scanning and creating QR codes and barcodes and keeping them in a personal cloud collection. Users can:

- Scan QR codes and barcodes with the camera or from an image in the gallery
- Create QR codes for 12 standard types (text, URL, email, phone, SMS, contact, location, Wi-Fi, calendar event, product, ISBN, driver's license)
- Create QR codes for 10 social networks (YouTube, Facebook, Instagram, TikTok, Telegram, LinkedIn, X, Pinterest, Spotify, WhatsApp)
- Customize a QR code with eye and module colors, rounded shapes and a center logo
- Mark codes as favorites and browse them by source
- Search and filter the full history, and delete codes in bulk
- Share a QR code as an image or save it to the gallery
- Export the collection as PDF, Excel and CSV, and back it up and restore it as JSON

All codes are stored in Cloud Firestore under the user's account. The app is available in English and Italian, with system, light and dark themes and 8 accent colors.

---

## 2. Architecture and tech stack

Versions are listed only in [Dependencies](#11-dependencies).

| Component | Technology |
|---|---|
| Framework | Flutter / Dart |
| State management and routing | [get](https://pub.dev/packages/get) (GetX) |
| Database | [cloud_firestore](https://pub.dev/packages/cloud_firestore) |
| Authentication | [firebase_auth](https://pub.dev/packages/firebase_auth), [google_sign_in](https://pub.dev/packages/google_sign_in) |
| Error reporting | [firebase_crashlytics](https://pub.dev/packages/firebase_crashlytics) |
| Local persistence | [shared_preferences](https://pub.dev/packages/shared_preferences), [path_provider](https://pub.dev/packages/path_provider) |
| Scanning | [mobile_scanner](https://pub.dev/packages/mobile_scanner), [image_picker](https://pub.dev/packages/image_picker) |
| QR generation | [pretty_qr_code](https://pub.dev/packages/pretty_qr_code), [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) |
| Images and sharing | [screenshot](https://pub.dev/packages/screenshot), [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus), [share_plus](https://pub.dev/packages/share_plus) |
| Code actions | [url_launcher](https://pub.dev/packages/url_launcher), [flutter_contacts](https://pub.dev/packages/flutter_contacts), [add_2_calendar](https://pub.dev/packages/add_2_calendar), [wifi_iot](https://pub.dev/packages/wifi_iot), [country_code_picker](https://pub.dev/packages/country_code_picker) |
| Maps | [flutter_map](https://pub.dev/packages/flutter_map), [latlong2](https://pub.dev/packages/latlong2) (OpenStreetMap tiles) |
| Export and import | [pdf](https://pub.dev/packages/pdf), [excel](https://pub.dev/packages/excel), [csv](https://pub.dev/packages/csv), [file_picker](https://pub.dev/packages/file_picker) |
| Feedback | [audioplayers](https://pub.dev/packages/audioplayers), [vibration](https://pub.dev/packages/vibration), [toastification](https://pub.dev/packages/toastification) |
| UI | [ming_cute_icons](https://pub.dev/packages/ming_cute_icons), [line_awesome_flutter](https://pub.dev/packages/line_awesome_flutter), [flutter_animate](https://pub.dev/packages/flutter_animate), [smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator) |
| Platform info and permissions | [permission_handler](https://pub.dev/packages/permission_handler), [device_info_plus](https://pub.dev/packages/device_info_plus), [package_info_plus](https://pub.dev/packages/package_info_plus) |
| Localization and logging | [intl](https://pub.dev/packages/intl), [logger](https://pub.dev/packages/logger) |

**Architectural pattern:** feature-first with GetX. Controllers are reactive view models (`Rx` fields) and hold all state and logic of a screen; screens only compose widgets and call the controller. Models are plain serializable classes. Services wrap Firebase and platform resources. Controllers are registered by bindings (see [State management](#6-state-management)) and screens resolve them with `Get.find`.

Code storage goes through a repository: `CodesRepository` (`lib/features/codes/services/codes_repository.dart`) is the abstract contract for code CRUD and queries, and `CodesService` implements it on Firestore. Screens, controllers and export services depend on `CodesRepository` only, resolved with `Get.find<CodesRepository>()`, so tests can replace it with a mock.

---

## 3. Project structure

```
qration/
├── android/                        # Native Android project
├── assets/
│   ├── fonts/                      # Montserrat (Regular, Bold), OFL.txt, QrationIcons
│   ├── images/                     # Logo and launcher icon sources
│   └── sounds/                     # Scanner beep
├── images/                         # README banner, screenshots, store icons
├── lib/
│   ├── main.dart                   # Entry point: Firebase, Crashlytics, font licenses, AppVersion, AppBinding, saved locale
│   ├── app.dart                    # QrationApp: GetMaterialApp with themes, routes and localization
│   ├── core/
│   │   ├── bindings/               # AppBinding (permanent dependencies)
│   │   ├── constants/              # AppConstants, AppVersion, changelog entries
│   │   ├── controllers/            # ScannerPreferencesController
│   │   ├── routes/                 # AppRoutes (names), AppPages (GetPage list)
│   │   ├── services/               # ChangelogService
│   │   ├── theme/                  # Colors, accent presets, fonts, radii, themes, ThemeController
│   │   ├── utils/                  # Code type icons/texts, validators, RescanGuard, QR decoration, downloads saver, permissions
│   │   └── widgets/                # Shared App* widgets, CodeListTile, SectionCard, SyncStatusBanner
│   ├── features/
│   │   ├── auth/                   # controllers, screens (login, signup, reset password), services (SessionStore), widgets
│   │   ├── codes/                  # bindings, controllers, models, screens (scanner, create, details), services, widgets
│   │   ├── export/                 # services: CSV, Excel, PDF data and PDF layout
│   │   ├── favorites/              # controllers, screens
│   │   ├── history/                # controllers, screens, widgets (filter sheet)
│   │   ├── home/                   # bindings, screens (bottom navigation shell)
│   │   ├── onboarding/             # models, screens
│   │   ├── settings/               # bindings, controllers, screens (settings, database, info, privacy, support), services, widgets
│   │   ├── splash/                 # screens
│   │   ├── user/                   # models (UserModel), screens (profile), widgets (account info card)
│   │   └── welcome/                # screens
│   └── l10n/                       # ARB files (EN, IT), generated AppLocalizations, L10n.all
├── test/                           # Unit, widget, accessibility and multi-layer tests (mirrors lib/)
├── integration_test/               # End-to-end tests on a device or emulator
├── tool/
│   ├── icons/                      # generate_icons.ps1
│   └── preview/                    # README banner and screenshot generator
├── deploy_android.ps1              # Release APK build script
├── PRIVACY.md
└── pubspec.yaml
```

**Inside a feature:** `bindings/` (GetX bindings for the feature's routes), `controllers/`, `models/`, `screens/`, `services/`, `widgets/`. A feature only has the folders it needs.

**Conventions:**
- One public class per file; the file name is the class name in snake_case.
- Widgets shared by more than one feature live in `lib/core/widgets/` and are prefixed `App*` (`AppButton`, `AppTextField`, `AppToast`, `AppLoader`, `AppEmptyState`, `AppErrorState`, `AppDeleteDialog`, `AppChangelogDialog`, `AppLogo`). Widgets used by a single feature live in that feature's `widgets/`.
- Screens never instantiate controllers or services: they get them with `Get.find`.
- Every source file starts with the copyright header.

---

## 4. Data models

Codes and profiles live in Cloud Firestore; preferences and backup timestamps live on the device in `SharedPreferences`; logo images live on the device in `<app documents>/logos/`.

### CodeModel

A scanned or created QR code or barcode. Firestore path: `users/{uid}/codes/{codeId}`.

| Field | Type | Firestore key | Description |
|---|---|---|---|
| `id` | `String` | `id` | Firestore document ID, also stored in the document |
| `barcode` | `Barcode` | `type`, `content` | `BarcodeType` name and raw value |
| `date` | `DateTime` | `date` | Scan or creation time, ISO 8601 string |
| `isFavorite` | `bool` | `isFavorite` | Favorite flag, default `false` |
| `source` | `CodeSource` | `source` | `scanned`, `created` or `unknown` |
| `eyeColor` | `Color` | `eyeColor` | Finder pattern color as ARGB int, default black |
| `eyeRounded` | `int` | `eyeRounded` | Finder pattern rounding, `0` = square |
| `moduleColor` | `Color` | `moduleColor` | Module color as ARGB int, default black |
| `moduleRounded` | `int` | `moduleRounded` | Module rounding, `0` = square |
| `socialMedia` | `CodeSocial?` | `socialMedia` | Social network name, `null` for standard codes |
| `notes` | `String?` | `notes` | User notes |
| `logoPath` | `String?` | `logoPath` | Local path of the center logo. Only the path is synced: the image file stays on the device that created it |

`CodeModel.fromMap` is lenient: an unknown `type` becomes `BarcodeType.unknown`, an unknown `source` becomes `CodeSource.unknown`, and missing colors, rounding and favorite flag fall back to their defaults. `socialMedia` is stored and read back as the network name only.

### CodeSocial

Metadata of the social network of a social code.

| Field | Type | Description |
|---|---|---|
| `name` | `String` | Network name (`YouTube`, `Instagram`…) |
| `url` | `String` | Base profile URL |
| `icon` | `IconData` | Network icon |

Supported networks: YouTube, Facebook, Instagram, TikTok, Telegram, LinkedIn, X, Pinterest, Spotify, WhatsApp.

### Standard barcode types

`BarcodeType` values from `mobile_scanner` that the app creates and parses. Each type has a parser class in `lib/features/codes/models/code_types.dart` (`CodeEmail`, `CodeSms`, `CodeContact`, `CodePhoneNumber`, `CodeUrl`…).

| Type | Content |
|---|---|
| `text` | Free text |
| `url` | Web address |
| `email` | Recipient, subject and body (`MATMSG`) |
| `phone` | Phone number (`tel:`) |
| `sms` | Number and message (`SMSTO:`) |
| `contactInfo` | vCard contact (`BEGIN:VCARD`) |
| `geo` | Coordinates |
| `wifi` | SSID, password, encryption |
| `calendarEvent` | Calendar event (`VEVENT`) |
| `product` | Product code (EAN, UPC) |
| `isbn` | Book ISBN |
| `driverLicense` | Driver's license data |

### UserModel

The signed-in user's profile. Firestore path: `users/{uid}`.

| Field | Type | Description |
|---|---|---|
| `userEmail` | `String` | Email address |
| `userName` | `String` | Display name |
| `userImage` | `String?` | Profile picture URL (Google accounts) |
| `userDate` | `DateTime` | Registration date, stored as a Firestore `Timestamp` |

### Local preferences

Keys stored in `SharedPreferences`.

| Key | Type | Default | Owner | Description |
|---|---|---|---|---|
| `seen_onboarding` | `bool` | `false` | Splash, Onboarding | Onboarding already shown |
| `theme_mode` | `String` | `system` | `ThemeController` | `system`, `light` or `dark`. A legacy `theme_preference` bool is migrated (`true` → `dark`, `false` → `light`) and removed |
| `accent_preset_index` | `int` | `0` | `ThemeController` | Index in `AccentPresets` |
| `language_code` | `String` | none (system) | `QrationApp.languageKey` | `en` or `it` |
| `beepEnabled` | `bool` | `false` | `ScannerPreferencesController` | Beep on scan |
| `vibrateEnabled` | `bool` | `false` | `ScannerPreferencesController` | Vibration on scan |
| `remember_me` | `bool` | `false` | `SessionStore` | Restore the session at startup |
| `user_id` | `String` | none | `SessionStore` | UID the saved session belongs to |
| `changelog_last_seen_version` | `String` | none | `ChangelogService` | Last version whose "What's new" dialog was shown |
| `backup_last_export_<uid>` | `int` | none | `BackupHistory` | Epoch milliseconds of the last successful JSON export |
| `backup_last_import_<uid>` | `int` | none | `BackupHistory` | Epoch milliseconds of the last successful JSON import |

### Security rules

The rules are not in the repo: they are edited and published only from the Firebase console of project `qration-b5a7a` (Firestore → Rules, Storage → Rules). `.firebaserc` links the repo to the project for the Firebase CLI. This table is the documented copy to compare with the console before a release.

| Path | Allowed operations | Who |
|---|---|---|
| `users/{uid}` | `get`, `create`/`set` (sign-up, first Google sign-in), `delete` (account deletion); no `list` | `request.auth.uid == uid` |
| `users/{uid}/codes/{codeId}` | Stream and `get` of the collection; queries `isFavorite ==`, `source ==`, `socialMedia != null` (+ `source ==`); `set` (add, import); `update` of `notes` and `isFavorite` only; single and bulk `delete` | `request.auth.uid == uid` |
| Any other Firestore path | — | Denied |
| Storage (whole bucket) | Not used: there is no `firebase_storage` dependency and logos stay on the device | Denied |

The rules also check document shape: `users/{uid}` accepts only `userEmail`, `userName`, `userImage`, `userDate`; a new code accepts only the keys of `CodeModel.toMap()`, with `id` equal to the document ID. Adding a field to `UserModel` or `CodeModel`, or a new path, requires updating the rules in the same release. The app uses no `collectionGroup` queries, transactions or batches.

Signed-out clients cannot read `users`, so email existence checks come from Firebase Auth error codes, not from Firestore queries (see [AuthController](#71-authcontroller-and-sessionstore)).

**Unauthenticated check:** this request must return `403 PERMISSION_DENIED`:

```bash
curl "https://firestore.googleapis.com/v1/projects/qration-b5a7a/databases/(default)/documents/users"
```

---

## 5. Screens and features

### 5.1 Splash

**Path:** `lib/features/splash/`

Shows the animated logo and routes the user to the right screen.

**Features:**
- First launch (`seen_onboarding` false) → Onboarding; signed out → Welcome; restorable session → Home.
- The 350 ms minimum delay only lets the logo animation be seen before the redirect.
- **Session restore:** Home is opened only when `SessionStore.canRestore(uid)` is true, i.e. a Firebase user is signed in **and** the saved "Remember me" session belongs to that same UID. Firebase restores the persisted user asynchronously, so `currentUser` can still be `null` at startup: the splash waits for the first signed-in `authStateChanges()` event, with a 5 s timeout, instead of reading it synchronously. No Firestore read happens here, so a valid session also opens offline.
- **Android Auto Backup:** Firebase Auth stores the user in `shared_prefs/com.google.firebase.auth.api.Store.<id>.xml`, encrypted with an Android Keystore key (`...api.crypto.<id>.xml`). Keystore keys are never backed up, so if Auto Backup restored those files after a reinstall Firebase could neither read nor overwrite them, and every new sign-in would live only in memory. `AndroidManifest.xml` therefore sets `android:fullBackupContent="@xml/backup_rules"` (Android 6–11) and `android:dataExtractionRules="@xml/data_extraction_rules"` (Android 12+), which exclude both files from backup and device transfer. The file names contain `base64("[DEFAULT]")+base64(mobilesdk_app_id)` and must be updated if the Firebase app in `google-services.json` changes.

### 5.2 Onboarding

**Path:** `lib/features/onboarding/`

Shown once, on first launch. Swipeable pages present the main features with a `SmoothPageIndicator`, which screen readers announce as "Page X of Y". At the end it sets `seen_onboarding` and opens Welcome.

### 5.3 Welcome

**Path:** `lib/features/welcome/`

Entry screen for signed-out users with **Log in** (→ Login) and **Sign up** (→ Signup) buttons.

### 5.4 Authentication

**Path:** `lib/features/auth/`

Email/password and Google authentication on Firebase Auth. Logic is in `AuthController` (see [7.1](#71-authcontroller-and-sessionstore)).

**Features:**
- **Login (`login_screen.dart`):** email and password, "Continue with Google", "Remember me" checkbox (merged with its label for screen readers) and links to Sign up and Reset password. The "Remember me / Forgot password?" row is a `Wrap` so it does not overflow with large text.
- **Signup (`signup_screen.dart`):** name, email, password and confirmation with form validation; creates the Firestore profile after registration. The same "Continue with Google" button as Login sits below the form, separated by `AuthDivider`.
- **Reset password (`reset_password_screen.dart`):** sends the Firebase reset email.
- **Errors:** shown as toasts. `email-already-in-use` → `email_already_register`, `user-not-found` → `email_not_found`; other Firebase codes (e.g. `invalid-credential`) are shown as they come. With email enumeration protection enabled on the project, an unknown email at login returns `invalid-credential` and reset password reports no error.
- After every login, signup, reset or logout the form fields and "Remember me" are cleared (`clearForm()`), because `AuthController` is permanent and would otherwise keep typed data in memory.

### 5.5 Home

**Path:** `lib/features/home/`

Shell with a 5-item bottom navigation bar; the tabs live in an `IndexedStack`, so they keep their state while switching.

| # | Tab | Screen |
|---|---|---|
| 1 | Scan | `ScannerScreen` (selected when the app opens) |
| 2 | Create | `CodeCreateTypesScreen` |
| 3 | Favorites | `FavoritesScreen` |
| 4 | History | `HistoryScreen` |
| 5 | Settings | `SettingsScreen` |

**Features:**
- The scanner is the first tab so a code can be scanned right after opening the app.
- Tabs have no `AppBar` of their own.
- Each tab is wrapped in `HeroMode(enabled: i == _selectedIndex)`: History and Favorites stay built while hidden, and only the visible one may take part in `Hero` animations, otherwise the same code in both lists would produce duplicate Hero tags.
- Empty states of Favorites and History receive `onCreateCode`/`onScanNow` callbacks from Home that switch tab, so features do not depend on each other.
- On the first frame, `AppChangelogDialog.maybeShow` shows the "What's new" dialog if there are versions the user has not seen (see [5.12](#512-settings) and [7.3](#73-changelogservice)).

### 5.6 Scanner

**Path:** `lib/features/codes/screens/code_scanner_screen.dart` (UI) + `lib/features/codes/controllers/scanner_controller.dart` (pipeline)

Scans QR codes and barcodes with the camera or from a gallery image and opens the code details.

**Features:**
- Live camera preview with a scrim outside a 264×264 window (`_ScrimPainter`, an even-odd path) and a laser line animated for 1.8 s back and forth.
- Zoom slider, torch button (filled and gold when on, disabled when `TorchState.unavailable`, e.g. front camera) and gallery import. Every control has a tooltip, a ripple and `HapticFeedback.selectionClick()`.
- Optional beep and vibration, read from `ScannerPreferencesController` at every detection rather than copied in `initState`: the screen lives in the `IndexedStack` and is never rebuilt, so a copy would ignore changes made in Settings.
- A URL that matches a known social network is saved as a social code.
- **Camera lifecycle:** the screen receives `isActive` from Home and starts/stops `MobileScannerController` when the tab is entered or left; the laser animation also runs only while active. Before opening the details the camera is stopped and restarted on return if the tab is still active: leaving the preview running under the new route can crash the Impeller renderer (`Invalid external texture`) and keep the details screen from appearing.
- **Single processing:** `ScannerController.tryBeginDetection` (observable `isProcessing` + `RescanGuard`) prevents parallel processing. Beep and vibration run in their own try/catch, because a device without vibrator or audio output must not block recognition, and `endDetection` runs in a `finally`, so an error never leaves the scanner stuck. While `isProcessing` is true a dark overlay with `AppLoader` covers the camera.
- **Repeated detections:** `RescanGuard` (`lib/core/utils/rescan_guard.dart`) ignores the value still in view and accepts it again only after it has been out of frame for 2 s. `endDetection` calls `touch()` on return from the details, so the cooldown starts then and a code still in frame does not reopen the details immediately. A different code is accepted at once.
- **Save and navigate:** the code is saved with a 3 s timeout (`saveTimeout`). The document ID is generated locally (see [7.2](#72-codesservice)), so on timeout the app still navigates and the write syncs from Firestore's offline cache. Navigation uses `Get.toNamed`, which pushes the details **over** Home and keeps the tab shell underneath; `Get.offNamed` would replace the whole Home.
- **Permission:** `CAMERA`, requested by `permission_helper.dart`.

### 5.7 Code creation

**Path:** `lib/features/codes/screens/` (UI), `lib/features/codes/controllers/` (state), `lib/features/codes/widgets/code_create/` (widgets)

Creates a customized QR code in two steps.

**Step 1 — Type (`code_create_types_screen.dart`):** grid with the 12 standard and 10 social types, each with icon and label and a fade + scale entrance (`flutter_animate`). Tiles grow in height only when the system text size is larger than default.

**Step 2a — Standard (`code_create_standard_screen.dart`, `CodeCreateStandardController`):** a form whose fields depend on the type.

| Type | Fields |
|---|---|
| Text | Content |
| URL | Address |
| Email | Recipient, subject, body |
| Phone | Country prefix + number |
| SMS | Number, message |
| Contact | First name, last name, phone, email |
| Geo | Latitude, longitude, or a point picked on a full-screen map (`FullScreenMap`) |
| Wi-Fi | SSID, password, encryption, hidden network |
| Calendar event | Title, location, start and end |
| Product / ISBN | Numeric code |
| Driver's license | License data |

**Step 2b — Social (`code_create_social_screen.dart`, `CodeCreateSocialController`):** username or profile field for the chosen network; `buildContent()` turns it into the final content (profile URL, Spotify search URI `spotify:search:<artist>;<track>`, `wa.me` link with prefix).

**Shared features:**
- Layout: form fields in a "Content" `SectionCard`, then "Preview" and "Style" cards and a full-width "Create" button (`GenerateButton`, with loading state while saving). The app bar is `CodeCreateAppBar`.
- **Live preview** (`QrPreview`) for every type, rebuilt on every field change (`Listenable.merge` of the text controllers) and every observable choice; a placeholder QR is shown while the form is incomplete.
- **Style** (`QrStyleCustomizer`, state in the `QrStyleMixin` shared by both controllers): eye and module colors, rounding switches, optional logo from the gallery. The color circles are 36 dp with a 48 dp touch area.
- **Logo:** embedded with `PrettyQrDecorationImage` at scale 0.2 and copied to `<app documents>/logos/`. With a logo the error correction level goes from `M` to `H` everywhere the QR is rendered (preview, details, PDF), to compensate for the covered area.
- **Quiet zone:** every QR is rendered with a standard 4-module quiet zone (`buildQrDecoration()` in `qr_decoration.dart`). Without it the modules reach the image edge and decoders such as `mobile_scanner`'s `analyzeImage` (gallery scan) cannot find the finder patterns.
- **Map (Geo):** tiles come from `tile.openstreetmap.org` with a `QRation/<version> (+<repo>; contact: <email>)` User-Agent set through `NetworkTileProvider`, as the OSM tile policy requires (the default `flutter_map (<package>)` agent is blocked with 403), plus the "OpenStreetMap contributors" attribution. No location permission is used: the point is picked by tapping the map.
- Leaving with unsaved content asks for confirmation (`showDiscardDialog`). After saving, the details open with `Get.offNamed`.

### 5.8 Code details

**Path:** `lib/features/codes/screens/code_details_screen.dart` + `CodeDetailsController`

Shows one code and its actions.

**Features:**
- Every entry point opens it through `AppRoutes.codeDetails` with the `CodeModel` as argument; the fade transition (250 ms) is defined once in the `GetPage`. The type icon of `CodeListTile` and of the "Type" chip share the Hero tag `codeIconHeroTag(code.id)`.
- Layout: app bar with a menu (the "Delete" item in the error color), "Date" (`dd/MM/yyyy HH:mm`) and "Type" chips (`CodeInfoRow`), "QR code" `SectionCard` (`CodeQrSection`, announced as an image with a label), a row of labeled quick actions (`CodeActionButtons`) and a "Content" `SectionCard` (`CodeContentCard`) with the type-specific action as a full-width button.

| Action | Description |
|---|---|
| Copy | Copies the content to the clipboard |
| Favorite | Toggles the favorite flag (highlighted when active) |
| Save | Saves the QR image to the gallery |
| Share | Shares the QR image through the system sheet |
| Open | Opens the URL, writes the email, calls, sends the SMS, connects to Wi-Fi, adds the contact or the calendar event, shows the location |
| Notes | Edits the notes in a bottom sheet |
| Delete | Deletes the code after confirmation |

- **Notes sheet:** opened 300 ms after the popup menu item is selected, because pushing a route while the menu route is still closing conflicts with it. The sheet's "Save" button overrides the theme's `minimumSize(double.infinity, 52)` with a finite size: it sits in a `Row`, where an infinite minimum width breaks layout.
- The tap that dismisses the keyboard is excluded from semantics.
- **Permissions:** contacts (`READ_CONTACTS`/`WRITE_CONTACTS`) to add a contact; location and Wi-Fi state permissions, declared for `wifi_iot`, to connect to a network.

### 5.9 Favorites

**Path:** `lib/features/favorites/screens/favorites_screen.dart` + `lib/features/favorites/controllers/favorites_controller.dart`

Favorite codes in two tabs, **Scanned** (`source = scanned`) and **Created** (`source = created`).

**Features:**
- `FavoritesController` subscribes once to `getFavoriteCodesStream()` and exposes `isLoading`, `error`, `hasFavorites` and the two lists, already split by source and sorted by date descending (recomputed only on stream events).
- Items are `CodeListTile`s; a tap opens the details. Tab labels truncate with an ellipsis at large text sizes.
- States: loading (`AppLoader`), error (`AppErrorState`), empty (`AppEmptyState` with "Create your first code").
- Sync banner and pull-to-refresh as in [History](#510-history), with one `RefreshIndicator` per tab, because an outer one would not receive the vertical scroll of lists nested in the horizontal `TabBarView`.

### 5.10 History

**Path:** `lib/features/history/screens/history_screen.dart` + `lib/features/history/controllers/history_controller.dart`

All of the user's codes, with search, filters and bulk delete. The screen holds only UI state (search `TextEditingController` and `FocusNode`); everything else is in `HistoryController`.

**Features:**
- **Stream:** subscribed once in `onInit` (`getCodesStream()`), exposed as `isLoading`/`error`.
- **Search** by content, debounced 300 ms (`searchInput` → `searchKeyword`).
- **Filter sheet** (`HistoryFilterSheet`, opened from the filter icon): source (`SegmentedButton` All / Created / Scanned), code type and social network (`FilterChip`s with icon and label in a `Wrap`). Filters apply live; "Clear filters" (`clearSheetFilters()`, keeps the search) and "Show results" close the sheet. Type and social filters are OR-ed together, then AND-ed with search and source.
- **Active filters badge** on the filter icon (`activeFilterCount`: types + social + source; the search is excluded because it is already visible); the icon turns primary when filters are active.
- `filteredCodes` is memoized: an `everAll` worker recomputes it (filter + date sort) only when an input changes. The pure logic is the static `HistoryController.filterCodes`, tested on its own.
- **Selection mode:** entered from the trash button or with a long press on a card (`startSelectionWith`, `mediumImpact` haptic). The search row turns into a contextual bar (close, "N selected" in an `Expanded` with ellipsis, select/deselect all, delete) with a 220 ms `AnimatedSwitcher`. Each toggle gives a `selectionClick` haptic, and each card has its own `Obx`, so toggling rebuilds only that card.
- **Bulk delete** (`deleteSelected`): the deletes run in parallel with `Future.wait`; `isDeleting` is reset in a `finally`. The toast reports the count (`history_screen_deleted_count`, ICU plural) after a `context.mounted` check. `AppDeleteDialog` pops itself before calling `onConfirm`, so callers must not pop again: History has no route of its own, and an extra pop would close Home.
- **States:** `hasCodes` and `hasActiveFilters` tell a real empty list ("No saved codes" + "Scan now") from an empty filter result ("No results for the active filters" + "Clear filters", which also clears the search field).
- **Sync status:** `getSyncStatusStream()` maps Firestore metadata to `SyncStatus` (`hasPendingWrites` → `pending`, `isFromCache` → `offline`, otherwise `synced`). `SyncStatusMixin` (shared with Favorites) exposes `syncStatus` and `refreshCodes()`. `offline` is shown only after 2 s (`offlineGracePeriod`), because at startup Firestore answers from cache first even with network and the banner would flash; `pending` is immediate. `SyncStatusBanner` appears above the list only in those two states.
- **Pull-to-refresh** calls `refreshCodes()` (a `Source.server` read that refreshes cache and stream); a toast appears if the server is unreachable. Lists use `AlwaysScrollableScrollPhysics` and empty states are wrapped in `PullToRefreshFill`, so the gesture works with few or no items.

**`CodeListTile`** (`lib/core/widgets/code_list_tile.dart`) is the single card of every code list: type icon, content, date, optional source (`showSource`) and selection state (`selectable`). It uses `AppRadius.large`, a vertical margin of 6 and the shared `CodeListTile.listPadding`.

### 5.11 Profile

**Path:** `lib/features/user/`

Account details, logout and account deletion. Opened from Settings → Profile.

**Features:**
- Header with avatar (photo or initial, ring in the primary color), name and email; data loaded from Firestore through `AuthController.getUserDetails()`, with `AppLoader` while loading.
- `AccountInfoCard`: name, email and account creation date (`dd/MM/yyyy`).
- "Log out" and "Delete account" buttons (`AppButton.outlined`, the second in the error color).
- **Account deletion:** "Delete account" opens an `AppDeleteDialog` (title `delete_title`, message `delete_d_description`, confirm `delete_d_title`). On confirm, a full-screen overlay with `AppLoader` blocks the screen while `AuthController.deleteAccount()` runs. On success: `toast_delete_success` and `Get.offAllNamed(AppRoutes.welcome)`. On failure (e.g. Firebase `requires-recent-login`) the overlay is removed and `toast_delete_error` asks the user to sign in again and retry.

### 5.12 Settings

**Path:** `lib/features/settings/screens/settings_screen.dart`

Global configuration in four groups. Building blocks are in `lib/features/settings/widgets/settings_tiles.dart`: `SettingsGroup` (title + card), `SettingsNavTile` (row with chevron, or `trailingIcon` for external links), `SettingsSwitchTile` (row with `Switch`, toggled by tapping the whole row and merged into one semantics node) and `SettingsSegmentedTile<T>` (single-choice `SegmentedButton`, horizontally scrollable). State comes from `SettingsController` through `Obx`.

| Group | Item | Behavior |
|---|---|---|
| General | Theme | System / Light / Dark (`SegmentedButton<ThemeMode>`) |
| General | Language | Italiano / English; saved to `language_code` and applied with `Get.updateLocale` |
| General | Accent color | One of 8 `AccentPresets`, shown as swatches with the name in a tooltip |
| Scan | Beep | Sound on scan |
| Scan | Vibration | Vibration on scan |
| Account | Profile | Opens [Profile](#511-profile) |
| Account | Database | Opens [Database](#513-database) |
| Account | Log out | Signs out |
| App | Info | Opens Info |
| App | Changelog | `AppChangelogDialog.showAll`: the full history of `changelogEntries` |
| App | Support | Opens Support (FAQ in `CustomExpansionTile`s, contact rows in `SectionLinkRow`s) |
| App | Share | Shares `AppConstants.uriGithubRepository` through the system sheet |

**Info** (`info_screen.dart`):
- Header with logo, name, tagline and a pill with `AppVersion.current`.
- "What is QRation" card with the description and the origin of the name.
- Features grid: 2×2 cards (Scan, Create, Organize, Export), each row in `IntrinsicHeight` so both cards share the height.
- Useful links: source code, website, contact, Privacy Policy (internal route), open source licenses (`showLicensePage` with logo and version). External links use `mgc_external_link_line` as trailing icon.
- Footer `info_screen_made_by` with `AppConstants.developerName`.

**Privacy Policy** (`privacy_policy_screen.dart`, reached only from Info): native, localized policy. Shows the update date (`AppConstants.privacyPolicyUpdatedAt`, formatted with `DateFormat.yMMMMd` in the current language), the intro, 10 sections in `SectionCard`s (ARB keys `policy_section_*_title`/`_text`; the controller section fills `{name}`/`{email}` from `AppConstants.developerName`/`developerEmail`) and an "Online version" link to `AppConstants.uriPrivacyPolicy`. The same text is in `PRIVACY.md`: `PRIVACY.md`, the ARB keys, `privacyPolicyUpdatedAt` and the online page change together. Any new service, permission or data flow (analytics, ads, network plugins) requires a policy update before the release.

**"What's new" dialog** (`lib/core/widgets/app_changelog_dialog.dart`):
- Entries are in `lib/core/constants/changelog.dart`: `changelogEntries`, a list of `ChangelogEntry` sorted newest first, each with `ChangelogItem`s typed by `ChangeType` (`added`, `improved`, `fixed`, `security`).
- Each version is grouped in sections in that order (New, Improvements, Fixes, Security) with MingCute icons (`sparkles`, `rocket`, `bug`, `shield`); empty sections are hidden.
- The dialog title is "What's new"; the Settings item is "Changelog". Items are one user-facing sentence each; internal refactors are not listed. The `version` of an entry matches `version:` in `pubspec.yaml`.
- The version shown in the dialog and in Info is `AppVersion.current` (`lib/core/constants/app_version.dart`), read at startup with `package_info_plus`.

### 5.13 Database

**Path:** `lib/features/settings/screens/database_screen.dart` + `DatabaseController`

Statistics, exports and JSON backup of the user's codes.

**Features:**
- **Statistics** (`StatisticsSection`): three `_StatCard`s (Total, Created, Scanned), a `_DistributionBar` with the created/scanned ratio and two `_SourceTile`s that expand to the per-type breakdown (standard and social).
- **Export and import** (`ExportImportSection`): one `SectionCard` with two titled groups.
  - **Documents:** PDF, Excel and CSV tiles (see [7.6](#76-csv-export)–[7.8](#78-pdf-export)); the share sheet opens after generation.
  - **Backup:** "Create backup" (`exportCodes`, JSON) and "Restore" (`importCodes`, JSON picked with `file_picker`). Restored codes are **added** to the existing ones, each with a new ID, so restoring the same backup twice duplicates it; the section text says so. Below the buttons, "Last backup" and "Last restore" show date and time, or "Never" (see [7.4](#74-backuphistory)). Button labels wrap at large text sizes.
- Every operation shows an animated progress overlay (`loading_overlays.dart`).

---

## 6. State management

GetX. Screens get controllers only with `Get.find`; registration is centralized in bindings.

| Binding | Attached to | Registers |
|---|---|---|
| `AppBinding` (`lib/core/bindings/`) | `main()`, before `runApp` (`QrationApp` reads `ThemeController` on the first frame) | Permanent: `ThemeController`, `ScannerPreferencesController`, `CodesRepository` (`CodesService`), `AuthController` |
| `HomeBinding` (`features/home/bindings/`) | `home` | `ScannerController`, `FavoritesController`, `HistoryController`, `SettingsController`. They follow the Home route, so logout (`offAllNamed`) disposes them and they are recreated for the next user |
| `ScannerBinding` | `scanner` | `ScannerController` |
| `SettingsBinding`, `DatabaseBinding` (`features/settings/bindings/`) | `settings`, `settingsDatabase` | `SettingsController`, `DatabaseController` (with the current UID) |
| `CodeCreateStandardBinding`, `CodeCreateSocialBinding`, `CodeDetailsBinding` (`features/codes/bindings/code_bindings.dart`) | `codeCreateStandard`, `codeCreateSocial`, `codeDetails` | The screen's controller, built from the route argument (`BarcodeType`, `CodeSocial`, `CodeModel`). With a missing or wrong argument they register nothing and the `GetPage` falls back to `HomeScreen` |

Route bindings use `Get.lazyPut`: the controller is created on the first `Get.find` and removed when the route closes.

| Controller | Path | Responsibility |
|---|---|---|
| `ThemeController` | `lib/core/theme/` | Theme mode, accent preset, persistence, `SystemChrome` colors (also on platform brightness changes) |
| `ScannerPreferencesController` | `lib/core/controllers/` | Observable, persisted `beepEnabled`/`vibrateEnabled` |
| `AuthController` | `lib/features/auth/controllers/` | Sign-up, login, Google sign-in, reset, logout, profile read, account deletion, form state |
| `SettingsController` | `lib/features/settings/controllers/` | Stateless facade over `ThemeController` and `ScannerPreferencesController` for the Settings screen |
| `DatabaseController` | `lib/features/settings/controllers/` | Statistics, PDF/Excel/CSV export, JSON export/import, last backup timestamps |
| `HistoryController` | `lib/features/history/controllers/` | Code stream, debounced search, filters, memoized list, selection, bulk delete |
| `FavoritesController` | `lib/features/favorites/controllers/` | Favorites stream, loading/error, per-tab sorted lists |
| `ScannerController` | `lib/features/codes/controllers/` | Detection guard, feedback, `CodeModel` building (social templates), save with timeout |
| `CodeCreateStandardController` | `lib/features/codes/controllers/` | Standard form fields, content generation per type, style, save |
| `CodeCreateSocialController` | `lib/features/codes/controllers/` | Social form fields, `buildContent()`, style, save |
| `CodeDetailsController` | `lib/features/codes/controllers/` | Favorite, notes, image save/share, type actions, delete |

`ThemeController` only exposes observable state (`themeMode`, `currentAccent`) and never calls `Get.changeTheme`: `QrationApp` builds `theme:`/`darkTheme:`/`themeMode:` inside the `Obx` around `GetMaterialApp`, so it is the single source of truth and a rebuild cannot reset the accent.

---

## 7. Services

### 7.1 AuthController and SessionStore

**Path:** `lib/features/auth/controllers/auth_controller.dart`, `lib/features/auth/services/session_store.dart`

Firebase Auth and Firestore profile operations. `FirebaseAuth`, `FirebaseFirestore`, `GoogleSignIn`, `SessionStore` and navigation (`navigateTo`/`navigateBack`) are constructor parameters with real defaults. `login`/`signup`/`resetPassword` validate the `Form` and call `submitLogin`/`submitSignup`/`submitResetPassword`, which hold the logic and can be tested without widgets. The last error is in `lastError`; error toasts use the nullable `Get.key.currentContext`.

- `submitSignup()`: creates the Firebase credentials and the `UserModel` document; saves the session.
- `submitLogin()`: `signInWithEmailAndPassword`; saves the session only if "Remember me" is checked.
- `loginWithGoogle()`: `GoogleSignIn.instance` (API v7). `initialize()` must be awaited once before any other call, so `_ensureGoogleSignIn()` memoizes it per instance (`Expando`). `authenticate()` opens the account picker (Credential Manager on Android); a `canceled` `GoogleSignInException` is ignored. Firebase receives only the `idToken`: the app requests no OAuth scopes. Creates the profile if missing and always saves the session.
- `submitResetPassword()`: `sendPasswordResetEmail`.
- `getUserDetails()`: reads `users/{uid}` as `UserModel`.
- `logout()`: signs out of Firebase and Google and clears the session.
- `deleteAccount()`: deletes every document in `users/{uid}/codes`, then `users/{uid}`, then the Firebase user, then logs out. Errors are logged and rethrown to the caller.
- `_authErrorKey()`: maps Firebase codes to ARB keys (see [5.4](#54-authentication)).

`SessionStore` saves `remember_me` and `user_id`; `canRestore(uid)` is true only when both match the given UID.

Tests: `test/features/auth/controllers/auth_controller_test.dart` (with `firebase_auth_mocks`, `fake_cloud_firestore` and a mocktail `GoogleSignIn`), `test/features/auth/services/session_store_test.dart`.

### 7.2 CodesService

**Path:** `lib/features/codes/services/codes_service.dart` (implements `CodesRepository`)

Firestore access to `users/{uid}/codes`.

- `addCode(code)`: generates the ID locally with `collection.doc()` (synchronous, no network), assigns it to `code.id` and writes with a single `set()`.
- `deleteCode(id)`, `deleteAllCodes()`, `updateCodeNotes(id, notes)`, `toggleFavoriteStatus(codeId, isFavorite)`.
- `getCodesStream()`, `getFavoriteCodesStream()`, `getSocialCodesStream()`: real-time lists.
- `getSyncStatusStream()`: `snapshots(includeMetadataChanges: true)` mapped by `syncStatusFrom` to `SyncStatus`.
- `refreshCodes()`: `GetOptions(source: Source.server)` read.
- `countAllCodes()`, `countCodesBySource(source)`, `countCodesByType(source)`, `countSocialCodesByType(source)`: statistics.
- `exportCodesToJson()`, `importCodesFromJson(json)`: backup format; import calls `addCode` for each code, so every restored code gets a new ID.

Tests: `test/features/codes/services/codes_service_test.dart` (`fake_cloud_firestore`).

### 7.3 ChangelogService

**Path:** `lib/core/services/changelog_service.dart`

Decides which changelog entries to show automatically.

- `pendingEntries(...)`: returns the entries newer than `changelog_last_seen_version`, relying on `changelogEntries` being sorted newest first, and saves the current version as seen. On a fresh install (no saved version) it returns nothing.

The key name is `changelog_last_seen_version` and must not be renamed: existing installs would look new and skip the next update's notes.

Tests: `test/core/services/changelog_service_test.dart` (first install, update, unknown version, same version), `test/core/constants/changelog_test.dart` (section order; every `changelog_v*` key in the English ARB used exactly once), `test/core/widgets/app_changelog_dialog_test.dart` (every version and item rendered in English and Italian).

### 7.4 BackupHistory

**Path:** `lib/features/settings/services/backup_history.dart`

Stores on the device, per user, when the last JSON export and import succeeded (`backup_last_export_<uid>`, `backup_last_import_<uid>`). `DatabaseController` exposes them as `lastExportAt`/`lastImportAt`.

Tests: `test/features/settings/services/backup_history_test.dart`.

### 7.5 Public Downloads copy

**Path:** `lib/core/utils/downloads_saver.dart`

`saveBytesToPublicDownloads(...)` copies an exported file (PDF, Excel, CSV, JSON) to the public Download folder through the native method channel `com.ndn21.qration/downloads`. On Android 10+ (API 29+) it uses `MediaStore` with no permission; on Android 9 and lower it first requests `WRITE_EXTERNAL_STORAGE`, which the manifest caps with `maxSdkVersion="28"`. The primary copy is written to `getDownloadsDirectory()`, which on Android is app-private and deleted on uninstall: hence the public copy.

### 7.6 CSV export

**Path:** `lib/features/export/services/csv_service.dart`

All codes, newest first. Columns: ID, Date, Source, Type, Content, Eye color, Eye rounding, Module color, Module rounding, Favorite, Social; colors as `#RRGGBB`; localized headers. Saved as in [7.5](#75-public-downloads-copy).

### 7.7 Excel export

**Path:** `lib/features/export/services/excel_service.dart`

XLSX with the `excel` package, sheet `QRationData`: bold "QRation" title row, styled header row, the same columns as the CSV, and column widths computed from the longest value. Saved as in [7.5](#75-public-downloads-copy).

### 7.8 PDF export

**Path:** `lib/features/export/services/pdf_service.dart` (data), `lib/features/export/services/pdf_report.dart` (layout)

- `PdfService.generateCodesPdf(onProgress)`: reads the codes (newest first), localizes the type (`readableCodeType`), renders each QR at 300 px with its colors, shapes and logo (`buildQrDecoration`; a missing logo file is skipped), counts by type (`countByType`), builds a `PdfReportData` and saves the file. Progress is reported through a `Function(double)`; QR rendering is the slow part.
- `buildPdfReport(data, assets, l10n)`: builds the A4 document from `PdfReportData`, `PdfReportAssets` (Montserrat regular and bold, logo) and `AppLocalizations`, with no Firebase or Flutter widget dependency, so it is testable.

Document layout:
- **Cover:** logo, "QRation", subtitle (`pdf_report_subtitle`), gold rule, account name and email, code count chip.
- **Following pages** (`pw.MultiPage`): header with logo and "QRation"; footer "Page X of Y" (`pdf_report_page`).
- **User info:** name, email, account creation date, user ID.
- **Statistics:** saved/created/scanned tiles and two per-type cards (Standard, Social). Social codes count only under their network, not also as URL; the `Link` value of plain URLs is not a network and is not listed.
- **Codes:** one unbreakable card per code (about five per page) with QR, Type/Source/social/Favorite chips, content, date and time, notes and, for created codes only, the style.
- **Last page:** logo, "QRation", `info_screen_made_by` with `AppConstants.developerName`, developer email, website and "© <export year> Nicola De Nicolais. All rights reserved." (`pdf_report_rights`); no header or footer.

Dates use the app language (`DateFormat.yMMMMd(l10n.localeName)`); code dates use `dd/MM/yyyy HH:mm`. Colors: `qrBlue` text, `qrGold` accents, `cardLight`/`dividerLight` cards.

Tests and preview: `test/features/export/pdf_report_test.dart` builds a sample report, checks its page count stays bounded and, if `QRATION_PDF_PREVIEW` holds a path, writes the PDF there: `QRATION_PDF_PREVIEW=preview.pdf flutter test test/features/export/pdf_report_test.dart`.

---

## 8. Theme and style

**Path:** `lib/core/theme/`

**Font:** Montserrat, bundled in `assets/fonts/` (`Montserrat.ttf` registered as weight 400, `Montserrat-Bold.ttf` as weight 700, family `Montserrat`) and used through `AppFonts.montserrat(...)` only inside the theme. `QrationIcons.ttf` holds the custom icons. Montserrat is under the SIL Open Font License 1.1, which requires shipping its license: `assets/fonts/OFL.txt` is registered in `main()` with `LicenseRegistry.addLicense`, so it appears in the open source licenses page, which otherwise lists only pub packages. Any new bundled font must be registered the same way.

**App icon:** every icon comes from `assets/images/app_logo.png` (navy stylized QR on transparent background).
1. `powershell -ExecutionPolicy Bypass -File tool\icons\generate_icons.ps1` generates `assets/images/app_icon_legacy.png` (logo at 64% on a rounded white square, for Android 7 launchers that apply no mask), `app_icon_foreground.png` (62%, transparent) and `app_icon_monochrome.png` (62%, black silhouette), plus `images/icons/` `icon_512` (Play Store), `icon_192`, `oauth_logo_120` (Google consent screen) and `favicon_32` on white `#FFFFFF`.
2. `dart run flutter_launcher_icons` generates the Android icons from the `flutter_launcher_icons` block in `pubspec.yaml` (`android: "launcher_icon"`, `min_sdk_android: 24`, legacy image, white adaptive background, foreground and monochrome layers). The monochrome layer is used by Android 13+ themed icons, which read only its alpha.

The manifest uses `@mipmap/launcher_icon`; on Android 12+ the system splash uses it automatically. Inside the app `AppLogo` (`lib/core/widgets/app_logo.dart`) tints the logo with the theme primary (`BlendMode.srcIn`), so it follows the accent and stays visible on dark backgrounds; the PDF uses the original navy file.

**Themes:** `AppTheme.lightTheme({Color primary})` and `AppTheme.darkTheme({Color primary})`. The mode (`ThemeMode.system`/`light`/`dark`) and the accent are chosen in Settings and persisted by `ThemeController` (see [Local preferences](#local-preferences)). In System mode `ThemeController` follows `didChangePlatformBrightness` to update `SystemChrome` colors.

**Accent colors:** `primary` replaces the brand color of the theme (`colorScheme.primary`/`tertiary`, app bar, navigation bar, buttons, focus borders, selected switches and checkboxes, pickers, cursor, chips, list tile icons). The complementary color (gold in light, light blue in dark) stays fixed to keep contrast.

| Preset (`AccentPresets`) | Light | Dark |
|---|---|---|
| `blue` (default) | `#274060` (`qrBlue`) | `#CCA775` (`qrGold`) |
| `green` | `#1F5C4A` | `#6FCF9E` |
| `purple` | `#4A2E6E` | `#B48AE0` |
| `red` | `#7A2333` | `#E8869A` |
| `teal` | `#14555C` | `#6FD1DA` |
| `orange` | `#7A4A12` | `#E8A85C` |
| `pink` | `#7A2E55` | `#E58FBE` |
| `grey` | `#3A3A3A` | `#B0B0B0` |

**Palette** (`app_colors.dart`):

| Name | Value | Usage |
|---|---|---|
| `qrBlue` | `#274060` | Brand blue, light primary, PDF text |
| `qrBlueDark` / `qrBlueLight` | `#1A2E46` / `#3A5A82` | Blue variants; `qrBlueLight` is the dark `secondary` |
| `qrGold` | `#CCA775` | Brand gold, dark primary, light `secondary`, PDF accents |
| `qrGoldDark` / `qrGoldLight` | `#B8935E` / `#DDBB90` | Gold variants |
| `qrWhite` | `#FFFFFF` | Text on colored buttons |
| `surfaceLight` / `surfaceDark` | `#FFFFFF` / `#1A2E46` | `surface` |
| `surfaceVariantLight` / `surfaceVariantDark` | `#F5F3F0` / `#1F3554` | `surfaceContainerHighest`, README banner background |
| `cardLight` / `cardDark` | `#FAF8F5` / `#243D5E` | Cards |
| `dividerLight` / `dividerDark` | `#E8E4DF` / `#2D4A6E` | Dividers |
| `textPrimaryLight` / `textPrimaryDark` | `#274060` / `#FFFFFF` | `onSurface` |
| `textSecondaryLight` / `textSecondaryDark` | `#4C6A8D` / `#CCA775` | `onSurfaceVariant` (light value is at least 5:1 on surface, card and surface variant) |
| `textHintLight` / `textHintDark` | `#9BAFC4` / `#7A9BBF` | Field hints |
| `error` | `#D80032` | `colorScheme.error`, field error text and borders |
| `scannerCorner` | `#CCA775` | Scanner window corners |
| `qrMarkerColor` | `#E12729` | Geo map marker |

`success`, `successLight`, `errorLight`, `warning`, `warningLight`, `info`, `infoLight`, `scannerOverlay` and the `toast*`/`successColor`/`errorColor` aliases are defined but not used by any screen; toasts take their colors from `toastification`'s `flatColored` style.

`ColorScheme` roles used by screens: `primary` (accents, icons, main action), `secondary` (complementary color), `tertiary` (= primary, overlays), `surface`/`onSurface`, `surfaceContainerHighest`, `onSurfaceVariant` (secondary text), `error`/`onError`.

**Typography:** screens use `Theme.of(context).textTheme` roles, with `copyWith` only for color, weight or line height; no hand-written sizes. Defined in `_buildTextTheme` (`app_theme.dart`):

| Role | Size | Usage |
|---|---|---|
| `displaySmall` | 36 | Welcome title, avatar initial |
| `headlineMedium` | 28 w500 | Login, signup and onboarding titles |
| `headlineSmall` | 24 w500 | App name in Info, statistic numbers |
| `titleLarge` | 20 w500 | Dialog titles, prominent messages |
| `titleMedium` | 18 w500 | Group titles, empty and error states |
| `titleSmall` | 15 w500 | Section headers (`SectionHeader`), card titles |
| `bodyLarge` | 16 | Field text, long text |
| `bodyMedium` | 14 | Body text |
| `bodySmall` | 12, secondary color | Subtitles, captions |
| `labelLarge` | 14 w500 | Row and tile titles |
| `labelMedium` | 12 w500 | Chips, badges, labels |
| `labelSmall` | 11 w500, secondary color | Tile labels, legends |

**Radii:** only `AppRadius` tokens: `extraSmall` 4 (indicators, bars), `small` 8 (chips), `medium` 12 (buttons, icon boxes), `large` 16 (cards, tiles, fields), `extraLarge` 20 (`SectionCard`, Settings groups), `dialog` 28, `pill` 100 (pill shapes at any height).

**Sizes and adaptive layout:** padding, font and icon sizes are fixed dp values. Text follows the system text size through `MediaQuery.textScaler`. Layouts adapt with `LayoutBuilder`/`MediaQuery` (e.g. the Export tiles, the type grid tiles), not with global scale factors.

**Screen guidelines:**
- App bars set no colors of their own (`appBarTheme`: surface background, primary title and icons); switches use `switchTheme`.
- Content is grouped in `SectionCard` (`lib/core/widgets/section_card.dart`: header with icon + bordered card; the header alone is `SectionHeader`). The primary color is used only for accents, icons and the main action.
- Clickable rows inside a card use `SectionLinkRow` (minimum height 48).
- Empty and error states use `AppEmptyState` (optional `actionLabel` + `onAction`, shown as `FilledButton.tonal`) and `AppErrorState`.
- `ElevatedButton` and `OutlinedButton` have a theme `minimumSize` of `(double.infinity, 52)`: inside a `Row` they need a local finite `minimumSize`.
- `AppButton` labels wrap instead of overflowing.

**Accessibility** (checked by `test/accessibility/`):
- Touch targets of at least 48 dp; every tappable element has a text or a tooltip (password visibility, expand/collapse, logo picker, onboarding "Next").
- Switches and the "Remember me" checkbox are merged with their labels (`MergeSemantics`).
- QR images are announced as labeled images.
- No screen overflows at system text scale 1.5 and 2.0.

---

## 9. Navigation

GetX named routes: names in `lib/core/routes/app_routes.dart`, `GetPage`s in `lib/core/routes/app_pages.dart`. `unknownRoute` opens `HomeScreen`.

```
Splash
  ├── (first launch) → Onboarding → Welcome
  ├── (signed out)   → Welcome → Login / Signup → Reset password
  └── (signed in)    → Home
                         ├── Scan → Details
                         ├── Create → Standard / Social form → Details
                         ├── Favorites → Details
                         ├── History → Details
                         └── Settings
                               ├── Profile
                               ├── Database
                               ├── Info → Privacy Policy
                               └── Support
```

| Route | Screen | Description |
|---|---|---|
| `/` (`splash`) | `SplashScreen` | Startup redirect |
| `/onboarding` | `OnboardingScreen` | First-launch introduction |
| `/welcome` | `WelcomeScreen` | Signed-out entry |
| `/login` | `LoginScreen` | Email and Google login |
| `/signup` | `SignupScreen` | Registration |
| `/reset-password` | `ResetPasswordScreen` | Password reset email |
| `/home` | `HomeScreen` | Tab shell (`HomeBinding`) |
| `/scanner` | `ScannerScreen` | Scanner as a standalone route (`ScannerBinding`) |
| `/code-create-standard` | `CodeCreateStandardScreen` | Standard form, argument `BarcodeType` |
| `/code-create-social` | `CodeCreateSocialScreen` | Social form, argument `CodeSocial` |
| `/code-details` | `CodeDetailsScreen` | Code details, argument `CodeModel`, fade 250 ms |
| `/user` | `UserScreen` | Profile and account deletion |
| `/settings` | `SettingsScreen` | Settings as a standalone route (`SettingsBinding`) |
| `/settings-database` | `DatabaseScreen` | Statistics, export, backup |
| `/settings-info` | `InfoScreen` | About the app |
| `/privacy-policy` | `PrivacyPolicyScreen` | Privacy policy |
| `/settings-support` | `SupportScreen` | FAQ and contacts |

---

## 10. Localization

| Code | Language |
|---|---|
| `en` | English (template and fallback) |
| `it` | Italian |

- ARB files: `lib/l10n/app_en.arb` (template) and `lib/l10n/app_it.arb`. `l10n.yaml` generates `AppLocalizations` into `lib/l10n/` with `flutter gen-l10n` (also run by `flutter pub get`, since `generate: true`).
- Supported locales are `L10n.all` (`lib/l10n/l10n.dart`).
- The user's choice is saved to `language_code`. `main()` reads it with `QrationApp.loadSavedLocale()` before `runApp` and passes it as `initialLocale`, so the first frame is already in the chosen language; changes from Settings use `Get.updateLocale`.
- Without a saved choice `locale` is `null` and Flutter resolves the system locale against `L10n.all`; an unsupported system language falls back to English, the first supported locale.
- Changelog strings use the keys `changelog_v<version>_bullet_N`, in every ARB file.

---

## 11. Dependencies

```yaml
environment:
  sdk: ^3.5.2

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:               # Material/Cupertino localizations
    sdk: flutter
  get: ^4.6.6                          # State management, DI and routing
  ming_cute_icons: ^0.0.7              # UI icons
  line_awesome_flutter: ^3.0.1         # Additional icons
  smooth_page_indicator: ^1.2.0+3      # Onboarding page indicator
  flutter_colorpicker: ^1.1.0          # QR color picker
  toastification: ^2.3.0               # Toasts
  flutter_animate: ^4.5.0              # Animations
  firebase_core: ^4.15.0               # Firebase core
  firebase_auth: ^6.7.0                # Authentication
  cloud_firestore: ^6.10.0             # Cloud database
  firebase_crashlytics: ^5.4.0         # Crash reporting (disabled on web)
  google_sign_in: ^7.2.0               # Google sign-in
  mobile_scanner: ^7.4.0               # Camera and image scanning
  pretty_qr_code: ^3.6.0               # QR rendering
  path_provider: ^2.1.5                # App directories
  shared_preferences: ^2.3.4           # Local preferences
  permission_handler: ^11.3.1          # Runtime permissions
  device_info_plus: ^11.2.0            # Android API level checks
  package_info_plus: ^9.0.1            # App version at runtime (AppVersion)
  image_picker: ^1.1.2                 # Gallery images (scan, logo)
  image_gallery_saver_plus: ^4.0.1     # Save QR images to the gallery
  screenshot: ^3.0.0                   # Capture the QR widget as an image
  audioplayers: ^6.1.0                 # Scan beep
  vibration: ^3.1.3                    # Scan vibration
  share_plus: ^10.1.1                  # System share sheet
  url_launcher: ^6.3.1                 # URLs, email, phone, SMS
  country_code_picker: ^3.1.0          # Phone country prefixes
  flutter_contacts: ^1.1.9+2           # Add contacts
  add_2_calendar: ^3.0.1               # Add calendar events
  wifi_iot: ^0.3.19+2                  # Connect to Wi-Fi networks
  flutter_map: ^8.3.1                  # Map for geo codes (OSM tiles)
  latlong2: ^0.9.1                     # Map coordinates
  pdf: ^3.11.1                         # PDF export
  excel: ^4.0.6                        # Excel export
  csv: ^6.0.0                          # CSV export
  file_picker: ^9.0.2                  # Pick the JSON backup to restore
  intl: ^0.20.2                        # Date formatting, ICU messages
  logger: ^2.5.0                       # Logging

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:                    # On-device end-to-end tests
    sdk: flutter
  flutter_lints: ^5.0.0                # Base lint set
  change_app_package_name: ^1.4.0      # One-off package rename tool
  flutter_launcher_icons: ^0.14.2      # Android launcher icons
  dependency_validator: ^5.0.2         # Unused/missing dependency check
  mocktail: ^1.0.4                     # Mocks
  fake_cloud_firestore: ^4.3.0         # In-memory Firestore for tests
  firebase_auth_mocks: ^0.15.2         # Firebase Auth mocks
```

**Integration notes:**
- **FlutterFire:** `firebase_core`, `firebase_auth`, `cloud_firestore` and `firebase_crashlytics` must be upgraded together (same FlutterFire release, Firebase Android BoM 34.x), together with `fake_cloud_firestore` and `firebase_auth_mocks`. `android/app/build.gradle` declares no native Firebase or Google dependency: the BoM, `firebase-auth` and `play-services-auth` come from the plugins, and pinning them by hand would compete with the plugins' versions.
- **Google Sign-In 7:** on Android the plugin uses Credential Manager and needs the *web* OAuth client ID, read from `google-services.json` (`oauth_client` with `client_type: 3`) by the `com.google.gms.google-services` Gradle plugin, so `initialize()` receives no `serverClientId`. If sign-in fails with "serverClientId must be provided", check that the web client exists in the Firebase console and download `google-services.json` again. Test it on a real device, with the SHA-1 of the debug and release signing keys registered in Firebase.
- **Crashlytics:** initialized in `main()` only when `!kIsWeb`, for unhandled Flutter and Dart errors.

**Tests** — `flutter test` (structure mirrors `lib/`):
- **Pure logic** (`test/core/utils`, `test/features/codes/models`, `test/core/constants`): content parsing per type, validators, ISBN formatting, code type conversion and body, social templates, QR decoration, `RescanGuard`, changelog structure, `HistoryController.filterCodes`.
- **With mocks** (`mocktail`, `fake_cloud_firestore`, `firebase_auth_mocks`): `AuthController`, `SessionStore`, `CodesService`, `ScannerController`, `CodeDetailsController`, `CodeCreateSocialController`, `SyncStatusMixin`, `HistoryController`, `FavoritesController`, `DatabaseController` (statistics, exports, backup history), `ThemeController`, `ScannerPreferencesController`, `ChangelogService`, `BackupHistory`, and the bindings (`test/features/bindings_test.dart`, including a missing route argument).
- **Widget and layout:** `CodeListTile`, `AppEmptyState`, `AppLogo`, `SectionCard`, `SyncStatusBanner`, `AppChangelogDialog`, `GenerateButton`, `ExportImportSection`, loading overlays, and the History, Favorites, Settings and Privacy Policy screens (sections and date in IT/EN). `test/features/export/pdf_report_test.dart` builds the PDF layout.
- **Accessibility** (`test/accessibility/`): `a11y_harness.dart` registers fake dependencies and the screen list `a11yScreens`. `a11y_guidelines_test.dart` checks `androidTapTargetGuideline`, `labeledTapTargetGuideline` and `textContrastGuideline` in light and dark themes, with the test font, because the contrast check reads colors from a screenshot and a real font's anti-aliased edges underestimate contrast. `text_scale_test.dart` loads the real Montserrat and checks for overflows at 1.5 and 2.0, reporting the widget's file and line. Scanner (camera), Home and Profile (signed-in user) are excluded. Every new screen that can be built without camera or user goes into `a11yScreens`.
- **Multi-layer** (`test/integration/`): real controller + mocked repository + real widgets. **End-to-end** (`integration_test/`): on a device or emulator, `flutter test integration_test`.
- Shared helpers in `test/support/` (e.g. `pumpLocalizedWidget`).
- Testable classes take their dependencies as constructor parameters: `AuthController`, `ScannerController` (`rescanGuard`, `playBeep`, `vibrate`, `saveTimeout`), `HistoryController` (`searchDebounce`), `CodesService`, `SessionStore`, `BackupHistory`.
- Practical notes: the test font (Ahem) is wider than Montserrat, so horizontal scrolls may need `tester.ensureVisible` before a tap; controllers with timers (e.g. `SyncStatusMixin`) must be created inside `testWidgets` so `tester.pump` controls time; controllers that load `SharedPreferences` in `onInit` need `SharedPreferences.setMockInitialValues` and a `pumpEventQueue()` first.

**Lint:** `flutter analyze --fatal-infos --fatal-warnings`. `analysis_options.yaml` includes `package:flutter_lints/flutter.yaml` and adds `avoid_print`, `unnecessary_this`, `prefer_final_fields` and `avoid_empty_else`. No files are excluded.

---

## 12. System requirements

| Requirement | Value |
|---|---|
| Dart SDK | `^3.5.2` (`pubspec.yaml`); Flutter stable with a matching Dart |
| Platform | Android only |
| Minimum Android | API 24 (Android 7.0), from `flutter.minSdkVersion` |
| Recommended Android | API 29+ (Android 10): public Downloads copy without storage permission |
| Target / compile SDK | `flutter.targetSdkVersion` / 36 |
| Architectures | `arm64-v8a` for the release APK (see [Build](#13-build-and-distribution)) |
| Internet | Required for sync, sign-in and map tiles; scanning and saving work offline through the Firestore cache |
| Google Play services | Required for Google sign-in (Credential Manager) |
| Firebase | Project with Auth (email/password, Google) and Firestore; `android/app/google-services.json` |

**Permissions:**

| Permission | API levels | Used by |
|---|---|---|
| `CAMERA` | all (merged from `mobile_scanner`) | Scanner |
| `INTERNET`, `ACCESS_NETWORK_STATE` | all | Firebase, map tiles |
| `READ_CONTACTS`, `WRITE_CONTACTS` | all | Add contact from a vCard code |
| `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `ACCESS_WIFI_STATE`, `CHANGE_WIFI_STATE`, `CHANGE_NETWORK_STATE` | all | Connect to a Wi-Fi code's network (`wifi_iot`) |
| `WRITE_EXTERNAL_STORAGE`, `READ_EXTERNAL_STORAGE` | ≤ 28 (`maxSdkVersion="28"`) | Public Downloads copy on Android 9 and lower; API 29+ uses `MediaStore` without permission |

---

## 13. Build and distribution

```bash
flutter pub get                       # Dependencies (also generates localizations)
flutter run                           # Debug run
flutter analyze --fatal-infos --fatal-warnings
flutter test

# Release APK, as built by deploy_android.ps1 (clean, pub get, build)
flutter build apk --release --target-platform android-arm64 --no-tree-shake-icons

# App bundle for Google Play
flutter build appbundle --release
```

The release APK is written to `build/app/outputs/flutter-apk/app-release.apk`.

**Android toolchain:** Android Gradle Plugin 8.11.1 and Kotlin 2.2.20 (`android/settings.gradle`), Gradle 8.14.3 (`android/gradle/wrapper/gradle-wrapper.properties`), Java 17 (`compileOptions` and `jvmTarget`), `compileSdk` 36, NDK `28.2.13676358`. Gradle plugins applied in `android/app/build.gradle`: `com.google.gms.google-services` and `com.google.firebase.crashlytics`.

**Firebase configuration:** put the production `google-services.json` in `android/app/`. Rules are published from the console (see [Security rules](#security-rules)); publish them together with the build that matches them.

**APK signing:** `android/key.properties` (git-ignored) points to the release keystore, kept outside the repo:

```properties
storeFile=<path to the keystore>
storePassword=<store password>
keyAlias=<key alias>
keyPassword=<key password>
```

`android/app/build.gradle` reads it in `signingConfigs.release`. Without the file the release build is signed with the debug key and Gradle prints a warning. Keep a backup of the keystore and its passwords: a lost key means users must uninstall to install an update signed with a new one. Register the SHA-1 and SHA-256 fingerprints of the release key in the Firebase console (required for Google sign-in) and in the Play Console.

**Notes:**
- Do not commit `android/key.properties`, the keystore, `android/local.properties` (local SDK paths) or `build/`.
- The version source of truth is `version:` in `pubspec.yaml`; `AppVersion.current` and the changelog follow it.
- **README previews:** `flutter test tool/preview/generate_preview_test.dart` turns `images/screenshots/<name>_raw.png` phone screenshots (git-ignored, kept locally) into the banner `images/qration_preview.png` (2400×1350, five tilted phones on `AppColors.surfaceVariantLight`) and gallery images `images/screenshots/<name>.png` without status and navigation bars (540 px wide). Screens, in banner order: `create` (Text form), `details`, `home` (type grid, center), `settings`, `database`. The system bar heights (`_statusBarHeight` 108 px, `_navBarHeight` 70 px) are measured on 1080×2392 screenshots and must be re-measured for a different phone. The script is outside `test/`, so `flutter test` does not run it.
- **Icons:** see [Theme and style](#8-theme-and-style).

---

## License

Copyright © 2026 **Nicola De Nicolais** — All Rights Reserved.

License: **source-available, non-commercial** (see [LICENSE](LICENSE)). Commercial use, including publishing or monetizing on any app store, requires explicit written permission from the copyright holder.

Third-party assets bundled with the app: Montserrat font, SIL Open Font License 1.1 (`assets/fonts/OFL.txt`, shown in the in-app licenses page).

- **Author:** Nicola De Nicolais
- **Email:** [ndn21dev@gmail.com](mailto:ndn21dev@gmail.com)
- **GitHub:** [https://github.com/ndenicolais](https://github.com/ndenicolais)
