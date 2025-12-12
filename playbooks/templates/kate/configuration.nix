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

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };
  nix.settings.auto-optimise-store = true;

  networking.firewall.allowedTCPPorts = [
    9090
  ];

  services.logind.lidSwitch = "ignore";

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

  fileSystems."/mnt/scratch" = {
    device = "192.168.2.6:/scratch";
    fsType = "nfs";
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
