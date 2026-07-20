{
  description = "osyso Master System Orchestration Flake";

  inputs = {
    inputs = {
    # Core Base OS Layers
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Master Hyprland Engine Wrapper
    hyprland.url = "github:hyprwm/Hyprland";

    # 🟢 FORCE ALL PLUGINS TO CORRELATE DEPENDENCIES NATIVELY
    hyprglass = {
      url = "github:hyprnux/hyprglass";
      inputs.hyprland.follows = "hyprland"; # Locks dependencies together
    };
    
    hypr-hotedge = {
      url = "github:anywheretw/hypr-hotedge"; # Your slide-out edge tracker repo
      inputs.hyprland.follows = "hyprland"; # Prevents header compilation drift
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

