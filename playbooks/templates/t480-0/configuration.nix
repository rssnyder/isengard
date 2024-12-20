{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
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

  users.users.riley = {
    isNormalUser = true;
    description = "riley";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      zsh
      htop
      kubectl
      ansible
      opentofu
      python312
      oh-my-zsh
      zsh-completions
      zsh-syntax-highlighting
      zsh-history-substring-search
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0eYIj1qScmuGmXxYgu54r7s99s5chsjqFwZ/Vwamu5HLb0AmcgCdDaUkHX7YpGTcbafVTHJXVx/V8JKzu2jiztoXZy52JbIpYbkZNgo+aLwB9Sj3XZXFEjarG+P6/iqNNMPIGhLvGOH61keyYoA8cUOhcBUODZWMssK8L2mQxcTNATzC5mv67H6IDiowcFnRV3CKe2VvsVdOLjAjJzQ1xBUpVENyIFohyV+7kmFI5dODct6UdhHjYfW9YA1qlQYfV+S8vU20jcmXcHF+M6x4i1D6kDb5Ig8/5B/Ym1dHFIjcFnBezF2CIT5tsUc4vqfY0DtdVqt9rHFS/swiNZl3GaG4pMF5ooG4RIkb16oFTwBhsEHMzjzG+Pqaqt8UAHC7MXbY6fQxUts8SZUSal7ydoMw3mOKFCtOog517PkqgGUJt2UNsur0R204Vgxlqx3xTkYbW7VKdglr4MrLjglCM1bT6+cnrP+h2FiWAlXpMXmS4ymsWlrkucmyX0hmLWAk= riley@hurley"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6skgzhanZcBCP4yk9lUeoq+RPC3iq4iHeStJ8eRA8EPk1/XmPjMEVv+wno6RarjYAruk7iUsXBFRcPUC5pCGE/KNhXFl45NOc7Z/1zsKFxBhyzbwXLusewSrCCSCtkJ88I/60QaSN/JSVqu5oFt9o+Y6YwsNMfkcie0xXm0DDUBlcsk4smjBTKuTJlJXurXxKbwBbph8fvZJJpx67cQhaJ27WcCJv31BT/MaIm6+/rdjCYbapVrMvQ4+CZjgrf418r3nHGJhLoovCljQsMtj6add/QsTRkMDjN+5am2GJcfDGC3luWL6bPiWCMgXnrQpAcCov7X/JbxsdvwTePGAyx2hEJwzBFBArOXD5dW3M5gqQIqfHnZLNcmOI1kpYaZI8BohfuvDCS1Y74cxD88w5YoiOWQ0dugzO5JuDLxtvtyoaUJmfdIIiT2xeTYEidJ+JQLnxp+ilwWrXhW6iJ0V+ozu6NRbdxZc6f95fKOh5tgtmMqUv9OZ1Ds15pRRnl7E= riley snyder@DESKTOP-5CDKR1F"
    ];
  };

  security.sudo.extraRules= [
    {  users = [ "riley" ];
      commands = [
        { command = "ALL" ;
          options= [ "NOPASSWD" ];
        }
      ];
    }
  ];

  programs.firefox.enable = true;

  environment.systemPackages  = with pkgs; [
    vim
    git
    unzip
    screen
    gnumake
    tailscale
    smartmontools
    github-runner
  ];

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [
    22
    6969
    9090
  ];

  virtualisation.docker.enable = true;

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

  services.tailscale.enable = true;
  services.tailscale.port = 41641;
  networking.firewall.allowedUDPPorts = [
    41641
    6969
  ];

  virtualisation = {
      podman = {
        enable = true;
      };
      oci-containers.containers = {
        # prometheus = {
        #   image = "prom/prometheus";
        #   ports = [
        #     "9090:9090"
        #   ];
        #   cmd = [
        #     "--config.file=/etc/prometheus/prometheus.yml"
        #     "--web.enable-admin-api"
        #     "--web.enable-lifecycle"
        #     "--storage.tsdb.path=/prometheus"
        #     "--web.console.libraries=/usr/share/prometheus/console_libraries"
        #     "--web.console.templates=/usr/share/prometheus/consoles"
        #     "--web.enable-remote-write-receiver"
        #   ];
        #   volumes = [
        #     "/home/riley/appdata/prometheus.yml:/etc/prometheus/prometheus.yml"
        #   ];
        # };
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
      # "--web.enable-lifecycle"
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

  fileSystems."/mnt/scratch" = {
    device = "192.168.2.6:/scratch";
    fsType = "nfs";
  };

  fileSystems."/mnt/bucket" = {
    device = "192.168.2.6:/bucket";
    fsType = "nfs";
  };
  
  services.code-server = {
    enable = true;
    user = "riley";
    host = "0.0.0.0";
    port = 6969;
  };

  system.stateVersion = "24.05";
}
