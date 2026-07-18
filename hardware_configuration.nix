# Do not modify this file!  It was generated based on your system hardware
# profile and intended for a standard NixOS installation.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Kernel Modules & Boot Configurations
  boot.initrd.availableKernelModules = [ 
    "nvme"      # For your PELADN 476GB NVMe drive
    "xhci_pci"  # For USB 3.0 ports
    "ahci"      # For standard SATA controller interfaces
    "usbhid"    # For your C-Media Audio Adapter & peripherals
    "usb_storage" 
    "sd_mod"    # For SCSI/SATA disk support
  ];
  boot.initrd.kernelModules = [ "amdgpu" ]; # Early KMS loading for smooth AMD graphics boot
  boot.kernelModules = [ "kvm-amd" ];        # Hardware virtualization for AMD Zen 3
  boot.kernelParams = [ "amdgpu.sg_display=0" ]; 
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  boot.extraModulePackages = [ ];


  fileSystems."/" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ]; # Enables space-saving for AI models
    };

  fileSystems."/home" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" ];
    };

   fileSystems."/boot" =
    { device = "/dev/nvme0n1p1"; 
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  # Map your physical swap partition directly using its raw path
  swapDevices = [
    { device = "/dev/nvme0n1p2"; }
  ];

  # Hardware Acceleration & GPU Configurations (AMD Cezanne Vega Graphics)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk          
      rocmPackages.clr
    ];
  };

  environment.variables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";
  };

  # Network Interface Configurations (Realtek Ethernet & Wi-Fi)
  # Enables DHCP on your active network interfaces
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp2s0.useDHCP = lib.mkDefault true; # Active 1GbE Ethernet
  networking.interfaces.eno1.useDHCP = lib.mkDefault true;   # 2.5GbE Ethernet
  networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true; # RTL8852BE Wi-Fi

  # Firmware Updates & Platform Configurations
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Bluetooth Configuration (Realtek Bluetooth Radio via USB)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnOnBoot = true;
}
