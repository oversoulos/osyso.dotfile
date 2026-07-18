{ config, pkgs, inputs, ... }:

{
  # THE IMPORT LAYER: This merges all your specialized sub-lists seamlessly
  imports = [ 
    ./hardware-configuration.nix 
    ./packages.nix                 # <-- Pulls in your entire app inventory
    ./security.nix                 # <-- Pulls in your firewall and crash shields
  ];

  # 1. BOOT & LUKS STORAGE
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" "exfat" "ext4" "vfat" ];
  
  boot.initrd.luks.devices."root" = {
    device = "/dev/disk/by-uuid/nvme0n1p3"; # Maps to your target disk layout partition 
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

  # Rootless Podman Container Infrastructure
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # 6. AUTHENTICATED USER PERMISSIONS
  users.users.myusername = {  
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "podman" ];
    initialPassword = "password"; 
  };

  # 7. DISPLAY PORTAL & PLUGINS MATRIX
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    
    plugins = [
      inputs.hyprglass.packages.${pkgs.stdenv.hostPlatform.system}.default
      # Note: hypr-hot-edge removed from here to clean up compilation loops
      pkgs.hyprlandPlugins.hyprexpo
      pkgs.pyprland
    ];
  };

  # 8. BACKGROUND AUTOMATION ENGINE
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ]; # Fixed the closed bracket typo here!
    settings.auto-optimise-store = true; 
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
