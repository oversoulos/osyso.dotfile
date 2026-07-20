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
    # Changed to target the raw partition path to prevent swap collision crashes
    device = "/dev/nvme0n1p3"; 
    preLVM = true;
  };
  # 2. HARDWARE PIPELINE & ENVIRONMENT OVERRIDES
  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Environment Overrides for Wayland and Vulkan Local AI Compute layers
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Forces electron apps to use native Wayland
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json"; # Maps your AMD Vulkan driver
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

  # 7. WINDOW MANAGER (HYPRLAND & PLUGINS INJECTION)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    
    # This automatically draws your precompiled plug outputs right into runtime memory!
    plugins = [
      inputs.hyprglass.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.hyprlandPlugins.hyprexpo
      pkgs.hypr-hot-edge-built # <-- Hooks the overlay compilation directly into Hyprland launch
    ];
  };

  # 8. ENVIRONMENT SYSTEM ADJUSTMENTS
  # Note: Global packages are managed cleanly inside your imported packages.nix file.
  environment.systemPackages = with pkgs; [
    # Added koboldcpp here since it isn't in your main packages inventory
    koboldcpp
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
