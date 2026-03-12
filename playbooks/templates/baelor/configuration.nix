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
  ];

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

  # containers
  virtualisation = {
    podman = {
      enable = true;
    };
    oci-containers.containers = {
        pbs = {
          image = "ayufan/proxmox-backup-server:v4.0.21-1";
          entrypoint = "/root/main";
          environment = {
              DEV_MODE = "false";
          };
          ports = ["8007:8007"];
          volumes = [
            "/fast:/fast"
            "/slow:/slow"
            "/tmp/pbs:/run"
          ];
          capabilities = {
            SYS_RAWIO = true;
          };
        };
      };
  };

  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11"; # Did you read the comment?

}