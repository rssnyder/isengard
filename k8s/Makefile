server = 192.168.2.215
agent ?= 192.168.2.4

install:
	k3sup install --ip $(server)                      --user riley --k3s-extra-args '--kubelet-arg=cloud-provider=external --disable traefik --disable servicelb --disable-cloud-controller'
	k3sup join    --ip $(agent) --server-ip $(server) --user riley --k3s-extra-args '--kubelet-arg=cloud-provider=external' --server-user riley
	KUBECONFIG=./kubeconfig kubectl get nodes -o wide

bootstrap:
	ssh $(server) "sudo curl -sL https://github.com/controlplaneio-fluxcd/flux-operator/releases/latest/download/install.yaml -o /var/lib/rancher/k3s/server/manifests/flux-operator.yaml"
	ssh $(server) "curl -sL https://raw.githubusercontent.com/rssnyder/isengard/refs/heads/master/k8s/clusters/pve/flux.yaml | sudo tee /var/lib/rancher/k3s/server/manifests/flux.yaml"

secrets:
	kubeseal -f clusters/pve/secrets.yaml -w infrastructure/pve/secrets/ssecrets.yaml

uninstall:
	ssh $(agent) "k3s-killall.sh; k3s-agent-uninstall.sh"
	ssh $(server) "k3s-killall.sh; k3s-uninstall.sh"
:pods
