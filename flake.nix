{
  description = "osyso Master System Orchestration Flake";

  inputs = {
    # Core Base OS Stable Channel Layer
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # User Profile Configuration Layer (Aligned to match the core OS channel)
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware Tuning Matrix (For your AMD Cezanne/Zen 3 architecture optimization)
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Injected Core Hyprland Engine & Plugins Matrix
    hyprland.url = "github:hyprwm/Hyprland";
    hyprglass = {
      url = "github:hyprnux/hyprglass";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, hyprland, hyprglass, ... }@inputs: {
    nixosConfigurations.osyso = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # This hands off inputs (like hyprglass) to your configuration files cleanly
      specialArgs = { inherit inputs; };
      
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-gpu-amd
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          # Match this user parameter ("milk" or "myusername") directly to configuration.nix
          home-manager.users.milk = import ./home/milk.nix;
        }
      ];
    };
  };
}

