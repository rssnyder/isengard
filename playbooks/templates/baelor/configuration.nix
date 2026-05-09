{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "baelor"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  environment.systemPackages  = with pkgs; [
    vim
    python312
    tailscale
  ];

  services.tailscale.enable = true;
  services.tailscale.port = 41641;

  # user
  users.users.riley = {
    isNormalUser = true;
    description = "riley";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
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
  services.openssh.enable = true;

  # Prometheus node exporter
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [ "systemd" ];
    openFirewall = true;
  };

  # firewall
  networking.firewall.allowedTCPPorts = [
    22
    8007
    111 2049 4000 4001 4002 20048
  ];
  networking.firewall.allowedUDPPorts = [
    41641
    111 2049 4000 4001  4002 20048
  ];

  # create directories for nfs and share
  systemd.tmpfiles.rules = [
    "d /slow 0777 nobody nogroup"
    "d /fast 0777 nobody nogroup"
    "d /fast/proxmox 0777 nobody nogroup"
    "d /slow/frigate 0777 nobody nogroup"
    "d /var/lib/drone-runner-proxmox 0755 root root"
    "C+ /var/lib/drone-runner-proxmox/pool.yml - - - - ${pkgs.writeText "pool.yml" ''
      version: "1"
      instances:
        - name: debian-amd64
          default: true
          pool: 1
          limit: 10
          platform:
            os: linux
            arch: amd64
          spec:
            node: pve0
            storage: data
            cloudinit_storage: baelor
            template_image: baelor:import/debian-13-genericcloud-amd64.qcow2
            memory: 2048
            cores: 2
            disk_size: 20
            bridge: vmbr0
            ssh_authorized_keys:
            - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0eYIj1qScmuGmXxYgu54r7s99s5chsjqFwZ/Vwamu5HLb0AmcgCdDaUkHX7YpGTcbafVTHJXVx/V8JKzu2jiztoXZy52JbIpYbkZNgo+aLwB9Sj3XZXFEjarG+P6/iqNNMPIGhLvGOH61keyYoA8cUOhcBUODZWMssK8L2mQxcTNATzC5mv67H6IDiowcFnRV3CKe2VvsVdOLjAjJzQ1xBUpVENyIFohyV+7kmFI5dODct6UdhHjYfW9YA1qlQYfV+S8vU20jcmXcHF+M6x4i1D6kDb5Ig8/5B/Ym1dHFIjcFnBezF2CIT5tsUc4vqfY0DtdVqt9rHFS/swiNZl3GaG4pMF5ooG4RIkb16oFTwBhsEHMzjzG+Pqaqt8UAHC7MXbY6fQxUts8SZUSal7ydoMw3mOKFCtOog517PkqgGUJt2UNsur0R204Vgxlqx3xTkYbW7VKdglr4MrLjglCM1bT6+cnrP+h2FiWAlXpMXmS4ymsWlrkucmyX0hmLWAk= riley@hurley
    ''}"
  ];
  fileSystems."/slow" = {
    device = "/dev/disk/by-uuid/cf22174d-13e4-4397-8e92-3029d690a4ab";
    options = ["nofail"];
  };
  services.nfs.server = {
    enable = true;
    # fixed rpc.statd port; for firewall
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    extraNfsdConfig = '''';
    exports = ''
      /fast/proxmox  *(rw,sync,no_subtree_check)
      /slow          *(rw,sync,no_subtree_check)
    '';
  };

  # Intel GPU hardware acceleration for Frigate
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };

  # containers
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers.containers = {
        proxmox-userdata-proxy = {
          image = "rssnyder/proxmox-userdata-proxy:latest";
          ports = [ "8443:8443" ];
          user = "65534:65534";
          volumes = [
            "/fast/proxmox:/mnt/pve/storage"
          ];
          environment = {
            PROXMOX_URL = "https://192.168.2.69:8006";
            PROXMOX_INSECURE = "true";
            SNIPPET_STORAGE_MAP = "baelor=/mnt/pve/storage";
            PROXY_LISTEN_ADDR = ":8443";
            LOG_LEVEL = "info";
          };
          extraOptions = [ "--network=harness" ];
        };
        harness-delegate = {
          image = "harness/delegate:26.04.88903";
          environment = {
            DELEGATE_NAME = "baelor-delegate";
            NEXT_GEN = "true";
            ACCOUNT_ID = "AM8HCbDiTXGQNrTIhNl7qQ";
            DELEGATE_TOKEN = "YWY0ZTZmM2Y1ZTRmNTc1OTQzMDNmZTFmNjg5YzE2OGY=";
            MANAGER_HOST_AND_PORT = "https://app.harness.io/gratis";
            LOG_STREAMING_SERVICE_URL = "https://app.harness.io/log-service/";
            DEPLOY_MODE = "KUBERNETES";
            DELEGATE_TYPE = "DOCKER";
            RUNNER_URL = "http://drone-runner-proxmox:3000";
          };
          extraOptions = [ "--network=harness" ];
          dependsOn = [ "drone-runner-proxmox" ];
        };
        drone-runner-proxmox = {
          image = "rssnyder/drone-runner-proxmox:latest";
          ports = [ "3000:3000" ];
          volumes = [
            "/var/lib/drone-runner-proxmox:/data"
          ];
          environment = {
            PROXMOX_URL = "http://proxmox-userdata-proxy:8443";
            PROXMOX_AUTH = "PVEAPIToken=terraform@pve!proxy=02683859-29a3-4478-9b1e-15f03c87df59";
            DATABASE_PATH = "/data/runner.db";
            POOL_FILE = "/data/pool.yml";
          };
          extraOptions = [ "--network=harness" ];
          dependsOn = [ "proxmox-userdata-proxy" ];
        };
        frigate = {
          image = "ghcr.io/blakeblackshear/frigate:stable";
          autoStart = true;
          ports = [
            "5000:5000"
            "8971:8971"
            "8554:8554"
            "8555:8555/tcp"
            "8555:8555/udp"
          ];
          volumes = [
            "/var/lib/frigate/config.yml:/config/config.yml:ro"
            "/slow/frigate:/media/frigate"
            "/etc/localtime:/etc/localtime:ro"
          ];
          environment = {
            FRIGATE_RTSP_PASSWORD = "{{ default_password }}";
          };
          extraOptions = [
            "--device=/dev/dri/renderD128:/dev/dri/renderD128"
            "--device=/dev/bus/usb:/dev/bus/usb"
            "--shm-size=656m"
            "--privileged"
            "--tmpfs=/tmp/cache:size=4000000000"
          ];
        };
      };
  };

  # Create podman network for harness containers
  systemd.services.podman-network-harness = {
    description = "Create harness podman network";
    wantedBy = [ "multi-user.target" ];
    before = [
      "podman-proxmox-userdata-proxy.service"
      "podman-drone-runner-proxmox.service"
      "podman-harness-delegate.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.podman}/bin/podman network create --ignore harness";
    };
  };

  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11"; # Did you read the comment?

}
