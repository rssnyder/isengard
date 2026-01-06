server = 192.168.2.215
agent0 = 192.168.2.230
agent1 = 192.168.2.232

desktop = 192.168.2.4

install:
	k3sup install --ip $(server)                       --user riley --k3s-extra-args '--disable traefik --disable servicelb --cloud-provider=external'
	k3sup join    --ip 192.168.2.235 --server-ip 192.168.2.215 --user riley --k3s-extra-args '--kubelet-arg=cloud-provider=external'                                       --server-user riley
	k3sup join    --ip $(agent1) --server-ip $(server) --user riley --k3s-extra-args '--kubelet-arg=cloud-provider=external'                                       --server-user riley
	KUBECONFIG=./kubeconfig kubectl get nodes -o wide

install-desktop:
	k3sup join --ip $(agent1) --server-ip $(server) --user riley --server-user riley

bootstrap:
	ssh $(server) "sudo curl -sL https://github.com/controlplaneio-fluxcd/flux-operator/releases/latest/download/install.yaml -o /var/lib/rancher/k3s/server/manifests/flux-operator.yaml"
	ssh $(server) "curl -sL https://raw.githubusercontent.com/rssnyder/isengard/refs/heads/master/k8s/clusters/pve/flux.yaml | sudo tee /var/lib/rancher/k3s/server/manifests/flux.yaml"

secrets:
	kubeseal -f clusters/pve/secrets.yaml -w infrastructure/pve/secrets/ssecrets.yaml

uninstall:
	ssh $(agent0) "k3s-killall.sh; k3s-agent-uninstall.sh"
	ssh $(agent1) "k3s-killall.sh; k3s-agent-uninstall.sh"
	ssh $(agent2) "k3s-killall.sh; k3s-agent-uninstall.sh"
	ssh $(server) "k3s-killall.sh; k3s-uninstall.sh"
