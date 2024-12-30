{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./riley.nix
      (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "t480-0";

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

  networking.firewall.allowedTCPPorts = [
    6969
    9090
  ];

  services.logind.lidSwitch = "ignore";

  services.vscode-server.enable = true;

  services.github-runners = {
    isengard = {
      enable = true;
      name = "isengard";
      tokenFile = "/home/riley/.isengard_runner";
      url = "https://github.com/rssnyder/isengard";
    };
  };

  networking.firewall.allowedUDPPorts = [
    6969
  ];

  virtualisation = {
      podman = {
        enable = true;
      };
      oci-containers.containers = {
        prometheus-node-exporter-textfiles = {
          image = "quay.io/galexrt/node-exporter-textfiles:v20220922-124518-926";
          environment = {
            SCRIPT = "smartmon.sh";
          };
          cmd = [
            "/entrypoint.sh --by-id"
          ];
          volumes = [
            "/home/riley/appdata/node_exporter:/var/lib/node_exporter"
          ];
          extraOptions = [ "--privileged" ];
        };
        tdarr = {
          image = "ghcr.io/haveagitgat/tdarr:latest";
          ports = [
            "8265:8265"
          ];
          environment = {
            TZ = "America/Chicago";
            PUID = "America/Chicago";
            PGID = "America/Chicago";
            UMASK_SET = "777";
          };
          volumes = [
            "/home/riley/appdata/tdarr/server:/app/server"
            "/home/riley/appdata/tdarr/configs:/app/configs"
            "/home/riley/appdata/tdarr/logs:/app/logs"
            "/mnt/bucket/media:/media"
            "/tmp:/temp"
            "/dev/dri:/dev/dri"
          ];
        };
      };
  };

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

  system.stateVersion = "24.05";
}
