{
  # Core System Command Shortcuts
  ll = "ls -lah";
  gs = "git status";
  gc = "git commit";
  nv = "nvim";
  
  # Diagnostic & Automation Maintenance Scripts
  health-check = "$HOME/scripts/health-check.sh";
  clean-up     = "$HOME/scripts/clean-up.sh";
  debug-tools  = "$HOME/scripts/debug-tools.sh";
  mode         = "mode-switch";
  nexus        = "xdg-open $HOME/oversoul/dashboard.html";
  sys-clean    = "nix-env --delete-generations old && nix-store --gc";

  # Quick-draw environment creation hotkeys
  set-node     = "echo 'use flake .#node' > .envrc && direnv allow";
  set-ml       = "echo 'use flake .#ml' > .envrc && direnv allow";
  set-web      = "echo 'use flake .#web' > .envrc && direnv allow";
  
  # Fast sandbox security clearance
  allow        = "direnv allow";
  deny         = "direnv deny";

  # Media Vault Graphic Studio Quick-Draw Hotkeys
  set-graphics = "echo 'use flake .#graphics' > .envrc && direnv allow";
  set-video    = "echo 'use flake .#video' > .envrc && direnv allow";

  # Quick network control panel shortcuts
  vpn-up       = "sudo systemctl start wireguard-thevoid.service";
  vpn-down     = "sudo systemctl stop wireguard-thevoid.service";
  vpn-stat     = "sudo wg show"; 

  # Kitty Custom Dynamic Scaling Shortcut Triggers (Updated from Ghostty)
  zoom-on      = "kitty @ set-font-size 26";
  zoom-off     = "kitty @ set-font-size 12";
}
