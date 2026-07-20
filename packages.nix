{ pkgs, ... }:

{
  # Allow unfree licensing for specific system applications
  nixpkgs.config.allowUnfree = true;

  # =====================================================================
  # --- GLOBAL APPS MATRIX (Available Everywhere) ---
  # =====================================================================
  environment.systemPackages = with pkgs; [
    # Core Shell & Terminal Infrastructure
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

    # Web, Social, and Media Autostart Apps
    brave                 # Privacy-first browser running on Workspace 1
    discord               # Communication hub running on Workspace 2
    spotify               # Streaming client running on Workspace 3
    
    # Casual & Media Vault Tools
    obsidian              # Modern note management engine
    vlc                   # Robust backup video encoder layer
    mpv                   # Light, blazing-fast Wayland native video layout player
    valent                # Desktop GUI implementation wrapper for phone sync
  ];

  # =====================================================================
  # --- TYPOGRAPHY ENGINE (System Fonts Matrix) ---
  # =====================================================================
  fonts.packages = with pkgs; [
    # Nerd Font suite required to render glyphs and symbols across tools
    nerd-fonts.jetbrains-mono
  ]; # <-- Cleanly closes your font package tracking array!

  # =====================================================================
  # --- DEVICE SYNCING PIPELINE (KDE Connect Protocol) ---
  # =====================================================================
  # Opens up the specific UDP/TCP ports needed for your phone to talk to osyso over Wi-Fi
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent; # Uses the sleeker, lighter GTK client instead of full KDE bloat
  };
} # <-- Securely closes your master configuration wrapper!
