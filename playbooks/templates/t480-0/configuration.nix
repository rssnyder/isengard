{ config, pkgs, ... }:

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
    6969
    9090
    19132
    8554
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
    19132
  ];

  systemd.tmpfiles.rules = [
        "d /etc/letsencrypt 0770 root docker -"
        "d /var/lib/letsencrypt 0770 root docker -"
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
        bedrock = {
          image = "itzg/minecraft-bedrock-server";
          ports = [
            "19132:19132/udp"
          ];
          environment = {
            EULA= "TRUE";
            SERVER_NAME = "The DeSoto Dropouts";
          };
          volumes = [
            "/home/riley/appdata/bedrock:/data"
          ];
        };
        # certbot = {
        #   image = "certbot/dns-digitalocean";
        #   cmd = [
        #     "certonly --config=/config/le.ini --dns-digitalocean --dns-digitalocean-credentials=/config/do.ini -d=lab.rileysnyder.dev -d='*.lab.rileysnyder.dev'"
        #   ];
        #   volumes = [
        #     "/home/riley/appdata/certbot:/config"
        #     "/etc/letsencrypt:/etc/letsencrypt"
        #     "/var/lib/letsencrypt:/var/lib/letsencrypt"
        #   ];
        # };
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

  services.dockerRegistry = {
    enable = true;
    enableDelete = true;
    listenAddress = "0.0.0.0";
    openFirewall = true;
    # extraConfig = {
    #   log.level = "debug";
    #   http.host = "registry.lab.rileysnyder.dev:5000";
    #   http.tls.certificate = "/etc/letsencrypt/live/lab.rileysnyder.dev/cert.pem";
    #   http.tls.key = "/etc/letsencrypt/live/lab.rileysnyder.dev/privkey.pem";
    #   http.tls.clientcas = [
    #     "/etc/letsencrypt/live/lab.rileysnyder.dev/fullchain.pem"
    #   ];
    # };
  };

  services.nginx = {
    enable = true;
    virtualHosts."files.r.ss" = {
      forceSSL = false;
      root = "/var/www/files";
    };
  };

  services.mediamtx = {
    enable = true;
    allowVideoAccess = true;
    settings = {
      paths = {
        plants = {
          runOnInit = "${pkgs.ffmpeg}/bin/ffmpeg -f v4l2 -i /dev/video0 -c:v libx264 -preset ultrafast -b:v 600k -f rtsp rtsp://localhost:8554/plants";
          runOnInitRestart = true;
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
