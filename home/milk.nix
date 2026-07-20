{ config, pkgs, ... }:

{
  # Ensure this matches the home directory path of your system user account
  home.username = "milk";
  home.homeDirectory = "/home/milk";

  # Standard user environment packages
  home.packages = with pkgs; [
    git
    curl
  ];

  # Force Zsh environment tracking rules to automatically map your custom aliases file
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # Points cleanly to the aliases module in your repository root
    shellAliases = import ../aliases.nix; 
  };

  # Lets Home Manager manage your shell environment configuration settings
  programs.home-manager.enable = true;

  # Match this version directly to the core OS channel release tag (24.11)
  home.stateVersion = "24.11";
}
