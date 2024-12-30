{ pkgs, ... }:

{
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
      tmux
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

  environment.systemPackages  = with pkgs; [
    vim
    git
    unzip
    gnumake
    tailscale
    smartmontools
    github-runner
  ];

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [
    22
  ];

  virtualisation.docker.enable = true;

  services.tailscale.enable = true;
  services.tailscale.port = 41641;
  networking.firewall.allowedUDPPorts = [
    41641
  ];

  fileSystems."/mnt/scratch" = {
    device = "192.168.2.6:/scratch";
    fsType = "nfs";
  };

  fileSystems."/mnt/bucket" = {
    device = "192.168.2.6:/bucket";
    fsType = "nfs";
  };

  system.stateVersion = "24.05";
}
