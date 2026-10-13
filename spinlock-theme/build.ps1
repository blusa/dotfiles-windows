# Arma dist\SpinlockNMR-theme.zip para compartir el theme "Spinlock NMR" sin los repos:
#   SpinlockNMR.deskthemepack  fondos (slideshow) + colores
#   SpinlockNMR.scr            screensaver (los .deskthemepack no pueden llevar un .scr)
#   instalar.cmd, LEER.txt
# Los fondos y el .scr salen de dotfiles-macos (wallpapers/ y omarchy/spinlock-scr/).
#
#   .\build.ps1                    # usa ~\dotfiles-macos
#   .\build.ps1 -Install           # además lo instala en esta PC
#   .\build.ps1 -DotfilesMacos D:\repos\dotfiles-macos -SlideshowMinutes 60
param(
    [string]$DotfilesMacos = "$HOME\dotfiles-macos",
    [int]$SlideshowMinutes = 30,
    [switch]$Install
)
$ErrorActionPreference = 'Stop'

if (-not (Test-Path "$DotfilesMacos\wallpapers")) {
    throw "No encuentro $DotfilesMacos\wallpapers. Cloná https://github.com/blusa/dotfiles-macos o pasá -DotfilesMacos."
}

$dist = "$PSScriptRoot\dist"
$stage = "$dist\SpinlockNMR-theme"
$pack = "$env:TEMP\spinlock-themepack"
Remove-Item $stage, $pack -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $stage, "$pack\DesktopBackground" | Out-Null

# Los tres de Spinlock (elliot-black queda afuera)
$wallpapers = 'bloch', 'desfasaje', 'espectro' | ForEach-Object { "spinlock-$_.png" }
foreach ($w in $wallpapers) { Copy-Item "$DotfilesMacos\wallpapers\$w" "$pack\DesktopBackground\" }

# Rutas relativas al pack: Windows lo extrae en %LOCALAPPDATA%\Microsoft\Windows\Themes\SpinlockNMR.
# WallpaperStyle=6 (Fit) con fondo negro: los PNG son 16:10 y con Fill se recorta el logo en
# monitores anchos; como el fondo de las imágenes es negro, las franjas no se notan.
# El acento es el cian del logo (86, 180, 203). Sin [boot]: Windows 11 ignora el screensaver
# de los themes, lo configura instalar.cmd.
$theme = @"
[Theme]
DisplayName=Spinlock NMR
ThemeId={7B3C1E52-5A1D-4E0B-9C6E-53504C4B4E4D}

[Control Panel\Desktop]
Wallpaper=DesktopBackground\spinlock-espectro.png
TileWallpaper=0
WallpaperStyle=6
Pattern=

[Control Panel\Colors]
Background=0 0 0

[Slideshow]
Interval=$($SlideshowMinutes * 60000)
Shuffle=1
ImagesRootPath=DesktopBackground

[VisualStyles]
Path=%SystemRoot%\resources\themes\Aero\Aero.msstyles
ColorStyle=NormalColor
Size=NormalSize
AutoColorization=0
ColorizationColor=0XC456B4CB
SystemMode=Dark
AppMode=Dark

[MasterThemeSelector]
MTSM=RJSPBS
"@
[IO.File]::WriteAllText("$pack\SpinlockNMR.theme", $theme, [Text.Encoding]::Unicode)

# Un .deskthemepack es un CAB con el .theme en la raíz y los fondos en DesktopBackground\
$ddf = @(
    '.Set CabinetNameTemplate=SpinlockNMR.deskthemepack'
    ".Set DiskDirectoryTemplate=$stage"
    '.Set CompressionType=LZX'
    '.Set MaxDiskSize=0'
    '.Set RptFileName=nul'
    '.Set InfFileName=nul'
    "`"$pack\SpinlockNMR.theme`" SpinlockNMR.theme"
    '.Set DestinationDir=DesktopBackground'
) + ($wallpapers | ForEach-Object { "`"$pack\DesktopBackground\$_`" $_" })
[IO.File]::WriteAllLines("$pack\pack.ddf", $ddf)
makecab /F "$pack\pack.ddf" | Out-Null
if ($LASTEXITCODE) { throw "makecab falló ($LASTEXITCODE)" }

Copy-Item "$DotfilesMacos\omarchy\spinlock-scr\SpinlockNMR.scr" $stage
# cmd.exe necesita CRLF (con LF los goto/labels fallan)
$cmd = (Get-Content -Raw "$PSScriptRoot\instalar.cmd") -replace "`r?`n", "`r`n"
[IO.File]::WriteAllText("$stage\instalar.cmd", $cmd, [Text.Encoding]::ASCII)
$leer = (Get-Content -Raw "$PSScriptRoot\LEER.txt") -replace "`r?`n", "`r`n"
[IO.File]::WriteAllText("$stage\LEER.txt", $leer, [Text.UTF8Encoding]::new($true))

$zip = "$dist\SpinlockNMR-theme.zip"
Compress-Archive -Path "$stage\*" -DestinationPath $zip -Force
Remove-Item $pack -Recurse -Force
Write-Host "→ $zip ($([int]((Get-Item $zip).Length / 1KB)) KB)"

if ($Install) {
    & cmd.exe /c "`"$stage\instalar.cmd`""
}
