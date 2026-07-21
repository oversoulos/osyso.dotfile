# Do not modify this file! It was generated based on your system hardware
# profile and intended for a standard NixOS installation.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Kernel Modules & Boot Configurations
  boot.initrd.availableKernelModules = [
    "nvme"       # For your PELADN 476GB NVMe drive
    "xhci_pci"   # For USB 3.0 ports
    "ahci"       # For standard SATA controller interfaces
    "usbhid"     # For your C-Media Audio Adapter & peripherals
    "usb_storage"
    "sd_mod"     # For SCSI/SATA disk support
  ];
  boot.initrd.kernelModules = [ "amdgpu" ]; # Early KMS loading for smooth AMD graphics boot
  boot.kernelModules = [ "kvm-amd" ];        # Hardware virtualization for AMD Zen 3
  boot.kernelParams = [ "amdgpu.sg_display=0" ];
  boot.extraModulePackages = [ ];

  # 1. Mount the main root directory subvolume
  fileSystems."/" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };

  # 2. Mount your clean user files subvolume
  fileSystems."/home" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" ];
    };

  # 3. Mount your dedicated Nix store package cache subvolume
  fileSystems."/nix" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };

  # 4. Mount your physical unencrypted UEFI Boot partition
  fileSystems."/boot" =
    { device = "/dev/nvme0n1p1";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  # 5. Connect your active swap space partition
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

  # Network Interface Configurations (Realtek Ethernet & Wi-Fi)
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp2s0.useDHCP = lib.mkDefault true; # Active 1GbE Ethernet
  networking.interfaces.eno1.useDHCP = lib.mkDefault true;   # 2.5GbE Ethernet
  networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true; # RTL8852BE Wi-Fi

  # Firmware Updates & Platform Configurations
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Bluetooth Configuration (Realtek Bluetooth Radio via USB)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
