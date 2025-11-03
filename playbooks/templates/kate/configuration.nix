{ config, pkgs, ... }:
let
  customPlex = pkgs.plex.override {
    plexRaw = pkgs.plexRaw.overrideAttrs(old: rec {
      src = pkgs.fetchurl {
        # manually set plex version to upgrade before nix-stable
        version = "1.41.6.9685-d301f511a";
        url = "https://downloads.plex.tv/plex-media-server-new/1.41.6.9685-d301f511a/debian/plexmediaserver_1.41.6.9685-d301f511a_amd64.deb";
        sha256 = "sha256-4ZbSGQGdkXCCZZ00w0/BwRHju4DJUQQBGid0gBFK0Ck=";
      };
    });
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./riley.nix
      ./timers.nix
      (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kate";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.firefox.enable = true;

  # system.autoUpgrade = {
  #   enabled = true;
  #   dates = "weekly";
  # };
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };
  nix.settings.auto-optimise-store = true;

  networking.firewall.allowedTCPPorts = [
    80
    6969
    9090
    19132
    8554
  ];

  services.logind.lidSwitch = "ignore";

  services.vscode-server.enable = true;

  networking.firewall.allowedUDPPorts = [
    6969
    19132
  ];

  systemd.tmpfiles.rules = [
        "d /etc/letsencrypt 0770 root docker -"
        "d /var/lib/letsencrypt 0770 root docker -"
  ];

  services.prometheus = {
    enable = true;
    configText = (builtins.readFile /home/riley/appdata/prometheus.yml);
    enableReload = true;
    pushgateway.enable = true;
    extraFlags = [
      "--web.enable-remote-write-receiver"
    ];
    exporters = {
      node = {
        enable = true;
        port = 9100;
        enabledCollectors = [ "systemd" ];
        extraFlags = [
          "--collector.ethtool"
          "--collector.softirqs"
          "--collector.tcpstat"
          "--collector.textfile.directory=/home/riley/appdata/node_exporter"
        ];
      };
    };
  };
  
  services.code-server = {
    enable = true;
    user = "riley";
    host = "0.0.0.0";
    port = 6969;
  };

  services.nginx = {
    enable = true;
    virtualHosts."files.r.ss" = {
      forceSSL = false;
      root = "/var/www/files";
    };
  };

  services.plex = {
    package = customPlex;
    enable = true;
    openFirewall = true;
  };
  services.tautulli = {
    enable = true;
    openFirewall = true;
  };

  fileSystems."/mnt/bucket" = {
    device = "192.168.2.6:/mass";
    fsType = "nfs";
  };

  fileSystems."/mnt/red" = {
    device = "192.168.2.6:/red";
    fsType = "nfs";
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
