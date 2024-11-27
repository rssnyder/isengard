# :eye: isengard :eye:

personal ansible-tower like tool using github actions

mostly ran locally these days off my pi4 running [code server](https://github.com/coder/code-server)

[![Run playbook](https://github.com/rssnyder/isengard/actions/workflows/run_playbook.yml/badge.svg)](https://github.com/rssnyder/isengard/actions/workflows/run_playbook.yml)

[![Run nightly](https://github.com/rssnyder/isengard/actions/workflows/run_nightly.yml/badge.svg)](https://github.com/rssnyder/isengard/actions/workflows/run_nightly.yml)

[![Terraform](https://github.com/rssnyder/isengard/actions/workflows/terraform.yml/badge.svg)](https://github.com/rssnyder/isengard/actions/workflows/terraform.yml)

![ACTIONS](https://user-images.githubusercontent.com/7338312/118890029-9dc50380-b8c3-11eb-81d7-131dc2f6687e.png)

this is a living repo, master is not assumed stable

powered by github's generosity and machines i find in local dumpsters

## infra

starting to run newer services in kubernetes, because i've grown tired of plain docker with compose

![network diagram](https://github.com/rssnyder/isengard/assets/7338312/a0c83b34-a182-4eff-b3e5-0c046c335af2)

- applications are (usually) launched as a deployment
- when a service is added [metallb](https://metallb.universe.tf/) provisions the service an ip address on my local network
  - optionally the service is added to the [tailnet](https://tailscale.com/) and/or given a [local dns](https://pi-hole.net/) entry (usually `<service>.r.ss`)
- if external public access is needed an [ingress](https://github.com/kubernetes/ingress-nginx) record is created with a `<service>.k8s.rileysnyder.dev` domain
  - routed from a [caddy](https://caddyserver.com/) reverse proxy acting as the entrypoint to my local network.
- [longhorn](https://longhorn.io/) for storage
- nodes are random machines that i dont have another use for at any given time, swapped out often
- manifests are under `infra/k8s` applied either with kubectl, [k3s manifests directory](https://docs.k3s.io/installation/packaged-components), or [harness](https://www.harness.io/) (both regular deployments and gitops), because i need to try everything


## secrets

using ansible vault with a password in a local file

### encrypt

```shell
ansible-vault encrypt_string --vault-password-file .vault_password 'bar' --name 'foo'
```

## cidr

|              | cidr           | notes                           |
|--------------|----------------|---------------------------------|
| home         | 192.168.2.0/24 |                                 |
| tailscale    | 100.64.0.0/10  |                                 |
| lab cluster  | 10.42.0.0/16   |                                 |
| lab svc      | 10.43.0.0/16   |                                 |
| oc cluster   | 10.42.0.0/16   | need to migrate to 10.44.0.0/16 |
| oc svc       | 10.43.0.0/16   | need to migrate to 10.45.0.0/16 |
| ocdr cluster | 10.46.0.0/16   |                                 |
| ocdr svc     | 10.47.0.0/16   |                                 |
| oc2 cluster  | 10.48.0.0/16   |                                 |
| oc2 svc      | 10.49.0.0/16   |                                 |
