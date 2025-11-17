local wezterm = require 'wezterm'

return {
  wsl_domains = {
    { name = 'WSL:Debian', distribution = 'Debian' },
  },
  default_domain = 'WSL:Debian',
  color_scheme = "Catppuccin Mocha",
}
