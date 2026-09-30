# QRation — Documentazione completa

> Copyright © 2026 Nicola De Nicolais — Tutti i diritti riservati.

---

## Indice

1. [Panoramica dell'app](#1-panoramica-dellapp)
2. [Architettura e stack tecnologico](#2-architettura-e-stack-tecnologico)
3. [Struttura del progetto](#3-struttura-del-progetto)
4. [Modelli dati](#4-modelli-dati)
5. [Schermate e funzionalità](#5-schermate-e-funzionalità)
   - [Splash](#51-splash)
   - [Onboarding](#52-onboarding)
   - [Welcome](#53-welcome)
   - [Auth — Autenticazione](#54-auth--autenticazione)
   - [Home](#55-home)
   - [Scanner](#56-scanner)
   - [Creazione QR code](#57-creazione-qr-code)
   - [Dettaglio codice](#58-dettaglio-codice)
   - [Preferiti](#59-preferiti)
   - [Cronologia](#510-cronologia)
   - [Utente](#511-utente)
   - [Impostazioni](#512-impostazioni)
   - [Database](#513-database)
6. [Controllers (State Management)](#6-controllers-state-management)
7. [Servizi](#7-servizi)
   - [Autenticazione (AuthController)](#71-autenticazione-authcontroller)
   - [Codici (codes_service)](#72-codici-codes_service)
   - [Export CSV (csv_service)](#73-export-csv-csv_service)
   - [Export Excel (excel_service)](#74-export-excel-excel_service)
   - [Export PDF (pdf_service)](#75-export-pdf-pdf_service)
8. [Tema e stile](#8-tema-e-stile)
9. [Navigazione](#9-navigazione)
10. [Impostazioni disponibili](#10-impostazioni-disponibili)
11. [Dipendenze](#11-dipendenze)
12. [Requisiti di sistema](#12-requisiti-di-sistema)
13. [Build e distribuzione](#13-build-e-distribuzione)

---

## 1. Panoramica dell'app

**QRation** è un'app per la scansione e la creazione di QR code e codici a barre, sviluppata in Flutter per Android. Permette all'utente di:

- Scansionare QR code e codici a barre tramite fotocamera o da immagine in galleria
- Creare QR code personalizzati per più di 12 tipologie standard (testo, URL, email, telefono, SMS, contatto, posizione, Wi-Fi, evento calendario, prodotto, ISBN, patente)
- Creare QR code per 10 social network (YouTube, Facebook, Instagram, TikTok, Telegram, LinkedIn, X, Pinterest, Spotify, WhatsApp)
- Personalizzare l'aspetto visivo del QR code con colori e arrotondamento personalizzati per occhi e moduli
- Salvare tutti i codici scansionati e creati su Firebase Firestore con sincronizzazione cloud
- Gestire una cronologia completa dei codici con ricerca e filtri avanzati
- Marcare codici come preferiti e consultarli rapidamente
- Esportare i dati in CSV, Excel e PDF con statistiche dettagliate
- Condividere QR code come immagine o salvarli in galleria

L'app è completamente localizzata in italiano e inglese, con supporto a tema chiaro e scuro.

---

## 2. Architettura e stack tecnologico

| Componente | Tecnologia / Libreria |
|---|---|
| Framework | Flutter 3 / Dart `^3.5.2` |
| State management | [get](https://pub.dev/packages/get) `^4.6.6` (GetX) |
| Backend / Database | [cloud_firestore](https://pub.dev/packages/cloud_firestore) `^6.10.0` |
| Autenticazione | [firebase_auth](https://pub.dev/packages/firebase_auth) `^6.7.0` + [google_sign_in](https://pub.dev/packages/google_sign_in) `^6.2.1` |
| Core Firebase | [firebase_core](https://pub.dev/packages/firebase_core) `^4.15.0` |
| Error reporting | [firebase_crashlytics](https://pub.dev/packages/firebase_crashlytics) `^5.4.0` (errori Flutter/Dart non gestiti, disabilitato su web) |
| UI responsiva | [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) `^5.9.3` |
| Font | Montserrat, asset locale (`assets/fonts/`), esposto via `AppFonts` (`app_fonts.dart`) |
| Icone UI | [ming_cute_icons](https://pub.dev/packages/ming_cute_icons) `^0.0.7` + [line_awesome_flutter](https://pub.dev/packages/line_awesome_flutter) `^3.0.1` |
| Animazioni | [flutter_animate](https://pub.dev/packages/flutter_animate) `^4.5.0` |
| Indicatore pagine | [smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator) `^1.2.0+3` |
| Color picker | [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) `^1.1.0` |
| Toast/notifiche UI | [toastification](https://pub.dev/packages/toastification) `^2.3.0` |
| Scanner QR | [mobile_scanner](https://pub.dev/packages/mobile_scanner) `^7.4.0` |
| Generazione QR | [pretty_qr_code](https://pub.dev/packages/pretty_qr_code) `^3.6.0` |
| Persistenza locale | [shared_preferences](https://pub.dev/packages/shared_preferences) `^2.3.4` |
| Percorsi filesystem | [path_provider](https://pub.dev/packages/path_provider) `^2.1.5` |
| Permessi | [permission_handler](https://pub.dev/packages/permission_handler) `^11.3.1` |
| Info dispositivo | [device_info_plus](https://pub.dev/packages/device_info_plus) `^11.2.0` |
| Selezione immagine | [image_picker](https://pub.dev/packages/image_picker) `^1.1.2` |
| Salvataggio galleria | [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus) `^4.0.1` |
| Screenshot | [screenshot](https://pub.dev/packages/screenshot) `^3.0.0` |
| Audio | [audioplayers](https://pub.dev/packages/audioplayers) `^6.1.0` |
| Vibrazione | [vibration](https://pub.dev/packages/vibration) `^3.1.3` |
| Condivisione | [share_plus](https://pub.dev/packages/share_plus) `^10.1.1` |
| URL launcher | [url_launcher](https://pub.dev/packages/url_launcher) `^6.3.1` |
| Prefissi telefonici | [country_code_picker](https://pub.dev/packages/country_code_picker) `^3.1.0` |
| Contatti | [flutter_contacts](https://pub.dev/packages/flutter_contacts) `^1.1.9+2` |
| Calendario | [add_2_calendar](https://pub.dev/packages/add_2_calendar) `^3.0.1` |
| Wi-Fi | [wifi_iot](https://pub.dev/packages/wifi_iot) `^0.3.19+2` |
| Mappe | [free_map](https://pub.dev/packages/free_map) `^2.0.2` |
| WebView | [webview_flutter](https://pub.dev/packages/webview_flutter) `^4.8.0` |
| Export PDF | [pdf](https://pub.dev/packages/pdf) `^3.11.1` |
| Export Excel | [excel](https://pub.dev/packages/excel) `^4.0.6` |
| Export CSV | [csv](https://pub.dev/packages/csv) `^6.0.0` |
| Selettore file | [file_picker](https://pub.dev/packages/file_picker) `^9.0.2` |
| Internazionalizzazione | [intl](https://pub.dev/packages/intl) `^0.19.0` |
| Logging | [logger](https://pub.dev/packages/logger) `^2.5.0` |

**Pattern architetturale:** Feature-first con GetX. I controller fungono da ViewModel reattivi con `Rx`; i modelli sono POJO serializzabili; i service incapsulano la logica di accesso a Firebase e alle risorse di sistema; le schermate sono `StatelessWidget` o `StatefulWidget` che si collegano ai controller tramite `Get.find` / `Get.put`.

L'accesso ai codici segue un pattern repository: `CodesRepository` (`lib/features/codes/services/codes_repository.dart`) è un'interfaccia astratta con il contratto CRUD/query sui codici; `CodesService` la implementa usando Cloud Firestore. L'implementazione viene registrata una sola volta in `main.dart` (`Get.put<CodesRepository>(CodesService())`), e le 7 screen/servizi export che ne hanno bisogno la risolvono con `Get.find<CodesRepository>()` invece di istanziare direttamente `CodesService()`. Questo disaccoppia la UI dal backend concreto e rende l'implementazione sostituibile (es. con un mock) senza toccare le screen.

---

## 3. Struttura del progetto

```
qration/
├── android/                        # Configurazione Android nativa
├── assets/
│   ├── fonts/                      # Font Montserrat (regular + bold) + QrationIcons
│   ├── images/                     # Logo e immagini app
│   └── sounds/                     # Suono beep per scanner
├── lib/
│   ├── main.dart                   # Entry point: inizializza Firebase, Crashlytics, ThemeController, ScannerPreferencesController
│   ├── app.dart                    # QrationApp: GetMaterialApp con routing e localizzazione (locale iniziale da main)
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart  # Costanti globali: URI, tipi barcode ordinati, social list
│   │   ├── routes/
│   │   │   ├── app_routes.dart     # Definizione costanti nomi route
│   │   │   └── app_pages.dart      # Mappa route → widget (GetPage)
│   │   ├── theme/
│   │   │   ├── app_colors.dart     # Palette colori app
│   │   │   ├── app_text_styles.dart # Stili testo
│   │   │   ├── app_theme.dart      # Temi chiaro e scuro
│   │   │   └── theme_controller.dart # Controller GetX per gestione tema
│   │   ├── controllers/
│   │   │   └── scanner_preferences_controller.dart # Preferenze beep/vibrazione condivise
│   │   ├── utils/                  # Utility: icone/testi per tipo codice, validator, RescanGuard, ecc.
│   │   └── widgets/                # Widget riutilizzabili core (toast, pulsanti, CodeListTile, ecc.)
│   ├── features/
│   │   ├── auth/
│   │   │   ├── controllers/        # AuthController
│   │   │   ├── screens/            # login, signup, reset_password
│   │   │   ├── services/           # session_store (flag "Ricordami")
│   │   │   └── widgets/            # auth_divider
│   │   ├── codes/
│   │   │   ├── controllers/        # CodeDetailsController, CodeCreateStandardController, CodeCreateSocialController, ScannerController
│   │   │   ├── models/             # CodeModel, CodeSocial, CodeTypes (parser per ogni tipo)
│   │   │   ├── screens/            # scanner, create_types, create_standard, create_social, details
│   │   │   ├── services/           # CodesRepository (interfaccia) + CodesService (Firestore CRUD)
│   │   │   └── widgets/            # Sotto-widget di dettaglio/creazione codice, incl. code_create/
│   │   │                           # (custom_picker_field, full_screen_map, custom_loader)
│   │   ├── export/
│   │   │   └── services/           # csv_service, excel_service, pdf_service
│   │   ├── favorites/
│   │   │   ├── controllers/        # FavoritesController
│   │   │   └── screens/            # favorites_screen
│   │   ├── history/
│   │   │   ├── controllers/        # HistoryController (stream, ricerca con debounce, filtri, selezione)
│   │   │   ├── screens/            # history_screen
│   │   │   └── widgets/            # history_filter_sheet
│   │   ├── home/
│   │   │   └── screens/            # home_screen (bottom nav container)
│   │   ├── onboarding/
│   │   │   ├── models/
│   │   │   └── screens/            # onboarding_screen
│   │   ├── settings/
│   │   │   ├── controllers/        # SettingsController, DatabaseController
│   │   │   ├── screens/            # settings, database, info, policy, support
│   │   │   └── widgets/            # Sotto-widget della schermata Database + custom_expansiontile
│   │   ├── splash/
│   │   │   └── screens/            # splash_screen
│   │   ├── user/
│   │   │   ├── models/             # UserModel
│   │   │   ├── screens/            # user_screen, delete_account_screen
│   │   │   └── widgets/            # account_info_card
│   │   └── welcome/
│   │       └── screens/            # welcome_screen
│   └── l10n/                       # Localizzazione (ARB files: EN + IT)
├── test/
│   ├── core/utils/                 # Unit: isbn_formatter, code_type_conversion, code_social_template, validator, code_type_body
│   ├── features/                   # Unit/widget: models, controllers (mocktail), services (fake_cloud_firestore), widgets
│   ├── integration/                # Multi-layer flutter_test: controller reale + repository mockata + widget veri
│   ├── support/                    # Helper condivisi (es. pumpLocalizedWidget)
│   └── flutter_test_config.dart    # Setup globale test (no-op)
├── integration_test/               # Test end-to-end su device/emulatore reale (integration_test package)
├── pubspec.yaml
├── README.md
└── DOCUMENTATION.md
```

---

## 4. Modelli dati

I dati dei codici sono persistiti su **Cloud Firestore** nella collection `users/{uid}/codes`. Le impostazioni utente sono salvate in **SharedPreferences**.

### CodeModel

Rappresenta un QR code o codice a barre, sia scansionato che creato.

| Campo | Tipo | Descrizione |
|---|---|---|
| `id` | `String` | ID del documento Firestore |
| `barcode` | `Barcode` | Oggetto barcode (rawValue + BarcodeType) |
| `date` | `DateTime` | Data di creazione/scansione |
| `isFavorite` | `bool` | Marcato come preferito |
| `source` | `CodeSource` | Origine: `scanned` / `created` / `unknown` |
| `eyeColor` | `Color` | Colore degli occhi del QR code (default nero) |
| `eyeRounded` | `int` | Arrotondamento degli occhi (0 = nessuno) |
| `moduleColor` | `Color` | Colore dei moduli del QR code (default nero) |
| `moduleRounded` | `int` | Arrotondamento dei moduli (0 = nessuno) |
| `socialMedia` | `CodeSocial?` | Dati social collegati (se è un codice social) |
| `notes` | `String?` | Note dell'utente sul codice |
| `logoPath` | `String?` | Percorso locale del logo incorporato al centro del QR (solo device, nessuna sincronizzazione cloud) |

**Enum `CodeSource`:** `scanned`, `created`, `unknown`

---

### CodeSocial

Metadati del social network associato a un codice di tipo social.

| Campo | Tipo | Descrizione |
|---|---|---|
| `name` | `String` | Nome del social (es. `YouTube`, `Instagram`) |
| `url` | `String` | URL base del profilo social |
| `icon` | `IconData` | Icona MingCute del social |

**Social supportati (10):** YouTube, Facebook, Instagram, TikTok, Telegram, LinkedIn, X, Pinterest, Spotify, WhatsApp

---

### Tipi barcode standard (12)

Gestiti dalla libreria `mobile_scanner` come `BarcodeType`:

| Tipo | Descrizione |
|---|---|
| `text` | Testo libero |
| `url` | Indirizzo web |
| `email` | Email con destinatario, oggetto e corpo (`MATMSG`) |
| `phone` | Numero di telefono (`tel:`) |
| `sms` | SMS con numero e testo (`SMSTO:`) |
| `contactInfo` | Contatto vCard (`BEGIN:VCARD`) |
| `geo` | Coordinate geografiche |
| `wifi` | Credenziali Wi-Fi (SSID, password, cifratura) |
| `calendarEvent` | Evento calendario (VEVENT) |
| `product` | Codice prodotto (EAN, UPC) |
| `isbn` | Codice ISBN libro |
| `driverLicense` | Patente di guida |

Ogni tipo ha classi parser dedicate in `lib/features/codes/models/code_types.dart` (es. `CodeEmail`, `CodeSms`, `CodeContact`, `CodePhoneNumber`, `CodeUrl`).

---

### UserModel

Rappresenta il profilo dell'utente autenticato, salvato su Firestore nella collection `users/{uid}`.

| Campo | Tipo | Descrizione |
|---|---|---|
| `userEmail` | `String` | Email dell'utente |
| `userName` | `String` | Nome visualizzato |
| `userImage` | `String?` | URL immagine profilo (opzionale, da Google) |
| `userDate` | `DateTime` | Data di registrazione |

---

## 5. Schermate e funzionalità

### 5.1 Splash

**Percorso:** `lib/features/splash/`

Schermata di avvio visualizzata al lancio dell'app. Mostra il logo animato e reindirizza automaticamente alla schermata corretta in base allo stato dell'utente:
- Primo avvio → Onboarding
- Utente non autenticato → Welcome
- Utente autenticato → Home

La permanenza minima sulla splash (`Future.delayed`, 350ms) esiste solo per dare tempo all'animazione del logo di essere visibile prima del redirect automatico.

**Ripristino della sessione:** lo splash va in Home solo se `SessionStore.canRestore(uid)` è vero, cioè se esiste un utente Firebase autenticato **e** il "Ricordami" salvato (`remember_me` + `user_id`) si riferisce proprio a quell'utente. Poiché Firebase ripristina l'utente persistito in modo asincrono all'avvio, `currentUser` può essere ancora `null`: in quel caso lo splash attende il primo evento di `authStateChanges()` (timeout 3 s) invece di leggerlo in modo sincrono. In precedenza lo splash faceva anche una lettura Firestore del profilo utente il cui fallimento (ad esempio offline e senza cache) rimandava al Welcome pur con sessione valida: la lettura è stata rimossa.

**Backup automatico Android e sessione Firebase:** Firebase Auth salva l'utente in `shared_prefs/com.google.firebase.auth.api.Store.<id>.xml`, cifrato con una chiave del Keystore Android (`...api.crypto.<id>.xml`). La chiave del Keystore non viene mai inclusa nei backup: se Auto Backup ripristina quei file dopo una reinstallazione, Firebase non riesce né a leggerli né a sovrascriverli, e ogni nuovo login resta solo in memoria (l'hot reload sembra funzionare, un riavvio dell'app riporta al Welcome con `currentUser == null`). Per questo `AndroidManifest.xml` dichiara `android:fullBackupContent="@xml/backup_rules"` (Android 6–11) e `android:dataExtractionRules="@xml/data_extraction_rules"` (Android 12+), che escludono questi due file dal backup e dal trasferimento tra dispositivi. I nomi dei file includono `base64("[DEFAULT]")+base64(mobilesdk_app_id)`: vanno aggiornati se cambia l'app Firebase in `google-services.json`. Su un dispositivo già in questo stato basta cancellare i due file (o i dati dell'app) e rifare il login.

---

### 5.2 Onboarding

**Percorso:** `lib/features/onboarding/`

Presentazione guidata mostrata solo al primo avvio dell'app. Introduce le funzionalità principali con pagine scorrevoli e un indicatore `SmoothPageIndicator`. Al termine reindirizza alla schermata Welcome.

---

### 5.3 Welcome

**Percorso:** `lib/features/welcome/`

Schermata di benvenuto con accesso rapido alle opzioni di autenticazione:
- Pulsante **Accedi** → Login
- Pulsante **Registrati** → Signup

---

### 5.4 Auth — Autenticazione

**Percorso:** `lib/features/auth/`

Gestione completa dell'autenticazione tramite Firebase Auth.

**Schermate:**
- **Login (`login_screen.dart`):**
  - Login con email e password
  - Login con Google (un tap, OAuth 2.0)
  - Opzione "Ricordami" (salva in `SharedPreferences` il flag di sessione, non le credenziali); con Google la sessione è sempre ricordata
  - Link a Registrazione e Reset password
- **Signup (`signup_screen.dart`):**
  - Registrazione con nome, email e password
  - Validazione form (email duplicata, password sicura)
  - Creazione profilo utente su Firestore dopo la registrazione
  - Registrazione con Google: stesso pulsante "Continua con Google" del Login (`loginWithGoogle`, che crea il profilo Firestore se manca), separato dal form dal divisore condiviso `AuthDivider` (`lib/features/auth/widgets/auth_divider.dart`)
- **Reset password (`reset_password_screen.dart`):**
  - Invio email di reset tramite Firebase Auth

---

### 5.5 Home

**Percorso:** `lib/features/home/`

Schermata contenitore con **bottom navigation bar** a 5 voci. Gestisce la navigazione tra le sezioni principali dell'app tramite `IndexedStack`.

**Sezioni della bottom nav:**

| # | Voce | Schermata |
|---|---|---|
| 1 | Scansiona | Scanner QR (tab selezionato di default all'apertura dell'app) |
| 2 | Crea | Selezione tipo codice (`CodeCreateTypesScreen`), mostrata direttamente come corpo del tab |
| 3 | Preferiti | Codici marcati come preferiti |
| 4 | Cronologia | Lista completa di tutti i codici |
| 5 | Impostazioni | Configurazione app |

Lo scanner (`ScannerScreen`) è il primo tab (indice 0) invece che uno schermo raggiungibile solo tramite tap, così l'utente può scansionare un codice subito dopo aver aperto l'app, senza passaggi intermedi. Vivendo dentro l'`IndexedStack` di Home, riceve un flag `isActive` che ne avvia/ferma la fotocamera (`MobileScannerController.start()`/`stop()`) quando l'utente entra o esce dal tab, per non tenerla accesa in background mentre si naviga in altre sezioni.

La pipeline di scansione vive in `ScannerController` (`lib/features/codes/controllers/scanner_controller.dart`); `ScannerScreen` gestisce solo fotocamera (`MobileScannerController`), permessi, zoom, galleria e navigazione. In `_onDetect`, `ScannerController.tryBeginDetection` (flag osservabile `isProcessing` + `RescanGuard`) evita di elaborare più scansioni in parallelo mentre una è già in corso. Beep e vibrazione di conferma (`playFeedback`, iniettabili nel costruttore per i test) sono racchiusi in blocchi try/catch dedicati (un fallimento del plugin audio/vibrazione, es. su device senza vibratore o output audio, non deve bloccare il riconoscimento del codice) e il reset (`endDetection`) avviene in un `finally` attorno a `_processBarcode`, così anche un errore nell'elaborazione del barcode non lascia lo scanner bloccato sul primo scan.

Beep e vibrazione vengono letti da `ScannerPreferencesController` (`lib/core/controllers/`, tramite `ScannerController`) a ogni rilevamento, non copiati in `initState`: poiché `ScannerScreen` vive nell'`IndexedStack` di Home e non viene mai ricreata, una copia locale renderebbe le modifiche fatte nelle Impostazioni invisibili fino al riavvio dell'app.

Le rilevazioni ripetute dello stesso codice sono filtrate da `RescanGuard` (`lib/core/utils/rescan_guard.dart`): la fotocamera segnala continuamente il codice inquadrato, quindi lo stesso valore viene ignorato finché resta in vista e viene accettato di nuovo solo dopo essere rimasto fuori inquadratura per almeno 2 secondi. Al ritorno dai dettagli il `finally` di `_onDetect` chiama `endDetection()`, che invoca `touch()`, così il cooldown parte da quel momento: il codice ancora inquadrato non riapre subito i dettagli, ma è possibile riscansionarlo spostando la fotocamera e tornando a inquadrarlo (in precedenza `_lastScanned` non veniva mai azzerato e lo stesso codice non era più scansionabile finché lo scanner restava vivo). Un codice diverso viene invece accettato immediatamente.

Dopo aver salvato il codice, `_processBarcode` naviga ai dettagli con `Get.toNamed` (non `Get.offNamed`): essendo `ScannerScreen` un tab dentro l'`IndexedStack` di Home e non più una route indipendente, la route corrente al momento dello scan è l'intera Home. `Get.toNamed` apre `CodeDetailsScreen` **sopra** la Home, preservando il tab-shell sottostante (tornando indietro l'utente rimane sullo stesso tab); `Get.offNamed` sostituirebbe invece l'intera Home, comportamento sbagliato per questa architettura.

`CodesService.addCode` genera l'id del documento localmente (`collection.doc()`, sincrono, non richiede rete) e lo assegna a `code.id` **prima** di scrivere su Firestore con un singolo `set()`, invece del precedente `add()` + `update()` in due round-trip separati. In `_processBarcode`, l'`await` su `addCode` è avvolto in un `timeout(Duration(seconds: 3))`: con connessione assente o instabile la scrittura resta comunque in coda nella cache offline di Firestore (e quindi visibile subito in Cronologia), ma senza il timeout l'attesa della conferma dal server poteva bloccare indefinitamente la navigazione verso `CodeDetailsScreen`. Allo scadere del timeout si naviga comunque ai dettagli, poiché l'id è già noto e la scrittura si sincronizzerà in background.

Prima di `Get.toNamed`, `_processBarcode` ferma anche la fotocamera (`_controller.stop()`), riavviandola (`_controller.start()`) al ritorno se il tab è ancora attivo: lasciare la preview della fotocamera attiva sotto la route appena spinta poteva causare un crash del renderer Impeller (`Invalid external texture`) quando la sua `SurfaceTexture` veniva oscurata da `CodeDetailsScreen`, impedendo di fatto alla nuova schermata di comparire anche se la navigazione GetX era già avvenuta correttamente.

Mentre `isProcessing` è `true` (dal rilevamento del barcode fino al `finally` di `_onDetect`), lo scanner mostra un overlay scuro con `AppLoader` sopra la fotocamera, per dare un feedback visivo durante l'attesa del salvataggio — che con connessione assente può arrivare fino ai 3 secondi del timeout di `addCode` prima di procedere comunque alla navigazione.

Il tab Home mostrava in precedenza una dashboard (`_HomeBody`) con un'unica card che rimandava, con un tap in più, alla selezione del tipo di codice (`CodeCreateTypesScreen`, raggiunta tramite la route `codeCreateTypes`). Poiché quella dashboard esponeva solo quell'azione, è stata rimossa: il tab Home mostra ora `CodeCreateTypesScreen` direttamente come corpo, senza passaggio intermedio né route dedicata (la costante `AppRoutes.codeCreateTypes` e la relativa `GetPage` sono state rimosse). Di conseguenza `CodeCreateTypesScreen` non ha più un proprio `AppBar` con freccia indietro, in linea con gli altri tab (`ScannerScreen`, `FavoritesScreen`, `HistoryScreen`, `SettingsScreen`), che vivono anch'essi senza `AppBar` dentro l'`IndexedStack` di Home.

Il pulsante **Profilo utente**, prima nell'header della dashboard rimossa, è stato spostato come voce cliccabile nella sezione Account di [5.12 Impostazioni](#512-impostazioni) (`Get.toNamed(AppRoutes.user)`). `HomeController`, che gestiva solo il nome utente mostrato in quell'header, è stato rimosso insieme al file `home_controller.dart` in quanto non più referenziato.

Al primo frame utile dopo l'ingresso in Home, `AppChangelogDialog.maybeShow` confronta la versione corrente (`AppVersion.current` in `lib/core/constants/app_version.dart`, popolata a runtime in `main()` tramite `package_info_plus`) con l'ultima versione vista, salvata in `SharedPreferences` (`changelog_last_seen_version`), e mostra automaticamente il dialog "Novità" con le sole voci più recenti — vedi [5.12 Impostazioni](#512-impostazioni).

---

### 5.6 Scanner

**Percorso:** `lib/features/codes/screens/code_scanner_screen.dart`

Scansione di QR code e codici a barre tramite fotocamera del dispositivo.

**Funzionalità:**
- **Anteprima fotocamera** in tempo reale con overlay di targeting
- **Scansione automatica:** il primo barcode rilevato viene elaborato e salvato
- **Scansione da immagine:** importa un'immagine dalla galleria e ne estrae il codice
- **Zoom:** slider per regolare il livello di zoom della fotocamera
- **Feedback audio:** beep opzionale alla rilevazione (configurabile nelle impostazioni)
- **Feedback tattile:** vibrazione opzionale alla rilevazione (configurabile nelle impostazioni)
- **Rilevamento social:** se il contenuto corrisponde a un URL di social network noto, crea automaticamente un `CodeModel` con i metadati social
- Al completamento della scansione, naviga direttamente al **Dettaglio codice**

**Overlay e controlli:**
- `_ScanOverlay` oscura l'anteprima fuori dal riquadro di inquadratura (264×264, raggio 24) con `_ScrimPainter`, un `CustomPainter` che riempie l'intera area con un path `PathFillType.evenOdd` (rettangolo pieno + riquadro arrotondato come "foro").
- La linea laser è animata da un `AnimationController` (1,8 s, avanti/indietro, `Curves.easeInOut`) che scorre dentro il riquadro. L'animazione gira solo quando il tab Scanner è attivo (`animate: widget.isActive`): essendo nell'`IndexedStack` di Home, altrimenti continuerebbe a consumare frame anche in background.
- Il pulsante torcia è avvolto in un `ValueListenableBuilder<MobileScannerState>` sul `MobileScannerController` (che è un `ValueNotifier`): icona piena ed evidenziata in oro quando `torchState == TorchState.on`, tooltip "Accendi/Spegni la torcia", disabilitato se `TorchState.unavailable` (es. fotocamera frontale).
- `_ControlButton` usa `Material` + `InkWell` circolari (ripple visibile) con `HapticFeedback.selectionClick()` al tocco e un `Tooltip` obbligatorio; anche il pulsante galleria nell'app bar ha ora il suo tooltip.

**Permessi richiesti:** `CAMERA`

---

### 5.7 Creazione QR code

**Percorso:** `lib/features/codes/screens/`

Flusso a più step per la creazione di un QR code personalizzato.

**Step 1 — Selezione tipo (`code_create_types_screen.dart`):**
- Griglia di selezione con **12 tipi standard** e **10 tipi social**
- Ogni tipo è rappresentato da icona e label
- Animazione di entrata con `flutter_animate` (fade + scale)

**Step 2a — Creazione standard (`code_create_standard_screen.dart`):**
Form di inserimento dati specifico per ogni tipo di barcode. Campi dinamici in base al tipo selezionato:

| Tipo | Campi |
|---|---|
| Testo | Contenuto testuale |
| URL | Indirizzo web |
| Email | Destinatario, oggetto, corpo |
| Telefono | Prefisso paese + numero |
| SMS | Numero, testo messaggio |
| Contatto | Nome, cognome, telefono, email |
| Geo | Latitudine, longitudine (con mappa interattiva `free_map`) |
| Wi-Fi | SSID, password, tipo cifratura, rete nascosta |
| Evento calendario | Titolo, luogo, data inizio/fine |
| Prodotto / ISBN | Codice numerico |
| Patente | Dati patente |

- **Personalizzazione visiva:** color picker per colore occhi e moduli; switch per arrotondamento; selezione opzionale di un **logo** dalla galleria, incorporato al centro del QR (`pretty_qr_code`'s `PrettyQrDecorationImage`, scale 0.2, salvato solo localmente sul device in `<app documents>/logos/`). Quando è presente un logo, il livello di correzione d'errore del QR passa da `M` a `H` (in tutti i punti di rendering: anteprima, dettaglio, export PDF), per compensare l'area coperta dal logo e mantenere il codice scansionabile anche da immagine statica. Ogni QR viene inoltre renderizzato con un **quiet zone** standard di 4 moduli (`buildQrDecoration()` in `qr_decoration.dart`, `PrettyQrQuietZone.standard`): senza questo margine i moduli arrivano fino al bordo dell'immagine catturata/salvata, impedendo ai decoder (es. `mobile_scanner`'s `analyzeImage`, usato dalla scansione "da galleria") di individuare i finder pattern
- **Anteprima live** (`QrPreview`, `widgets/code_create/qr_preview.dart`) per **tutti** i tipi: si aggiorna a ogni modifica dei campi (`Listenable.merge` dei `TextEditingController`) e delle scelte osservabili (prefisso, cifratura Wi-Fi, stile), usando `generateContent()`; finché il form è incompleto mostra un QR segnaposto. In precedenza l'anteprima si aggiornava solo per il tipo Testo
- **Layout:** campi del form in una `SectionCard` "Contenuto", poi le card "Anteprima" e "Stile" (`QrStyleCustomizer`) e il pulsante "Crea" pieno a tutta larghezza (`GenerateButton`, con indicatore di caricamento durante il salvataggio). App bar (`CodeCreateAppBar`, generica con callback `hasContent`) e switch prendono i colori dal tema
- Validazione campi con messaggi di errore

**Step 2b — Creazione social (`code_create_social_screen.dart`):**
- Form semplificato con il campo username/profilo per il social selezionato
- Stessi widget dello Step 2a (`CodeCreateAppBar`, `QrPreview`, `QrStyleCustomizer`, `GenerateButton`): lo stato di stile (colori e arrotondamento di occhi e moduli, logo) è nel mixin `QrStyleMixin` (`controllers/qr_style_mixin.dart`), condiviso da `CodeCreateStandardController` e `CodeCreateSocialController`
- Il contenuto viene formattato automaticamente con l'URL base del social
- Anteprima live del QR code col contenuto reale (`buildContent()`): in precedenza mostrava sempre un QR vuoto con il solo stile
- Stato e logica in `CodeCreateSocialController` (`lib/features/codes/controllers/`), speculare a `CodeCreateStandardController`: `TextEditingController` dei campi, stile osservabile (colori, arrotondamenti, logo, prefisso WhatsApp), `buildContent()` per la costruzione del contenuto (URL, URI di ricerca Spotify `spotify:search:<artista>;<brano>`, link `wa.me` con prefisso) e `createQrCode()` per il salvataggio. La screen gestisce solo validazione del form, toast e navigazione; il dialog di conferma all'uscita usa `showDiscardDialog` condiviso (`widgets/code_create/discard_dialog.dart`) come la creazione standard

---

### 5.8 Dettaglio codice

**Percorso:** `lib/features/codes/screens/code_details_screen.dart`

Schermata di visualizzazione e gestione di un singolo codice.

**Navigazione e transizione:** tutti i punti di ingresso (Scanner, Cronologia, Preferiti, creazione standard e social) aprono il dettaglio tramite la route `AppRoutes.codeDetails` con il `CodeModel` come argomento (`Get.toNamed`, oppure `Get.offNamed` dopo la creazione). La transizione è definita una sola volta nella `GetPage` in `app_pages.dart` (`Transition.fade`, 250 ms), invece di essere ripetuta in ogni `Get.to(...)` con 500 ms. L'icona del tipo nella card di lista (`CodeListTile`) e quella nel chip "Tipo" del dettaglio (`CodeInfoRow`, parametro `typeIconHeroTag`) condividono il tag `codeIconHeroTag(code.id)`, così l'icona "vola" dalla lista al dettaglio e ritorno. Poiché Cronologia e Preferiti restano costruiti nell'`IndexedStack` di `HomeScreen` anche quando non visibili, ogni tab è avvolto in `HeroMode(enabled: i == _selectedIndex)`: solo il tab attivo partecipa alle animazioni `Hero`, evitando tag duplicati quando lo stesso codice compare in entrambe le liste.

**Layout:** app bar con i colori del tema (`code_details_app_bar.dart`; nel menu la voce "Elimina" è nel colore di errore); chip "Data" (formato `dd/MM/yyyy HH:mm`, come nelle liste) e "Tipo" come card neutre con bordo (`CodeInfoRow`); `SectionCard` "Codice QR" (`CodeQrSection`); riga di azioni rapide con etichetta (`CodeActionButtons`: Copia, Preferito 'evidenziato quando attivo', Salva, Condividi, con ripple e feedback aptico, al posto dei `FloatingActionButton` senza testo); `SectionCard` "Contenuto" (`CodeContentCard`) con l'azione specifica del tipo come `ElevatedButton` a tutta larghezza. In precedenza card e app bar usavano il colore principale come sfondo pieno.

**Informazioni mostrate:**
- Data di creazione/scansione
- Tipo del codice (con icona)
- Immagine QR code generata con colori personalizzati
- Contenuto decodificato (testo, URL cliccabile, email, telefono, ecc.)
- Note dell'utente (modificabili dall'azione in appbar): l'apertura del bottom sheet (`_showNotesBottomSheet`, `code_details_screen.dart`) è ritardata di 300ms nell'`onSelected` del `PopupMenuButton` (`code_details_app_bar.dart`) perché aprire una nuova route in modo sincrono mentre la route del popup menu sta ancora chiudendosi genera un conflitto. La causa principale del mancato rendering, però, era un crash di layout: il tema globale (`app_theme.dart`) imposta `minimumSize: Size(double.infinity, 52)` per tutti gli `ElevatedButton`, ma il pulsante "Salva" del bottom sheet note è dentro una `Row` (assieme al pulsante "Annulla"), che passa larghezza non vincolata ai figli non-`Expanded` — larghezza minima infinita in un contesto non vincolato genera un'eccezione di layout che interrompe il rendering del bottom sheet lasciando però la tastiera già aperta. Corretto sovrascrivendo localmente `minimumSize` sul pulsante "Salva" con una dimensione finita.

**Azioni disponibili:**

| Azione | Descrizione |
|---|---|
| **Preferito** | Aggiunge/rimuove dai preferiti |
| **Copia** | Copia il contenuto negli appunti |
| **Condividi** | Condivide il QR come immagine tramite sistema operativo |
| **Salva in galleria** | Salva l'immagine QR nella galleria foto |
| **Apri** | Apre URL nel browser / compone email / chiama numero / connette Wi-Fi / aggiunge contatto / aggiunge evento calendario |
| **Elimina** | Elimina il codice da Firestore |

**Sincronizzazione e pull-to-refresh (Cronologia e Preferiti):** `CodesRepository.getSyncStatusStream()` ascolta la collection dei codici con `snapshots(includeMetadataChanges: true)` e traduce i metadata Firestore in `SyncStatus` (`CodesService.syncStatusFrom`: `hasPendingWrites` → `pending`, altrimenti `isFromCache` → `offline`, altrimenti `synced`). `HistoryController` e `FavoritesController` usano il mixin `SyncStatusMixin` (`features/codes/controllers/sync_status_mixin.dart`), che espone `syncStatus` e `refreshCodes()`. Lo stato `offline` viene mostrato solo dopo 2 s (`offlineGracePeriod`), perché all'avvio Firestore risponde prima dalla cache anche con la rete attiva e il banner altrimenti lampeggerebbe a ogni apertura; `pending` è immediato. `SyncStatusBanner` (`core/widgets/sync_status_banner.dart`) mostra un avviso sopra la lista solo in quei due stati. Il pull-to-refresh (`RefreshIndicator`) chiama `CodesRepository.refreshCodes()`, cioè una lettura `GetOptions(source: Source.server)` che aggiorna cache e stream; se il server non è raggiungibile compare un toast. Le liste usano `AlwaysScrollableScrollPhysics` e gli stati vuoti sono avvolti in `PullToRefreshFill`, così il gesto funziona anche con pochi elementi o nessuno. Nei Preferiti c'è un `RefreshIndicator` per ogni tab, perché uno esterno non riceverebbe lo scroll verticale delle liste annidate nel `TabBarView` orizzontale.

---

### 5.9 Preferiti

**Percorso:** `lib/features/favorites/screens/favorites_screen.dart` (UI) + `lib/features/favorites/controllers/favorites_controller.dart` (stato)

Lista dei codici marcati come preferiti, organizzata in due tab. `FavoritesController` si iscrive una sola volta a `getFavoriteCodesStream()` ed espone `isLoading`, `error`, `hasFavorites` e le liste `createdCodes`/`scannedCodes` già divise per sorgente e ordinate per data decrescente (ricalcolate solo a ogni evento dello stream, non a ogni rebuild).

| Tab | Contenuto |
|---|---|
| Scansionati | Codici preferiti con `source = scanned` |
| Creati | Codici preferiti con `source = created` |

- Ogni elemento è un `CodeListTile` (icona tipo, contenuto e data), la stessa card usata dalla Cronologia
- Tap → naviga al Dettaglio codice

---

### 5.10 Cronologia

**Percorso:** `lib/features/history/screens/history_screen.dart` (UI) + `lib/features/history/controllers/history_controller.dart` (stato e logica)

Lista completa di tutti i codici dell'utente con funzionalità avanzate di ricerca e filtro.

**Separazione UI / logica:** `HistoryScreen` contiene solo composizione di widget e stato puramente UI (`TextEditingController`/`FocusNode` della ricerca); tutto il resto vive in `HistoryController` (creato con `Get.put` in `initState` e rimosso con `Get.delete` in `dispose`, come le altre screen con controller):
- si iscrive **una sola volta** a `CodesRepository.getCodesStream()` in `onInit` (in precedenza lo `StreamBuilder` chiamava `getCodesStream()` a ogni rebuild, riaprendo il listener Firestore a ogni tasto premuto nella ricerca) ed espone `isLoading`/`error`;
- stato dei filtri osservabile: `searchInput` (testo digitato) → `searchKeyword` con **debounce di 300 ms**, `selectedStandardTypes`, `selectedSocialTypes`, `selectedSource`;
- `filteredCodes` è **memoizzato**: viene ricalcolato (filtro + ordinamento per data decrescente) da un worker `everAll` solo quando cambia uno degli input, non a ogni rebuild. La logica pura è nel metodo statico `HistoryController.filterCodes` (filtri per tipo standard/social in OR tra loro, poi in AND con ricerca e sorgente), testato separatamente;
- selezione multipla (`isSelecting`, `selectedIds`, `toggleSelected`, `toggleSelectAll`, `allSelected`) ed eliminazione (`deleteSelected`, con `isDeleting` azzerato in `finally` anche in caso di errore).

Le card sono `CodeListTile` (`showSource: true` per mostrare "Created"/"Scanned", `selectable` in modalità selezione): fuori dalla selezione un tocco su tutta la card, o sulla freccia, apre il dettaglio; in selezione il tocco seleziona/deseleziona. Ogni card della lista è avvolta in un proprio `Obx`, così la selezione di un elemento ricostruisce solo quella card. Nella barra di selezione il contatore "N selezionati" è in un `Expanded` con ellissi, per evitare overflow con testi lunghi o scala del testo di sistema elevata.

**`CodeListTile`** (`lib/core/widgets/code_list_tile.dart`) è la card unica di tutte le liste di codici e sostituisce le due implementazioni precedenti (`CodeCard` nei Preferiti e `_buildCodeCard`/`_buildCardTitle`/`_buildCardTrailing` nella Cronologia), che avevano raggi e margini diversi (14 invece del 16 del `cardTheme`, margini 12/8 contro 2/6). Usa `AppRadius.large` (allineato al `cardTheme` globale) e un margine verticale di 6; le liste che la ospitano usano il padding comune `CodeListTile.listPadding`.

**Funzionalità:**
- **Ricerca testuale** per contenuto del codice
- **Pannello filtri unico** (`HistoryFilterSheet` in `lib/features/history/widgets/history_filter_sheet.dart`, aperto con `showHistoryFilterSheet` dall'icona filtro): bottom sheet con i colori standard del tema (non più `colorScheme.primary`) e tre sezioni:
  - **Origine:** `SegmentedButton` Tutti / Creati / Scansionati
  - **Tipo di codice:** `FilterChip` con icona **ed etichetta** (`CodeTypeText`) per ogni `BarcodeType`, disposti in un `Wrap`
  - **Social:** `FilterChip` con icona e nome per ogni social network
  - I filtri si applicano in tempo reale (il sheet osserva `HistoryController` con `Obx`); in fondo "Azzera i filtri" (`clearSheetFilters()`, lascia intatta la ricerca) e "Mostra risultati" (chiude il sheet)
- **Indicatore filtri attivi:** l'icona filtro nella barra di ricerca è avvolta in un `Badge` con `HistoryController.activeFilterCount` (tipi + social + origine; la ricerca è esclusa perché già visibile nel campo) e diventa del colore primario quando ci sono filtri attivi. Le due righe di chip sempre visibili sotto la ricerca sono state rimosse, recuperando spazio verticale per la lista
- **Modalità selezione multipla:** si entra con il pulsante Cestino della barra di ricerca oppure con una **pressione prolungata** su una card (`HistoryController.startSelectionWith`, che parte con quel codice già selezionato; feedback aptico `mediumImpact`). La riga di ricerca si trasforma, con un `AnimatedSwitcher` (dissolvenza + leggero scorrimento, 220 ms), in una **barra contestuale** con: chiudi, contatore "N selezionati", seleziona/deseleziona tutti (icona con tooltip) ed elimina. La vecchia bottom bar di selezione è stata rimossa. Ogni selezione/deselezione dà un feedback aptico `selectionClick`. Dopo l'eliminazione il toast indica quanti codici sono stati eliminati (`history_screen_deleted_count`, stringa ICU con plurale).
- **Caricamento** da Firestore con indicatore di progresso animato

L'eliminazione in blocco (`HistoryController.deleteSelected`) esegue `Future.wait` sulle `deleteCode` selezionate (in parallelo invece che in sequenza, per ridurre il tempo sotto l'overlay di caricamento). Nella screen il toast di conferma è preceduto da un controllo `context.mounted`, perché `HistoryScreenState` potrebbe non essere più montato al termine dell'`await`.

In precedenza, dopo l'eliminazione lo schermo restava comunque nero: la causa reale era un doppio `Navigator.pop()`. `AppDeleteDialog` chiude già da sé il proprio dialogo prima di invocare `onConfirm`, ma il callback `onConfirm` di Cronologia eseguiva un ulteriore `Navigator.of(context).pop()` come prima istruzione; poiché `HistoryScreen` vive nell'`IndexedStack` di `HomeScreen` senza una route propria, quel secondo pop chiudeva la Home stessa (da cui il crash `setState()` dopo dispose, sintomo secondario). Corretto rimuovendo la chiamata `Navigator.pop()` ridondante. Lo stesso bug era presente anche in `delete_account_screen.dart` ed è stato corretto allo stesso modo.

---

### 5.11 Utente

**Percorso:** `lib/features/user/screens/`

**Profilo utente (`user_screen.dart`):**
- Intestazione con avatar (foto o iniziale, bordo nel colore principale), nome ed email
- `AccountInfoCard` (`lib/features/user/widgets/account_info_card.dart`, spostata da `settings/widgets` perché usata solo qui): ID, nome, email e data di creazione (`dd/MM/yyyy`), con divisori del tema
- Pulsanti "Esci" e "Elimina account" come `AppButton.outlined` (il secondo nel colore di errore)
- Dati caricati da Firestore tramite `AuthController`

**Eliminazione account (`delete_account_screen.dart`):**
- Conferma con re-autenticazione prima dell'eliminazione
- Elimina tutti i dati utente da Firestore e l'account da Firebase Auth

---

### 5.12 Impostazioni

**Percorso:** `lib/features/settings/screens/settings_screen.dart`

Configurazione globale dell'app organizzata in 4 sezioni.

La screen contiene solo il contenuto delle sezioni; i mattoni visivi sono in `lib/features/settings/widgets/settings_tiles.dart`, accanto a `section_card.dart`: `SettingsGroup` (titolo + card della sezione), `SettingsNavTile` (voce con freccia che apre una schermata o esegue un'azione), `SettingsSwitchTile` (voce con `Switch`) e `SettingsSegmentedTile<T>` (voce con `SegmentedButton` a scelta singola, scrollabile orizzontalmente). Lo stato arriva da `SettingsController` tramite `Obx`; la lingua, non osservabile, viene salvata e applicata con `Get.updateLocale`.

| Sezione | Impostazione | Dettaglio |
|---|---|---|
| **Generale** | Tema | Sistema / Chiaro / Scuro, tramite `SegmentedButton<ThemeMode>` (Sistema segue la luminosità del dispositivo) |
| **Generale** | Colore principale | Selezione di una tra 8 palette predefinite (`AccentPresets` in `lib/core/theme/accent_presets.dart`), ognuna con una tonalità ottimizzata per il tema chiaro e una per lo scuro; segmenti mostrano solo lo swatch colorato (senza etichetta testuale, nome disponibile tramite `Tooltip` a pressione prolungata) tramite `SegmentedButton<int>` (scroll orizzontale se non entra tutto a schermo) |
| **Generale** | Lingua | Italiano / English, tramite `SegmentedButton<String>` (cambia `Get.locale`) |
| **Scansione** | Beep | Abilita/disabilita suono alla scansione |
| **Scansione** | Vibrazione | Abilita/disabilita vibrazione alla scansione |
| **Account** | Profilo | Naviga a `UserScreen` (`AppRoutes.user`) — avatar, dati account, logout, eliminazione account |
| **Account** | Database | Accede alla schermata Database (statistiche + export) |
| **Account** | Logout | Disconnette l'utente corrente |
| **Account** | Elimina account | Naviga alla schermata di eliminazione account |
| **App** | Informazioni | Info sull'app |
| **App** | Novità | Apre `AppChangelogDialog.showAll`, con l'intero storico di `changelogEntries` (non solo le novità dall'ultimo aggiornamento) |
| **App** | Privacy Policy | Visualizza la privacy policy in WebView |
| **App** | Supporto | Contatta l'autore |
| **App** | Condividi | Condivide il link dell'app tramite sistema operativo |

**Changelog dialog** (`AppChangelogDialog` in `lib/core/widgets/app_changelog_dialog.dart`): le voci sono definite in `lib/core/constants/changelog.dart` (`changelogEntries`, una lista di `ChangelogEntry` versione + bullet localizzati, ordinata dalla più recente). Va aggiornata ad ogni cambiamento user-facing, mantenendo `version` allineata a `version:` in `pubspec.yaml` — vedi CLAUDE.md. La versione mostrata nel dialog e nella schermata Info (`InfoScreen`) è `AppVersion.current` (`lib/core/constants/app_version.dart`), letta a runtime dal build della piattaforma tramite `package_info_plus` in `main()` — non è più una costante da aggiornare manualmente né una chiave di traduzione duplicata negli arb.

---

### 5.13 Database

**Percorso:** `lib/features/settings/screens/database_screen.dart`

Schermata avanzata di gestione dati accessibile dalle impostazioni.

**App bar:** due `IconButton` diretti per Import (`mgc_file_import_line`) ed Export JSON (`mgc_file_export_line`), al posto del precedente menu a tendina (kebab) che nascondeva le due azioni dietro un `PopupMenuButton`.

**Statistiche visualizzate (`StatisticsSection`):**
- Riga di 3 `_StatCard` (Totale, Creati, Scansionati) con icona, numero in evidenza ed etichetta, per una lettura immediata dei KPI principali
- `_DistributionBar` con il rapporto creati/scansionati
- `_SourceTile` (Creati/Scansionati) con la sola label e l'eventuale breakdown per tipo (standard/social) al tap — il badge numerico duplicato è stato rimosso dall'header di ogni tile poiché il conteggio è già mostrato nella riga di `_StatCard` sovrastante

**Export:**
- **CSV** — Esporta tutti i codici in formato CSV
- **Excel** — Esporta tutti i codici in formato XLSX
- **PDF** — Genera un PDF con pagina di copertina, pagina statistiche e una pagina per ogni codice (con immagine QR)

**Import/Export JSON:**
- Importa un file JSON precedentemente esportato per ripristinare i dati
- Esporta tutti i codici in formato JSON
- L'export scrive il file nella directory restituita da `getDownloadsDirectory()` (su Android è privata dell'app e viene cancellata alla disinstallazione) e ne salva una copia anche nella cartella Download pubblica con `saveBytesToPublicDownloads` (`application/json`), come già avveniva per PDF/Excel/CSV
- **Sezione "Backup JSON"** (`BackupSection`, `lib/features/settings/widgets/backup_section.dart`): mostra data e ora dell'ultima esportazione e dell'ultima importazione riuscite, oppure "Mai". I timestamp sono salvati sul dispositivo da `BackupHistory` (`lib/features/settings/services/backup_history.dart`) in `SharedPreferences`, con chiavi per utente (`backup_last_export_<uid>`, `backup_last_import_<uid>`), ed esposti da `DatabaseController` come `lastExportAt`/`lastImportAt`

Tutte le operazioni mostrano una barra di avanzamento animata.

---

## 6. Controllers (State Management)

L'app usa **GetX** come sistema di state management. Le screen ottengono i controller solo con `Get.find`; la registrazione è centralizzata nei **binding**:

| Binding | Dove | Registra |
|---|---|---|
| `AppBinding` (`lib/core/bindings/app_binding.dart`) | chiamato in `main()` prima di `runApp` (`QrationApp` legge `ThemeController` già al primo frame) | permanenti: `ThemeController`, `ScannerPreferencesController`, `CodesRepository` (`CodesService`), `AuthController` |
| `HomeBinding` (`features/home/bindings/`) | `GetPage` di `home` | `ScannerController`, `FavoritesController`, `HistoryController`, `SettingsController` (i tab vivono nell'`IndexedStack` di Home, quindi seguono la rotta Home: vengono rimossi al logout con `offAllNamed` e ricreati per l'utente successivo) |
| `ScannerBinding` | `scanner` | `ScannerController` |
| `SettingsBinding` / `DatabaseBinding` (`features/settings/bindings/`) | `settings` / `settingsDatabase` | `SettingsController` / `DatabaseController` (con l'uid dell'utente corrente) |
| `CodeCreateStandardBinding`, `CodeCreateSocialBinding`, `CodeDetailsBinding` (`features/codes/bindings/code_bindings.dart`) | `codeCreateStandard`, `codeCreateSocial`, `codeDetails` | il controller della schermata, costruito con l'argomento della rotta (`Get.arguments`: `BarcodeType`, `CodeSocial`, `CodeModel`). Se l'argomento manca o è del tipo sbagliato non registrano nulla, e la `GetPage` ripiega su `HomeScreen` |

I binding di rotta usano `Get.lazyPut`: grazie alla smart management di GetX il controller viene creato alla prima `Get.find` e rimosso quando la rotta viene chiusa, sostituendo i `Get.put`/`Get.delete` che prima erano sparsi in `initState`/`dispose` delle screen (e, per `AuthController`, perfino dentro `build()` di Login, Registrazione, Reset password e Home). Poiché `AuthController` è ora permanente, `clearForm()` svuota i campi del form (email, password, nome, conferma) e resetta "Ricordami" dopo login, registrazione, reset password e logout, così i dati digitati non restano in memoria né ricompaiono alla visita successiva.

| Controller | Responsabilità |
|---|---|
| `ThemeController` | Modalità tema (`ThemeMode` system/light/dark, `isDark` = luminosità effettiva) e colore principale selezionato (`AccentPreset`, indice persistito in `SharedPreferences`), applicati a `AppTheme.lightTheme`/`darkTheme` tramite il parametro `primary`, aggiornamento `SystemChrome` |
| `ScannerPreferencesController` | Preferenze di feedback della scansione (`beepEnabled`, `vibrateEnabled`) osservabili e persistite in `SharedPreferences`; registrato in `main.dart` e letto da `ScannerScreen` al momento di ogni rilevamento, così una modifica nelle Impostazioni ha effetto subito anche se lo scanner resta vivo nell'`IndexedStack` di Home |
| `AuthController` | Stato autenticazione, operazioni login/logout/signup, recupero dati utente |
| `SettingsController` | Facade senza stato proprio per la schermata Impostazioni: espone e modifica `themeMode`/`accentIndex` delegando a `ThemeController` e `beepEnabled`/`vibrateEnabled` delegando a `ScannerPreferencesController` |
| `HistoryController` | Stato e azioni della Cronologia: sottoscrizione unica allo stream dei codici, ricerca con debounce (300 ms), filtri tipo/social/sorgente con lista filtrata memoizzata, selezione multipla ed eliminazione in blocco |
| `CodeDetailsController` | Stato e azioni della schermata Dettaglio codice (preferito, note, salvataggio/condivisione immagine, apertura URL/email/telefono/SMS/contatto/mappa/Wi-Fi/calendario, eliminazione) |
| `CodeCreateStandardController` | Stato del form di creazione QR standard (`TextEditingController` per campo, colori/arrotondamento occhi e moduli, prefisso telefonico, cifratura Wi-Fi), generazione del contenuto per tipo e creazione del `CodeModel` |
| `CodeCreateSocialController` | Stato del form di creazione QR social (campi URL/Spotify/WhatsApp, colori/arrotondamento occhi e moduli, logo, prefisso), costruzione del contenuto per social (`buildContent`) e creazione del `CodeModel` |
| `ScannerController` | Pipeline di scansione: filtro duplicati (`RescanGuard`) e flag `isProcessing`, feedback beep/vibrazione secondo `ScannerPreferencesController`, costruzione del `CodeModel` (template social per i link) e salvataggio con timeout di 3 s |
| `FavoritesController` | Stream dei preferiti sottoscritto una sola volta, stato di caricamento/errore e liste per tab (creati/scansionati) ordinate per data |
| `DatabaseController` | Statistiche codici (totali, creati, scansionati, distribuzione per tipo), generazione export PDF/Excel/CSV, export/import JSON (con copia nella Download pubblica) e timestamp dell'ultimo backup (`lastExportAt`/`lastImportAt`, via `BackupHistory`, per utente) |

---

## 7. Servizi

### 7.1 Autenticazione (AuthController)

**Percorso:** `lib/features/auth/controllers/auth_controller.dart` (+ `lib/features/auth/services/session_store.dart` per il flag "Ricordami")

**Testabilità:** Firebase Auth, Firestore, Google Sign-In, `SessionStore` e la navigazione (`navigateTo`/`navigateBack`) sono iniettabili nel costruttore, con le istanze reali come default (`AppBinding` usa il costruttore vuoto). `login`/`signup`/`resetPassword` validano il `Form` e poi chiamano `submitLogin`/`submitSignup`/`submitResetPassword`, che contengono la logica e si possono testare senza widget. L'ultimo errore è esposto in `lastError`; il toast d'errore usa `Get.key.currentContext`, nullable, invece di `Get.context`, che fallisce se l'app non è ancora montata. I test (`test/features/auth/controllers/auth_controller_test.dart`) usano `firebase_auth_mocks`, `fake_cloud_firestore` e un `GoogleSignIn` finto con mocktail.

Gestisce tutta la logica di autenticazione tramite Firebase Auth e Firestore. In precedenza esisteva anche un `auth_service.dart` con una copia divergente di queste operazioni, non usato da nessun file: è stato rimosso.

**Operazioni:**
- **Registrazione email/password:** controlla se l'email è già registrata su Firestore, crea le credenziali Firebase Auth, salva il `UserModel` su Firestore
- **Login email/password:** cerca l'email su Firestore per ottenere l'email primaria, esegue `signInWithEmailAndPassword`. Gestisce errori specifici (`email_not_found`, `invalid_password`)
- **Login con Google:** avvia il flusso OAuth `GoogleSignIn`, ottiene le credenziali Google, esegue `signInWithCredential`. Se è un nuovo utente Google, crea il `UserModel` su Firestore
- **Ricorda me:** gestito da `SessionStore` (`lib/features/auth/services/session_store.dart`), che salva `remember_me = true` e `user_id` in `SharedPreferences`. Con email/password avviene solo se la checkbox è attiva; con Google e dopo la registrazione avviene sempre
- **Recupero dati utente:** legge il documento `users/{uid}` da Firestore e restituisce `UserModel`
- **Logout:** esegue `signOut` su Firebase Auth e Google Sign-In e cancella la sessione salvata (`SessionStore.clear()`)
- **Reset password:** invia email di reset tramite `sendPasswordResetEmail`
- **Eliminazione account:** elimina tutti i codici dell'utente da Firestore, elimina il documento utente, quindi elimina l'account Firebase Auth

---

### 7.2 Codici (codes_service)

**Percorso:** `lib/features/codes/services/codes_service.dart` (implementa l'interfaccia `CodesRepository` in `codes_repository.dart`)

Gestisce tutte le operazioni CRUD sui codici su Firestore, nella collection `users/{uid}/codes`. Le screen e i service export dipendono dall'interfaccia `CodesRepository`, risolta tramite `Get.find<CodesRepository>()`, non dalla classe concreta.

**Operazioni:**
- **`addCode`:** aggiunge un nuovo codice, ottiene l'ID del documento generato da Firestore e lo aggiorna nel modello
- **`deleteCode`:** elimina un singolo codice per ID
- **`deleteAllCodes`:** elimina tutti i codici dell'utente
- **`updateCodeNotes`:** aggiorna solo il campo `notes` di un codice specifico
- **`toggleFavorite`:** inverte il flag `isFavorite` di un codice
- **`getCodesStream`:** restituisce uno `Stream` della collection codici per aggiornamenti in tempo reale

---

### 7.3 Export CSV (csv_service)

**Percorso:** `lib/features/export/services/csv_service.dart`

Esporta tutti i codici dell'utente in formato CSV.

**Formato output:**
- Recupera tutti i codici da Firestore e li ordina dalla data più recente
- Colonne: ID, Data, Sorgente, Tipo, Contenuto, Colore occhi, Arrotondamento occhi, Colore moduli, Arrotondamento moduli, Preferito, Social
- Colori in formato HEX (`#RRGGBB`)
- Salva nel filesystem locale tramite `path_provider` (`getDownloadsDirectory()`, storage app-scoped: nessun permesso runtime richiesto)
- Copia automaticamente il file nella cartella pubblica Download tramite `downloads_saver.dart` (MethodChannel nativo `com.ndn21.qration/downloads`): su Android 10+ (API 29+) via `MediaStore`, senza permessi; su Android 9 e precedenti richiede il permesso `WRITE_EXTERNAL_STORAGE` prima di scrivere

---

### 7.4 Export Excel (excel_service)

**Percorso:** `lib/features/export/services/excel_service.dart`

Esporta tutti i codici in formato XLSX nativo.

**Caratteristiche:**
- Intestazione con titolo "QRation" in grassetto nella prima riga
- Righe intestazione colonne con stile dedicato
- Colonne equivalenti al CSV
- Larghezza colonne auto-dimensionata
- Utilizza la libreria `excel` per la generazione del file

---

### 7.5 Export PDF (pdf_service)

**Percorso:** `lib/features/export/services/pdf_service.dart`

Genera un documento PDF professionale con una pagina per ogni codice.

**Struttura del documento:**
- **Pagina di copertina:** logo dell'app, titolo, data di generazione
- **Pagina statistiche:** riepilogo totale codici, suddivisione creati/scansionati, distribuzione per tipo
- **Pagina per ogni codice:** immagine QR code, ID, data, tipo, contenuto, sorgente, preferito

**Caratteristiche tecniche:**
- Font Montserrat (regular + bold) caricato da assets
- Logo app incluso dalla cartella assets
- Progresso esportazione restituito tramite callback `Function(double)`
- Salvataggio tramite `path_provider` (`getDownloadsDirectory()`, storage app-scoped: nessun permesso runtime richiesto)
- Copia automaticamente il file nella cartella pubblica Download tramite `downloads_saver.dart` (MethodChannel nativo `com.ndn21.qration/downloads`): su Android 10+ (API 29+) via `MediaStore`, senza permessi; su Android 9 e precedenti richiede il permesso `WRITE_EXTERNAL_STORAGE` prima di scrivere

---

## 8. Tema e stile

**Percorso:** `lib/core/theme/`

**Font:** Montserrat, incluso come asset locale (`assets/fonts/Montserrat.ttf`/`Montserrat-Bold.ttf`, famiglia `Montserrat` in `pubspec.yaml`) e usato tramite `AppFonts.montserrat(...)` (`app_fonts.dart`) al posto del package `google_fonts` (rimosso). Font icone personalizzate `QrationIcons` incluse come asset locali.

Essendo solo 2 i file font disponibili (Regular e Bold), in `pubspec.yaml` sono registrati con `weight: 400` e `weight: 900` (non 700): Flutter sceglie il file più vicino al `FontWeight` richiesto, e con Bold a 900 i pesi intermedi usati in tutto il codice come "semibold" (`FontWeight.w500`/`w600`, ~110 punti di utilizzo) restano vicini a Regular invece di risolvere erroneamente al file Bold — evitando che gran parte del testo dell'app appaia eccessivamente in grassetto. I titoli esplicitamente `FontWeight.w700`+ continuano a risolvere correttamente al file Bold. Se in futuro si aggiungono asset font per pesi intermedi reali (Medium/SemiBold), questo escamotage andrebbe rimosso.

Per ridurre ulteriormente la sensazione di grassetto invasivo, tutti i punti del codice sotto `lib/` sono stati scalati di un livello: `FontWeight.bold`/`w700` → `w600`, `w600` → `w500` (i pesi `w500`/`w400` esistenti restano invariati).

**Temi supportati:**
- **Chiaro** (`AppTheme.lightTheme({Color primary})`)
- **Scuro** (`AppTheme.darkTheme({Color primary})`)

La modalità tema (`ThemeMode.system`/`light`/`dark`) è salvata in `SharedPreferences` alla chiave `theme_mode` (`String`, nome dell'enum; default `system`). Al primo avvio dopo l'aggiornamento il vecchio booleano `theme_preference` viene migrato (`true` → `dark`, `false` → `light`) e rimosso. Il `ThemeController` aggiorna anche il `SystemChrome` (colore della status bar e navigation bar) in base alla luminosità effettiva e, tramite `WidgetsBindingObserver.didChangePlatformBrightness`, lo riallinea quando in modalità Sistema l'utente cambia tema dal dispositivo.

**Colore principale personalizzabile:** `lightTheme`/`darkTheme` accettano un parametro opzionale `primary` (default `AppColors.qrBlue`/`AppColors.qrGold`, cioè il comportamento storico) che rimpiazza gli usi "brand/accent" del colore identitario del tema (es. `colorScheme.primary`/`tertiary`, app bar, bottom/navigation bar, bottoni, focus border, checkbox/switch selezionati, date/time picker, cursore testo, chip e icone `ListTile`); gli usi del colore "complementare" (oro in chiaro, blu in scuro) restano invariati per non introdurre problemi di contrasto. L'utente sceglie tra 8 palette predefinite in `AccentPresets` (`lib/core/theme/accent_presets.dart`, preset `'blue'` = valori storici); l'indice selezionato è salvato in `SharedPreferences` alla chiave `accent_preset_index` e gestito da `ThemeController`.

**Unica sorgente di verità:** `ThemeController` espone solo lo stato osservabile (`themeMode`, `currentAccent`) e non chiama mai `Get.changeTheme`. È `QrationApp` (`app.dart`), dentro l'`Obx` che avvolge `GetMaterialApp`, a costruire `theme:`/`darkTheme:` con `currentAccent.light`/`.dark` e `themeMode` dal controller: ogni cambio di tema o accent ricostruisce l'app con i valori corretti, evitando che un rebuild riporti l'accent al colore di default.

**Colori:** Definiti in `app_colors.dart`. Palette distinta per tema chiaro e scuro.

**Responsività UI:** Tutte le dimensioni (padding, font size, icon size) usano `flutter_screenutil` con suffissi `.sp`, `.r`, `.w`, `.h` per adattarsi a qualsiasi schermo.

**Token condivisi:** `AppFontSizes` (`app_font_sizes.dart`) e `AppRadius` (`app_radius.dart`) centralizzano i valori di font size e border radius ricorrenti, da preferire ai valori `.sp`/`.r` inline quando coincidono con un token esistente.

**Linea guida visiva delle schermate:** le app bar non impostano colori propri (valgono `appBarTheme`: sfondo superficie, titolo e icone nel colore principale), gli `Switch` usano `switchTheme` (traccia neutra da spento, colore principale da acceso), i testi usano `onSurface`/`onSurfaceVariant` e i contenuti sono raggruppati in `SectionCard` (`lib/core/widgets/section_card.dart`: titolo con icona + card con bordo; spostata da `settings/widgets` perché usata anche da Dettaglio, Crea, Info e Database). Il colore principale si usa solo per accenti, icone e azione principale. Dettaglio codice, Crea codice, Info e Profilo sono stati riallineati a questa linea: in precedenza usavano il colore principale come sfondo pieno di app bar e card e il colore secondario per i testi, con contrasti insufficienti (ad esempio testo blu su blu in Info e nel form di creazione). Le intestazioni di Info ora sono con iniziale maiuscola come nel resto dell'app.

**Stati vuoti/errore:** `AppEmptyState` (`app_empty_state.dart`) e `AppErrorState` (`app_error_state.dart`), entrambi in `lib/core/widgets/`, forniscono la UI standard per liste vuote e stati di errore, da riusare al posto di implementazioni inline. `lib/core/widgets/` contiene un file per ogni widget condiviso (`app_button.dart`, `app_textfield.dart`, `app_toast.dart`, `app_loader.dart`, `app_empty_state.dart`, `app_error_state.dart`, `app_delete_dialog.dart`, `app_changelog_dialog.dart`), tutti con convenzione `App*`. La cartella `lib/widgets/` (ex contenitore di widget "globali" ma di fatto usati da una sola feature ciascuno) è stata rimossa: `custom_picker_field.dart`, `full_screen_map.dart` e `custom_loader.dart` sono ora in `lib/features/codes/widgets/code_create/` (usati solo dal flusso di creazione standard), `custom_expansiontile.dart` è in `lib/features/settings/widgets/` (usato solo da `support_screen.dart`).

`AppEmptyState` accetta una call-to-action opzionale (`actionLabel` + `onAction`, mostrata come `FilledButton.tonal` solo se entrambi sono presenti). Preferiti e Cronologia ricevono da `HomeScreen` le callback `onCreateCode`/`onScanNow`, che cambiano tab (Crea / Scansiona) senza introdurre dipendenze tra le feature. Nei Preferiti senza codici il pulsante è "Crea il tuo primo codice"; in Cronologia `HistoryController.hasCodes` e `hasActiveFilters` distinguono il vuoto reale ("Nessun codice salvato" + "Scansiona ora") dal vuoto dovuto ai filtri ("Nessun risultato per i filtri attivi" + "Azzera i filtri", che chiama `clearFilters()` e svuota anche il campo di ricerca). Il caricamento dei Preferiti usa `AppLoader` come il resto dell'app.

---

## 9. Navigazione

L'app usa il **routing dichiarativo di GetX** con named routes definite in `app_routes.dart` e la mappa dei widget in `app_pages.dart`.

**Flusso di navigazione principale:**

```
Splash
  ├── (primo avvio) → Onboarding → Welcome
  ├── (non autenticato) → Welcome → Login / Signup
  └── (autenticato) → Home
                          ├── Scanner → Dettaglio
                          ├── Crea (Selezione tipo) → Form creazione → Dettaglio
                          ├── Preferiti → Dettaglio
                          ├── Cronologia → Dettaglio
                          └── Impostazioni
                                ├── Profilo utente
                                ├── Database
                                ├── Info
                                ├── Privacy Policy
                                ├── Supporto
                                └── Elimina account
```

**Route definite:**

| Costante | Percorso | Schermata |
|---|---|---|
| `splash` | `/` | SplashScreen |
| `onboarding` | `/onboarding` | OnboardingScreen |
| `welcome` | `/welcome` | WelcomeScreen |
| `login` | `/login` | LoginScreen |
| `signup` | `/signup` | SignupScreen |
| `resetPassword` | `/reset-password` | ResetPasswordScreen |
| `home` | `/home` | HomeScreen |
| `scanner` | `/scanner` | ScannerScreen |
| `codeCreateStandard` | `/code-create-standard` | CodeCreateStandardScreen |
| `codeCreateSocial` | `/code-create-social` | CodeCreateSocialScreen |
| `codeDetails` | `/code-details` | CodeDetailsScreen |
| `user` | `/user` | UserScreen |
| `deleteAccount` | `/delete-account` | DeleteAccountScreen |
| `settings` | `/settings` | SettingsScreen |
| `settingsDatabase` | `/settings-database` | DatabaseScreen |
| `settingsInfo` | `/settings-info` | InfoScreen |
| `settingsPolicy` | `/settings-policy` | PolicyScreen |
| `settingsSupport` | `/settings-support` | SupportScreen |

---

## 10. Impostazioni disponibili

Riepilogo di tutte le chiavi salvate in `SharedPreferences`:

| Chiave | Tipo | Default | Descrizione |
|---|---|---|---|
| `theme_mode` | `String` | `system` | Tema: `system`, `light` o `dark` (sostituisce il vecchio `theme_preference` bool, migrato automaticamente) |
| `language_code` (`QrationApp.languageKey`) | `String` | `''` (sistema) | Lingua: `en` / `it`. Letta in `main()` con `QrationApp.loadSavedLocale()` prima di `runApp` e passata come `initialLocale` a `QrationApp`, così il primo frame usa già la lingua scelta; i cambi successivi dalle Impostazioni passano da `Get.updateLocale` |
| `beepEnabled` | `bool` | `false` | Beep audio alla scansione |
| `vibrateEnabled` | `bool` | `false` | Vibrazione alla scansione |
| `remember_me` | `bool` | `false` | Mantieni sessione al riavvio |
| `user_id` | `String` | `''` | UID Firebase dell'utente autenticato |
| `backup_last_export_<uid>` | `int` | assente | Millisecondi epoch dell'ultima esportazione JSON riuscita per quell'utente |
| `backup_last_import_<uid>` | `int` | assente | Millisecondi epoch dell'ultima importazione JSON riuscita per quell'utente |

---

## 11. Dipendenze

**Firebase (FlutterFire):** `firebase_core` 4, `firebase_auth` 6, `cloud_firestore` 6 e `firebase_crashlytics` 5 vanno aggiornati insieme (stesso rilascio FlutterFire, Firebase Android BoM 34.x); per i test seguono `fake_cloud_firestore` 4 e `firebase_auth_mocks` 0.15. Il passaggio dalle versioni 3/5/5/4 non ha richiesto modifiche al codice Dart (le API rimosse non erano usate). `android/app/build.gradle` non dichiara dipendenze native Firebase o Google: BoM, `firebase-auth` e `play-services-auth` arrivano dai plugin, e le versioni fissate a mano (in precedenza `firebase-auth:22.3.0`, BoM `33.1.1`, `play-services-auth:19.0.0`) sono state rimosse perché entravano in concorrenza con quelle dei plugin. `google_sign_in` è rimasto alla 6: la 7 cambia completamente l'API di login ed è un aggiornamento separato.

```yaml
dependencies:
  get: ^4.6.6                          # State management e routing
  flutter_screenutil: ^5.9.3           # UI responsiva
  ming_cute_icons: ^0.0.7              # Icone UI
  line_awesome_flutter: ^3.0.1         # Icone aggiuntive
  smooth_page_indicator: ^1.2.0+3      # Indicatore pagine onboarding
  flutter_colorpicker: ^1.1.0          # Selezione colore QR
  toastification: ^2.3.0               # Toast/notifiche UI
  flutter_animate: ^4.5.0              # Animazioni
  firebase_core: ^4.15.0               # Firebase core
  firebase_auth: ^6.7.0                # Autenticazione Firebase
  cloud_firestore: ^6.10.0             # Database cloud
  firebase_crashlytics: ^5.4.0         # Error reporting in produzione
  google_sign_in: ^6.2.1               # Login con Google
  mobile_scanner: ^7.4.0               # Scanner QR/barcode
  pretty_qr_code: ^3.6.0               # Generazione QR code
  path_provider: ^2.1.5                # Percorsi filesystem
  shared_preferences: ^2.3.4           # Persistenza locale
  permission_handler: ^11.3.1          # Gestione permessi
  device_info_plus: ^11.2.0            # Info dispositivo
  image_picker: ^1.1.2                 # Selezione immagine galleria
  image_gallery_saver_plus: ^4.0.1     # Salvataggio galleria
  screenshot: ^3.0.0                   # Screenshot widget
  audioplayers: ^6.1.0                 # Riproduzione audio beep
  vibration: ^3.1.3                    # Vibrazione dispositivo
  share_plus: ^10.1.1                  # Condivisione file e testo
  url_launcher: ^6.3.1                 # Apertura URL/app esterne
  country_code_picker: ^3.1.0          # Prefissi telefonici internazionali
  flutter_contacts: ^1.1.9+2           # Salvataggio contatti
  add_2_calendar: ^3.0.1               # Aggiunta eventi calendario
  wifi_iot: ^0.3.19+2                  # Connessione Wi-Fi
  free_map: ^2.0.2                     # Mappa per coordinate geo
  webview_flutter: ^4.8.0              # WebView per privacy policy
  pdf: ^3.11.1                         # Generazione PDF
  excel: ^4.0.6                        # Export Excel
  csv: ^6.0.0                          # Export CSV
  file_picker: ^9.0.2                  # Selezione file per import
  intl: ^0.19.0                        # Formattazione date
  logger: ^2.5.0                       # Logging
  flutter_localizations:               # Localizzazione Flutter
    sdk: flutter
```

---

## 12. Requisiti di sistema

| Requisito | Valore |
|---|---|
| Flutter SDK | `^3.5.2` |
| Dart SDK | `^3.5.2` |
| Android minimo | API 24 (Android 7.0), imposto da Flutter tramite `minSdkVersion flutter.minSdkVersion` in `android/app/build.gradle` |
| Android consigliato | API 29+ (Android 10) per accesso storage senza permessi |
| Piattaforma principale | Android |
| Piattaforma secondaria | Web (funzionalità fotocamera, Wi-Fi e contatti non disponibili) |
| Servizi richiesti | Firebase project (Auth + Firestore) con `google-services.json` |

---

## 12b. Test

I test sono in `test/` e rispecchiano la struttura di `lib/` (`flutter test`; lint con `flutter analyze --fatal-infos --fatal-warnings`). Coprono:

- **Modelli e utility** (`test/core/utils`, `test/features/codes/models`): parsing dei contenuti, validator, formattazione ISBN, decorazioni QR.
- **Controller**: codici (dettaglio, creazione social, scanner), `HistoryController`, `FavoritesController`, `SyncStatusMixin`, `DatabaseController` (statistiche, export PDF/Excel/CSV, storico backup), `AuthController` (login, Google, registrazione, reset, logout, eliminazione account), `ThemeController`, `ScannerPreferencesController`, `SessionStore`, `BackupHistory`, `RescanGuard`.
- **Binding** (`test/features/bindings_test.dart`): controller registrati da `HomeBinding` e dai binding con argomento di rotta, incluso il caso di argomento mancante.
- **Widget**: `CodeListTile`, `AppEmptyState`, `SyncStatusBanner`, `BackupSection`, sezioni del Database e le screen Cronologia, Preferiti e Impostazioni.

Note pratiche: il font dei test (Ahem) è più largo di Montserrat, quindi negli scroll orizzontali può servire `tester.ensureVisible` prima di un tap; i controller con timer (es. `SyncStatusMixin`) vanno creati dentro `testWidgets` perché `tester.pump` controlli il tempo; i controller che caricano `SharedPreferences` in `onInit` richiedono `SharedPreferences.setMockInitialValues` e un `pumpEventQueue()` prima di interagire.

## 13. Build e distribuzione

```bash
# Installa le dipendenze
flutter pub get

# Controlla eventuali problemi
flutter doctor

# Avvia in modalità debug
flutter run

# Build APK release
flutter build apk --release

# Build App Bundle (consigliato per Google Play)
flutter build appbundle --release
```

**Prerequisiti per il build release:**
- File `android/app/google-services.json` configurato con il progetto Firebase di produzione
- Keystore di firma configurato in `android/app/build.gradle`
- Il file `android/local.properties` non va committato (contiene percorsi locali SDK)
- La cartella `build/` non va committata (output di compilazione)

---

## Licenza

Copyright © 2026 **Nicola De Nicolais** — Tutti i diritti riservati.

Licenza: **source-available, non-commerciale** (vedi [LICENSE](LICENSE)).

L'uso commerciale (inclusa la pubblicazione o monetizzazione su qualsiasi app store) richiede il consenso scritto esplicito del detentore del copyright.

- **Autore:** Nicola De Nicolais
- **Email:** [ndn21dev@gmail.com](mailto:ndn21dev@gmail.com)
- **GitHub:** [https://github.com/ndenicolais](https://github.com/ndenicolais)
