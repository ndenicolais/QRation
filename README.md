# QRation

> App per la scansione e la creazione di QR code, sviluppata con Flutter.

**QRation** è un'app completa per la gestione di QR code e codici a barre. Permette di scansionare codici tramite fotocamera o galleria, creare QR code personalizzati per più di 12 tipologie standard e 10 social network, gestire una cronologia sincronizzata su cloud e molto altro — il tutto con un'interfaccia disponibile in italiano e inglese e pieno supporto al tema scuro.

---

## Funzionalità principali

- **Scanner** — Scansiona QR code e codici a barre con la fotocamera o importando un'immagine dalla galleria
- **Creazione QR** — Crea QR code personalizzati per testo, URL, email, telefono, SMS, contatto, geo, Wi-Fi, evento calendario, prodotto, ISBN, patente
- **Social QR** — Genera QR code per profili social: YouTube, Facebook, Instagram, TikTok, Telegram, LinkedIn, X, Pinterest, Spotify, WhatsApp
- **Personalizzazione** — Scegli colori e arrotondamento per occhi e moduli del QR code con anteprima live
- **Cloud sync** — Tutti i codici sono salvati su Firebase Firestore e sincronizzati tra sessioni
- **Cronologia** — Lista completa dei codici con ricerca testuale e filtri per tipo, social e sorgente
- **Preferiti** — Marca i codici preferiti e consultali rapidamente per tab (scansionati / creati)
- **Dettaglio codice** — Visualizza, copia, condividi, salva in galleria, apri o elimina ogni codice
- **Export dati** — Esporta i codici in CSV, Excel o PDF con statistiche; backup e ripristino JSON
- **Autenticazione** — Login con email/password o Google Sign-In; gestione profilo e eliminazione account
- **Tema** — Tema chiaro, scuro o automatico (segue il sistema)
- **Lingua** — Interfaccia in italiano e inglese

---

## Architettura

| Livello | Tecnologia |
|---|---|
| Framework | Flutter 3 / Dart |
| State management | GetX |
| Backend / Database | Firebase Firestore |
| Autenticazione | Firebase Auth + Google Sign-In |
| Scanner QR | mobile_scanner |
| Generazione QR | qr_flutter |
| UI responsiva | flutter_screenutil |
| Font | Montserrat (Google Fonts) |
| Export | pdf, excel, csv |

---

## Struttura del progetto

```
lib/
├── main.dart                  # Entry point
├── app.dart                   # QrationApp (GetMaterialApp + routing + localizzazione)
├── core/
│   ├── constants/             # Costanti globali (tipi barcode, social list, URI)
│   ├── routes/                # Named routes (app_routes, app_pages)
│   ├── theme/                 # Tema, colori, ThemeController
│   ├── utils/                 # Utility (icone/testi per tipo codice, validator)
│   └── widgets/               # Widget core riutilizzabili
├── features/
│   ├── auth/                  # Login, Signup, Reset password, AuthController, SessionStore
│   ├── codes/                 # Scanner, Creazione QR, Dettaglio, Modelli, CodesService
│   ├── export/                # CSV, Excel, PDF services
│   ├── favorites/             # Schermata preferiti
│   ├── history/               # Cronologia codici
│   ├── home/                  # Home + bottom navigation
│   ├── onboarding/            # Onboarding al primo avvio
│   ├── settings/              # Impostazioni, Database, Info, Policy, Support
│   ├── splash/                # Splash screen
│   ├── user/                  # Profilo utente, Elimina account
│   └── welcome/               # Schermata di benvenuto
└── l10n/                      # File di localizzazione (EN + IT)
```

---

## Requisiti

- Flutter SDK `^3.5.2`
- Dart SDK `^3.5.2`
- Android 7.0+ (API 24+)
- Progetto Firebase configurato con `google-services.json` (Auth + Firestore)

---

## Installazione e avvio

```bash
# Clona il repository
git clone https://github.com/ndenicolais/qration.git
cd qration

# Installa le dipendenze
flutter pub get

# Avvia l'app
flutter run
```

---

## Documentazione completa

Per una documentazione dettagliata di tutte le funzionalità, modelli dati, schermate e scelte tecniche consulta il file [DOCUMENTATION.md](DOCUMENTATION.md).

---

## Licenza

Copyright © 2026 Nicola De Nicolais — Tutti i diritti riservati.  
Licenza: source-available, non-commerciale (vedi [LICENSE](LICENSE)).  
L'uso commerciale (inclusa la pubblicazione su app store) richiede il consenso scritto dell'autore.

**Autore:** Nicola De Nicolais — [ndn21dev@gmail.com](mailto:ndn21dev@gmail.com) — [GitHub](https://github.com/ndenicolais)
