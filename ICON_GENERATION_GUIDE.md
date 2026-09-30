# Guida: generare tutte le icone di un'app Flutter da un solo logo

> Guida generica, ricavata dalle icone di Shox (settembre 2026). Copiala nel progetto e seguila in ordine. Si parte da **un solo PNG** del logo; tutto il resto viene generato.

## Il flusso in breve

```
app_logo.png  (lo disegni/esporti tu)
   │
   ├─ script PowerShell ──► app_icon_legacy.png       (1024, logo 84%, trasparente)
   │                        app_icon_foreground.png   (1024, logo 62%, trasparente)
   │                        images/icons/icon_512.png  icon_192.png  oauth_logo_120.png  favicon_32.png
   │
   └─ dart run flutter_launcher_icons ──► tutte le icone Android (mipmap-*, drawable-*, XML adattivo, colore di sfondo)
```

---

## 1. Il logo sorgente (l'unico file che fai tu)

`assets/images/app_logo.png`:

| Requisito | Perché |
|---|---|
| **Quadrato**, idealmente **1024×1024** (minimo 512) | Tutte le icone sono quadrate; più grande = più nitido |
| **Sfondo trasparente** | Lo sfondo lo aggiunge lo script con il colore dell'app |
| Logo che **riempie quasi tutto il canvas** (margine ≤ 2–4%) | Le proporzioni finali le decide lo script; margini extra lo rimpicciolirebbero |
| Forme semplici, tratti non troppo sottili | Deve restare leggibile a 48 px nel launcher e a 32 px come favicon |
| Colori con buon contrasto sul colore di sfondo dell'app | Sfondo e logo convivono in tutte le icone "piene" |

Lo stesso file si usa anche **dentro l'app** (es. splash/intro, schermata Info, PDF) con `Image.asset('assets/images/app_logo.png')`.

Serve anche il **colore di sfondo** dell'app (es. Shox `#F6EFE5`, lo stesso di `AppColors`/`surface` chiaro).

---

## 2. Cosa viene generato e a cosa serve

| File | Dimensione | Logo | Sfondo | Uso |
|---|---|---|---|---|
| `assets/images/app_icon_legacy.png` | 1024 | 84% | trasparente | Sorgente dell'icona "classica" (Android < 8) per `flutter_launcher_icons` |
| `assets/images/app_icon_foreground.png` | 1024 | 62% | trasparente | Sorgente del livello *foreground* dell'icona adattiva (Android 8+) |
| `images/icons/icon_512.png` | 512 | 70% | pieno | Play Store (icona 512×512), README, pagina dell'app sul portfolio |
| `images/icons/icon_192.png` | 192 | 70% | pieno | Web/portfolio (icona touch, manifest), anteprime piccole |
| `images/icons/oauth_logo_120.png` | 120 | 80% | pieno | Google Auth Platform → Branding (logo della schermata di consenso) |
| `images/icons/favicon_32.png` | 32 | 90% | trasparente | Favicon della pagina dell'app sul portfolio |

Perché queste percentuali:
- **Adattiva 62%**: Android ritaglia il foreground con maschere diverse (cerchio, squircle, goccia…) e lo sposta nelle animazioni; il logo deve stare nella *safe zone* centrale (66/108 del lato ≈ 61%).
- **Legacy 84%**: icona intera, senza maschera: può essere più grande.
- **Icone piene 70–80%**: un po' d'aria intorno al logo sullo sfondo colorato. Per Google e store **meglio sfondo pieno**: un PNG trasparente può sembrare "vuoto" su sfondo chiaro o scuro.

---

## 3. Lo script

Crea `tool/icons/generate_icons.ps1` (tracciato nel repo, come lo script delle anteprime):

```powershell
# Generates every app icon variant from a single square PNG logo.
#   powershell -ExecutionPolicy Bypass -File tool\icons\generate_icons.ps1
param(
    [string]$Logo = "assets\images\app_logo.png",   # square PNG, transparent background
    [string]$Background = "#F6EFE5",                # app background color
    [string]$OutDir = "assets\images",              # launcher icon sources
    [string]$ExtraDir = "images\icons"              # store / OAuth / web icons (not bundled)
)

Add-Type -AssemblyName System.Drawing

function New-Icon([int]$Size, [double]$Scale, [bool]$Filled, [string]$Path) {
    $src = [System.Drawing.Image]::FromFile((Resolve-Path $Logo))
    $bmp = New-Object System.Drawing.Bitmap $Size, $Size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    if ($Filled) {
        $g.Clear([System.Drawing.ColorTranslator]::FromHtml($Background))
    } else {
        $g.Clear([System.Drawing.Color]::Transparent)
    }
    $side = [int]($Size * $Scale)
    $offset = [int](($Size - $side) / 2)
    $g.DrawImage($src, $offset, $offset, $side, $side)
    $full = if ([System.IO.Path]::IsPathRooted($Path)) { $Path } else { Join-Path (Get-Location) $Path }
    New-Item -ItemType Directory -Force (Split-Path $full) | Out-Null
    $bmp.Save($full, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose(); $src.Dispose()
    Write-Host ("  {0,-40} {1}x{1}  logo {2:P0}  {3}" -f $Path, $Size, $Scale, ($(if ($Filled) { "filled" } else { "transparent" })))
}

Write-Host "Launcher sources ($OutDir):"
New-Icon 1024 0.84 $false "$OutDir\app_icon_legacy.png"
New-Icon 1024 0.62 $false "$OutDir\app_icon_foreground.png"

Write-Host "Other icons ($ExtraDir):"
New-Icon 512 0.70 $true "$ExtraDir\icon_512.png"
New-Icon 192 0.70 $true "$ExtraDir\icon_192.png"
New-Icon 120 0.80 $true "$ExtraDir\oauth_logo_120.png"
New-Icon 32  0.90 $false "$ExtraDir\favicon_32.png"
```

