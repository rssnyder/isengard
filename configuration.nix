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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kubectl
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

  programs.firefox.enable = true;

  environment.systemPackages  = with pkgs; [
    vim
    zsh
    git
    htop
    unzip
    gnumake
    tailscale
    github-runner
  ];

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [
    22
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

  system.stateVersion = "24.05";
}
