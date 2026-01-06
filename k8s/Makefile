server = 192.168.2.215
agent0 = 192.168.2.230
agent1 = 192.168.2.232

desktop = 192.168.2.4

install:
	k3sup install --ip $(server) --user riley --k3s-extra-args '--disable traefik --disable servicelb' # --no-extras
	k3sup join --ip $(agent0) --server-ip $(server) --user riley --server-user riley
	k3sup join --ip $(agent1) --server-ip $(server) --user riley --server-user riley
	KUBECONFIG=./kubeconfig kubectl get nodes -o wide

install-desktop:
	k3sup join --ip $(agent1) --server-ip $(server) --user riley --server-user riley

bootstrap:
	ssh $(server) "sudo curl -sL https://github.com/controlplaneio-fluxcd/flux-operator/releases/latest/download/install.yaml -o /var/lib/rancher/k3s/server/manifests/flux-operator.yaml"
	ssh $(server) "curl -sL https://raw.githubusercontent.com/rssnyder/isengard/refs/heads/master/k8s/clusters/pve/flux.yaml | sudo tee /var/lib/rancher/k3s/server/manifests/flux.yaml"

	ssh $(server) "sudo apt-get update;sudo apt-get install -y qemu-guest-agent open-iscsi nfs-kernel-server lvm2; systemctl enable --now qemu-guest-agent"
	ssh $(agent0) "sudo apt-get update;sudo apt-get install -y qemu-guest-agent open-iscsi nfs-kernel-server lvm2; systemctl enable --now qemu-guest-agent"
	ssh $(agent1) "sudo apt-get update;sudo apt-get install -y qemu-guest-agent open-iscsi nfs-kernel-server lvm2; systemctl enable --now qemu-guest-agent"

secrets:
	kubeseal -f clusters/pve/secrets.yaml -w infrastructure/pve/secrets/ssecrets.yaml

uninstall:
	ssh $(agent0) "k3s-killall.sh; k3s-agent-uninstall.sh"
	ssh $(agent1) "k3s-killall.sh; k3s-agent-uninstall.sh"
	ssh $(agent2) "k3s-killall.sh; k3s-agent-uninstall.sh"
	ssh $(server) "k3s-killall.sh; k3s-uninstall.sh"