Eseguilo dalla radice del progetto:
```powershell
powershell -ExecutionPolicy Bypass -File tool\icons\generate_icons.ps1
# con un altro colore di sfondo:
powershell -ExecutionPolicy Bypass -File tool\icons\generate_icons.ps1 -Background "#1E1E2E"
```

Usa solo `System.Drawing` di Windows: nessun pacchetto o programma da installare. Con le impostazioni di Shox produce file identici a quelli usati nella 5.0.0.

---

## 4. Icone Android con `flutter_launcher_icons`

Pacchetto dev già usato in Shox (`flutter_launcher_icons: ^0.14.2` in `dev_dependencies`). Configurazione in `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  min_sdk_android: 21
  image_path: "assets/images/app_icon_legacy.png"
  adaptive_icon_background: "#F6EFE5"
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"
```

Poi:
```bash
dart run flutter_launcher_icons
```

Genera e aggiorna da solo:

| File generato | Contenuto |
|---|---|
| `android/app/src/main/res/mipmap-{mdpi…xxxhdpi}/launcher_icon.png` | Icona legacy in 5 densità (48 → 192 px) |
| `android/app/src/main/res/drawable-{mdpi…xxxhdpi}/ic_launcher_foreground.png` | Foreground adattivo in 5 densità |
| `android/app/src/main/res/mipmap-anydpi-v26/launcher_icon.xml` | Definizione dell'icona adattiva (background colore + foreground) |
| `android/app/src/main/res/values/colors.xml` | `ic_launcher_background` = colore di sfondo |
| `AndroidManifest.xml` | `android:icon="@mipmap/launcher_icon"` |

Note:
- `flutter_launcher_icons` aggiunge di default un margine interno del 16% al foreground (`adaptive_icon_foreground_inset: 16`, visibile come `android:inset="16%"` nell'XML). Con il foreground al 62% il logo risulta un po' piccolo ma sicuro su ogni launcher, come in Shox. Se lo vuoi più grande, aggiungi `adaptive_icon_foreground_inset: 0` e rigenera: il 62% dello script basta già a stare nella safe zone.
- **Icone a tema** (Android 13+, icone monocromatiche): facoltativo, aggiungi `adaptive_icon_monochrome: "assets/images/app_icon_monochrome.png"` (logo 62%, un solo colore, trasparente). Si ottiene dallo stesso script con un logo monocromatico.
- Se l'app ha anche **iOS**: `ios: true` e `remove_alpha_ios: true` (iOS non accetta trasparenza; usa l'icona legacy su sfondo pieno).

---

## 5. Dove finiscono gli altri file

| File | Dove caricarlo |
|---|---|
| `icon_512.png` | Play Console → Scheda dello store → Icona dell'app; README (opzionale); pagina `ndenicolais.github.io/<app>/` |
| `icon_192.png` | Portfolio: `<link rel="apple-touch-icon">` e icone del web manifest |
| `oauth_logo_120.png` | Google Cloud → Google Auth Platform → Branding → Logo dell'app |
| `favicon_32.png` | Portfolio: `<link rel="icon" type="image/png" href="…/favicon_32.png">` nella pagina dell'app |

`images/icons/` sta fuori da `assets/`, quindi non finisce nell'APK. Puoi committarla (pesa pochi KB e serve al portfolio) oppure aggiungerla al `.gitignore` se la usi solo per caricarla nelle console.

La splash di Android 12+ usa automaticamente l'icona del launcher: non serve generare altro. La splash/intro disegnata in Flutter usa `app_logo.png`.

---

## 6. Controlla

- Apri i file generati: logo centrato, niente tagli, bordi puliti.
- Installa l'APK (debug o release) e guarda l'icona nel launcher e nella schermata *App recenti*. Se il launcher lo permette, prova forme diverse (cerchio, squircle).
- Controlla sia con tema chiaro sia con tema scuro del telefono.
- Se hai cambiato solo il colore di sfondo, basta rilanciare `flutter_launcher_icons` (lo script non serve, i foreground sono trasparenti).

---

## 7. Commit

- File: `assets/images/app_logo.png`, `assets/images/app_icon_legacy.png`, `assets/images/app_icon_foreground.png`, `tool/icons/generate_icons.ps1`, `pubspec.yaml` (se hai cambiato la configurazione), tutto quello che `flutter_launcher_icons` ha cambiato in `android/app/src/main/res/` e `AndroidManifest.xml`, `images/icons/` (se lo tieni nel repo), `DOCUMENTATION.md`.
- Messaggio: `Updated the app logo and regenerated launcher icons`
- Se il logo è una novità visibile, aggiungi un bullet al changelog della versione ("Nuova icona dell'app").

---

## Checklist

- [ ] `app_logo.png` quadrato, trasparente, 1024×1024, logo che riempie il canvas
- [ ] Colore di sfondo scelto (lo stesso dell'app)
- [ ] Script eseguito, file controllati a occhio
- [ ] `flutter_launcher_icons` configurato ed eseguito
- [ ] Icona verificata sul telefono (launcher, recenti, tema chiaro/scuro)
- [ ] `icon_512`, `oauth_logo_120`, `favicon_32` caricati dove servono (store, Google, portfolio)
- [ ] Documentazione aggiornata e commit proposto
