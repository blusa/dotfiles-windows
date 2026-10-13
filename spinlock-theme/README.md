# spinlock-theme

Theme de Windows "Spinlock NMR":

- Fondos: `spinlock-bloch`, `spinlock-desfasaje` y `spinlock-espectro` en slideshow (30 min, aleatorio), modo Fit sobre negro.
- Screensaver: `SpinlockNMR.scr`.
- Modo oscuro y acento cian del logo.

Los fondos y el `.scr` vienen de [dotfiles-macos](https://github.com/blusa/dotfiles-macos)
(`wallpapers/` y `omarchy/spinlock-scr/`), así que ese repo tiene que estar clonado.

```powershell
.\install.ps1                                   # usa ~\dotfiles-macos y aplica el theme
.\install.ps1 -DotfilesMacos D:\repos\dotfiles-macos -SlideshowMinutes 60
.\install.ps1 -NoApply                          # solo genera el .theme
```

Instala en `%LOCALAPPDATA%\SpinlockNMR\` y deja el theme en
`%LOCALAPPDATA%\Microsoft\Windows\Themes\SpinlockNMR.theme` (aparece en Configuración → Personalización → Temas).
