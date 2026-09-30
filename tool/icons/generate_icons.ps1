# Generates every app icon variant from a single square PNG logo.
#   powershell -ExecutionPolicy Bypass -File tool\icons\generate_icons.ps1
# Then run `dart run flutter_launcher_icons` to produce the Android icons.
# See ICON_GENERATION_GUIDE.md for sizes, percentages and where each file goes.
param(
    [string]$Logo = "assets\images\app_logo.png",   # square PNG, transparent background
    [string]$Background = "#FFFFFF",                # icon background (navy logo on white)
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
