{
  description = "osyso Master System Orchestration Flake";

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

    # Non-flake Hyprland plugins (plain Makefile/CMake source, built via overlay below)
    hypr-hotedge = {
      url = "github:claychinasky/hypr-hot-edge";
      flake = false;
    };

    hyprglass = {
      url = "github:hyprnux/hyprglass";
      flake = false;
    };

    # Future non-flake plugins follow the same shape:
    # hypr-scratchpad = {
    #   url = "github:someuser/somerepo";
    #   flake = false;
    # };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, hyprland, hypr-hotedge, hyprglass, ... }@inputs: {
    nixosConfigurations.osyso = nixpkgs.lib.nixosSystem {
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
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.milk = import ./home/milk.nix;

          # THE INLINE COMPILATION DRIVER
          # Builds any plain-source (non-flake) Hyprland plugin against your
          # exact running Hyprland package. Add new plugins by adding an input
          # above with flake = false, then one buildHyprPlugin call below.
          nixpkgs.overlays = [
            (final: prev:
              let
                hyprlandPkg = inputs.hyprland.packages.${final.system}.hyprland;

                buildHyprPlugin = { pname, src, extraBuildInputs ? [ ] }:
                  final.stdenv.mkDerivation {
                    inherit pname src;
                    version = "git";
                    nativeBuildInputs = [ final.cmake final.pkg-config ];
                    buildInputs = [ hyprlandPkg ] ++ extraBuildInputs;
                    installPhase = ''
                      mkdir -p $out/lib
                      cp *.so $out/lib/ 2>/dev/null || cp build/*.so $out/lib/
                    '';
                  };
              in
              {
                hypr-hot-edge-built = buildHyprPlugin {
                  pname = "hypr-hot-edge";
                  src = inputs.hypr-hotedge;
                };
                hyprglass-built = buildHyprPlugin {
                  pname = "hyprglass";
                  src = inputs.hyprglass;
                };
                # Future plugin, one line each:
                # hypr-scratchpad-built = buildHyprPlugin {
                #   pname = "hypr-scratchpad";
                #   src = inputs.hypr-scratchpad;
                # };
              })
          ];
        }
      ];
    };
  };
}
