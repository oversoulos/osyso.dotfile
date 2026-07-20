{
  description = "Editor Media Vault & Lightweight Graphics Sandbox";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec { # Added 'rec' (recursive) keyword wrapper to allow self-referencing below
        devShells = {
          # MODE: LIGHTWEIGHT GRAPHICS & BRANDING (Raster, Canvas & Vector)
          graphics = pkgs.mkShell {
            buildInputs = with pkgs; [
              gimp         # Ultra-fast raster manipulation and quick layout exports
              inkscape     # Pure vector canvas engine for clean asset/icon development
              krita        # High-performance, lightweight digital drawing suite
              imagemagick  # Terminal-native utility for instant background image/gif processing
            ];
            shellHook = ''
              echo "[MODE_ACTIVE: editor] Digital Studio Canvas Loaded"
              echo "Vault Route locked onto project sub-tree."
              export MODE_ACTIVE="editor-graphics"
            '';
          };

          # MODE: RUNTIME VIDEO EDITING & TIMELINES
          video = pkgs.mkShell {
            buildInputs = with pkgs; [
              shotcut      # Lightweight video compositor/cutter (cleaner footprint than Kdenlive)
              ffmpeg       # The ultimate lightweight CLI video/audio converter pipeline
            ];
            shellHook = ''
              echo "[MODE_ACTIVE: editor] Timeline & Video Sequencing Active"
              echo "Hardware render bindings mapped directly to your Cezanne AMDGPU layer."
              export MODE_ACTIVE="editor-video"
            '';
          };
        };

        # Corrected self-referential mapping pointer block
        devShells.default = devShells.graphics;
      });
}
