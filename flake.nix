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

    # FORCE ALL PLUGINS TO CORRELATE DEPENDENCIES NATIVELY
    hyprglass = {
      url = "github:hyprnux/hyprglass";
      inputs.hyprland.follows = "hyprland";
    };
    
    hypr-hotedge = {
      url = "github:claychinasky/hypr-hot-edge"; # Updated to your target repo path
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, hyprland, hypr-hotedge, ... }@inputs: {
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
          home-manager.users.milk = import ./home/milk.nix;

          # THE INLINE COMPILATION DRIVER
          # This forces Nix to cleanly compile claychinasky/hypr-hot-edge directly
          # from source using the matching headers from your running Hyprland package.
          nixpkgs.overlays = [
            (final: prev: {
              hypr-hot-edge-built = final.stdenv.mkDerivation {
                pname = "hypr-hot-edge";
                version = "git";
                src = hypr-hotedge; # Correctly tracks matching input argument

                nativeBuildInputs = [ final.cmake final.pkg-config ];
                buildInputs = [ inputs.hyprland.packages.${final.system}.hyprland ];

                # Standard CMake parameters to output the shared object binary file safely
                cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

                installPhase = ''
                  mkdir -p $out/lib
                  cp *.so $out/lib/ 2>/dev/null || cp build/*.so $out/lib/
                '';
              };
            })
          ];
        }
      ];
    };
  };
}
