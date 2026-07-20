{ pkgs, ... }:

{
  # Allow unfree licensing for specific system applications
  nixpkgs.config.allowUnfree = true;

  # =====================================================================
  # --- GLOBAL APPS MATRIX (Available Everywhere) ---
  # =====================================================================
  environment.systemPackages = with pkgs; [
    # Core Shell & Multiplexer Infrastructure
    ghostty               # Native Wayland terminal emulator (Your main choice)
    kitty                 # Fail-safe secondary backup terminal
    tmux                  # Decoupled control deck manager (Phone sync engine)
    starship              # Cross-shell prompt enhancement engine

    # Visual Core Desktop Utilities
    waybar                # Highly customizable status line bar for Hyprland
    rofi-wayland          # App launcher, command bar, and fallback search engine
    swww                  # Smooth GPU-accelerated wallpaper management engine
    mako                  # Minimalist Wayland notification daemon daemon
    networkmanagerapplet  # System tray interactive configuration icon for Wi-Fi
    nemo                  # Light, graphical layout tree file manager
    libnotify             # Core backend mapping for security alerts

    # System Status, Monitoring & DevOps Utils
    btop                  # High-performance hardware visual state monitor
    nvtopPackages.amd     # Real-time AMD compute monitor for local GGUF scaling
    vulkan-tools          # Diagnostic layers for computing verification (vkcube/vulkaninfo)
    clinfo                # OpenCL runtime platform mapping verifier
    git                   # Source control tracking engine
    curl                  # Command line network payload delivery tool
    xdg-utils             # Native cross-workspace path browser management layer

    # Embedded Heavy System Docks
    obs-studio            # Low-level pipewire system media capture suite
  ];

  # =====================================================================
  # --- TYPOGRAPHY ENGINE (System Fonts Matrix) ---
  # =====================================================================
  fonts.packages = with pkgs; [
    # Nerd Font suite required to render glyphs and symbols across tools
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.sauce-code-pro
  ];
}
