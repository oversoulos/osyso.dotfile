{
  description = "osyso";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05"; 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Injected Core Hyprland Engine & Plugins Matrix
    hyprland.url = "github:hyprwm/Hyprland";
    hyprglass = {
      url = "github:hyprnux/hyprglass";
      inputs.hyprland.follows = "hyprland";
    };
  };

  # Fixed: Removed the syntax breaking '...' shorthand from this outputs line
  outputs = { self, nixpkgs, home-manager, nixos-hardware, hyprland, hyprglass, ... }@inputs: {
    nixosConfigurations.osyso = nixpkgs.lib.nixosSystem { # Anchored to your custom machine name
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-gpu-amd
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.milk = import ./home/milk.nix;
        }
      ];
    };
  };
}

