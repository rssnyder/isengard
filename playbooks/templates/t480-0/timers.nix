{ config, pkgs, ... }:

{
  systemd.timers."k8s-delete-nodeports" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "10m";
      OnUnitActiveSec = "10m";
      Unit = "k8s-delete-nodeports.service";
    };
  };

  systemd.services."k8s-delete-nodeports" = {
    script = ''
      set -eu
      KUBECONFIG=/home/riley/.kube/config ${pkgs.kubectl}/bin/kubectl -n homeassistant get pods | grep NodePorts | /run/current-system/sw/bin/awk '{print $1}' | while read i; do KUBECONFIG=/home/riley/.kube/config ${pkgs.kubectl}/bin/kubectl -n homeassistant delete pod/$i; done
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "riley";
    };
  };

  systemd.timers."backup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true; 
      Unit = "backup.service";
    };
  };

  systemd.services."backup" = {
    script = ''
      set -eu
      ${pkgs.ansible}/bin/ansible-playbook --vault-password /home/riley/isengard/.vault_password -i /home/riley/isengard/hosts.yml -i /home/riley/isengard/secrets.yml /home/riley/isengard/playbooks/backup.yml
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "riley";
    };
  };
}
