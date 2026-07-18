{
  description = "Hyprland Master Blueprint Flake";

{
  description = "Hyprland Master Blueprint Flake";

  inputs = {
    # Channel Lock
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Core Window Manager Link
    hyprland.url = "github:hyprwm/Hyprland";

    # Hyprglass Input
    hyprglass = {
      url = "github:hyprnux/hyprglass";
      inputs.hyprland.follows = "hyprland";
    };
  };

  # Fixed: Cleaned inputs tracking loop
  outputs = { self, nixpkgs, hyprland, hyprglass, ... }@inputs: {
    nixosConfigurations = {
      osyso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
