{ config, pkgs, inputs, ... }:

{
  # THE IMPORT LAYER
imports = [ 
    ./hardware_configuration.nix 
    ./packages.nix                 
    ./modules/securityhq/security.nix                 
  ];
        

  # 1. BOOT & LUKS STORAGE
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" "exfat" "ext4" "vfat" ];
  boot.initrd.luks.devices."root" = {
    device = "/dev/disk/by-uuid/203d80db-232d-4eb2-988f-5f89052c99ee
"; 
    preLVM = true;
  };

  # 2. HARDWARE PIPELINE
  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # 3. CORE SYSTEM NETWORKING & REPLICA LOCALES
  networking.hostName = "osyso";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # 4. SOUND PLUMBING
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # 5. INTEGRATED SERVICES & SANDBOX RUNTIMES
  services.gvfs.enable = true; 
  services.udisks2.enable = true;
  services.flatpak.enable = true;
  services.displayManager.ly.enable = true; 

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Speeds up loading using cached builds
  };

  # Rootless Podman Container Infrastructure
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # 6. AUTHENTICATED USER PERMISSIONS
  users.users.milk = {  
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "podman" ];
    initialPassword = "4713"; 
  };

  # 7. WINDOW MANAGER (HYPRLAND & PLUGINS)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    plugins = [
      inputs.hyprglass.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.hyprlandPlugins.hyprexpo
    ];
  };

  # 8. ENVIRONMENT PACKAGES
  environment.systemPackages = with pkgs; [
    # Terminal Options (Choose or install both)
    ghostty
    kitty            
    
    # UI/Desktop Utilities
    waybar           
    rofi-wayland     
    swww             
    mako             
    networkmanagerapplet 
    pyprland

    # AI Compute & Vulkan Diagnostics
    koboldcpp         
    vulkan-tools      
    clinfo            
  ];
  
  # 9. BACKGROUND AUTOMATION ENGINE & NIX SETTINGS
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ]; 
      auto-optimise-store = true; 
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false; 
    dates = "04:00";
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11"; 
}
