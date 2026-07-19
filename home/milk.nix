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

  # Lets Home Manager manage your shell environment configuration settings
  programs.home-manager.enable = true;

  # Match this version directly to the core OS channel release tag (24.11)
  home.stateVersion = "24.11"; 
}
