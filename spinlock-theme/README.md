# spinlock-theme

Theme de Windows "Spinlock NMR":

- Fondos: `spinlock-bloch`, `spinlock-desfasaje` y `spinlock-espectro` en slideshow (30 min, aleatorio), modo Fit sobre negro.
- Screensaver: `SpinlockNMR.scr`.
- Modo oscuro y acento cian del logo.

## Para compartir

`build.ps1` arma `dist\SpinlockNMR-theme.zip` (~900 KB), que se instala en cualquier PC sin los repos:
descomprimir y doble click en `instalar.cmd` (sin admin). Ver `LEER.txt`, que va adentro del zip.

```powershell
.\build.ps1                                   # usa ~\dotfiles-macos
.\build.ps1 -Install                          # además lo instala en esta PC
.\build.ps1 -DotfilesMacos D:\repos\dotfiles-macos -SlideshowMinutes 60
```

Los fondos y el `.scr` salen de [dotfiles-macos](https://github.com/blusa/dotfiles-macos)
(`wallpapers/` y `omarchy/spinlock-scr/`), así que para armar el zip ese repo tiene que estar clonado.

## Por qué zip y no solo un .deskthemepack

- Un `.deskthemepack` (CAB con el `.theme` y los fondos) no puede llevar el `.scr`: Windows lo descarta al extraerlo.
- Windows 11 ignora la sección `[boot] SCRNSAVE.EXE` de los `.theme`, así que el screensaver
  lo configura `instalar.cmd` en `HKCU\Control Panel\Desktop`.
- Con Configuración abierta el theme no se aplica: `instalar.cmd` la cierra antes.
