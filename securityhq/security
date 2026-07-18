{ pkgs, ... }:

{
  # Pure Network Protection Only
  networking.firewall.enable = true;

  # Core Hardening
  security.protectKernelImage = true;
  systemd.coredump.enable = false;

  # Fail2ban Intrusion Defense
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "10m";
  };

  # Real-Time Desktop Alert Daemon
  systemd.services."desktop-alert@" = {
    description = "Pushes background service errors to your display layer";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.libnotify}/bin/notify-send 'System Alert' 'Background service [%i] has crashed!' --urgency=critical";
    };
  };
}
  # =====================================================================
  # --- WIREGUARD VPN PIPELINE RUNTIME ---
  # =====================================================================
  networking.wireguard.interfaces = {
    # This creates a native network interface named "thevoid"
    thevoid = {
      ips = [ "10.55.0.1/16" ]; # Your local IP inside your WireGuard mesh
      listenPort = 51820;

      # Path to your decrypted physical key file on this drive
      privateKeyFile = "/etc/wireguard/private_key";

      # Define the remote servers/nodes you want to bridge into
      peers = [
        {
          # Example VPS Node
          publicKey = "PASTE_THE_REMOTE_VPS_PUBLIC_KEY_HERE";
          allowedIPs = [ "10.55.0.0/16" ]; # Route all network mesh traffic
          endpoint = "123.45.67.89:51820";  # Public IP and port of your server
          persistentKeepalive = 25;        # Keeps connection alive through firewalls
        }
      ];
    };
  };
