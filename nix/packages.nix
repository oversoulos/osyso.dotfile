# Save this at: ~/dotfiles/nixos/packages.nix
{ pkgs, ... }:
let
  # This safely opens up a clean portal to read the unstable channel
  unstable = import (builtins.fetchTarball "channel:nixos-unstable") { 
    config.allowUnfree = true; 
  };
in
{
  environment.systemPackages = with pkgs; [
    # Core User GUI Apps
    brave discord spotify telegram nemo okular xarchiver
    unstable.ghostty unstable.obsidian valent

    # Your Creative Production Suite (Zero Overlap)
    gimp inkscape krita peasce shotcut

    # System Visibility, Searching & Scripting Core
    micro git git-lfs direnv jq yq ripgrep fd fzf bat eza zellij
    httpie age sops gnupg btop ncdu pciutils usbutils 
    ping dnsutils

    # Standalone Wayland Elements & Desktop Helpers
    rofi-wayland waybar hyprpaper wl-clipboard
    blueman networkmanagerapplet
  ];
}

