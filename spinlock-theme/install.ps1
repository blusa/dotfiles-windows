# Instala el theme "Spinlock NMR": slideshow con los fondos de Spinlock y el screensaver
# SpinlockNMR.scr. Los archivos salen de dotfiles-macos (wallpapers/ y omarchy/spinlock-scr/).
#
#   .\install.ps1                         # usa ~\dotfiles-macos y aplica el theme
#   .\install.ps1 -DotfilesMacos D:\repos\dotfiles-macos -NoApply
param(
    [string]$DotfilesMacos = "$HOME\dotfiles-macos",
    [int]$SlideshowMinutes = 30,
    [switch]$NoApply
)
$ErrorActionPreference = 'Stop'

if (-not (Test-Path "$DotfilesMacos\wallpapers")) {
    throw "No encuentro $DotfilesMacos\wallpapers. Cloná https://github.com/blusa/dotfiles-macos o pasá -DotfilesMacos."
}

$base = "$env:LOCALAPPDATA\SpinlockNMR"
$wp = "$base\wallpapers"
New-Item -ItemType Directory -Force $wp | Out-Null

# Los tres de Spinlock (elliot-black queda afuera)
foreach ($n in 'bloch', 'desfasaje', 'espectro') {
    Copy-Item "$DotfilesMacos\wallpapers\spinlock-$n.png" $wp -Force
}
$scr = "$DotfilesMacos\omarchy\spinlock-scr\SpinlockNMR.scr"
if (-not (Test-Path "$base\SpinlockNMR.scr") -or
    (Get-FileHash $scr).Hash -ne (Get-FileHash "$base\SpinlockNMR.scr").Hash) {
    # Si está corriendo (p. ej. la vista previa del panel) el archivo está bloqueado
    Get-Process SpinlockNMR.scr -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Milliseconds 300
    Copy-Item $scr "$base\SpinlockNMR.scr" -Force
}

# WallpaperStyle=6 (Fit) con fondo negro: los PNG son 16:10 y con Fill se recorta el logo en
# monitores anchos; como el fondo de las imágenes es negro, las franjas no se notan.
# El acento es el cian del logo (86, 180, 203).
$theme = @"
; Theme Spinlock NMR, generado por dotfiles-windows/spinlock-theme/install.ps1
[Theme]
DisplayName=Spinlock NMR
ThemeId={7B3C1E52-5A1D-4E0B-9C6E-53504C4B4E4D}

[Control Panel\Desktop]
Wallpaper=$wp\spinlock-espectro.png
TileWallpaper=0
WallpaperStyle=6
Pattern=

[Control Panel\Colors]
Background=0 0 0

[Slideshow]
Interval=$($SlideshowMinutes * 60000)
Shuffle=1
ImagesRootPath=$wp

[VisualStyles]
Path=%SystemRoot%\resources\themes\Aero\Aero.msstyles
ColorStyle=NormalColor
Size=NormalSize
AutoColorization=0
ColorizationColor=0XC456B4CB
SystemMode=Dark
AppMode=Dark

[boot]
SCRNSAVE.EXE=$base\SpinlockNMR.scr

[MasterThemeSelector]
MTSM=RJSPBS
"@
$themeFile = "$env:LOCALAPPDATA\Microsoft\Windows\Themes\SpinlockNMR.theme"
New-Item -ItemType Directory -Force (Split-Path $themeFile) | Out-Null
[IO.File]::WriteAllText($themeFile, $theme, [Text.Encoding]::Unicode)
Write-Host "→ $themeFile"

if (-not $NoApply) {
    # Abrir el .theme lo aplica (y abre Configuración → Temas)
    Start-Process $themeFile
}
