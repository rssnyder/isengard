# :eye: isengard :eye:

code for my homelab

## compute

most machines in my lab are ones I save from the dumpster or recycler, mostly laptops and a few desktops used for network storage. the only machine i have purchased is the raspberry pi.

all servers are named after characters from lost, except for my storage server which switches off between the names "zira" and "cornelius" (named after the chimpanzees from the origional planet of the apes) with every rebuild, we are currently on zira iv.

i historacally used ubuntu server for all my servers, and kde neon for desktops/laptops. i am now moving everything to [nixos](https://nixos.org/) with only my storage server and lab cluster nodes left to migrate.

### rack

my main network is a tp-link router and switch which are mounted in a custom 3d printed rack that hangs from the underside of my sit/stand desk. my switch has four poe ports which are routed to:

- tp-link access point in my living room
- amcrest camera in my lab
- amcrest camera mounted on my roof covering the front yard
- poe pass through switch in my garage

the custom rack also has custom mounts for the following devices:

- aplifier for my desktop speakers
- hurley [`pi 4` | `debian`]: networking entrypoint (caddy), granafa instance, random other lightweight services
- ben [`gmktec g3` | `nixos`]: k3s single node server
- hdhomerun: for recording local over-the-air tv

### laundry room

i also run ethernet to a switch in my laundry room storage shelves where i have a few more machines:

- zira [`custom dell optiplex` | `ubuntu`]: zfs storage server
  - pools
    - bucket - media + long term storage
      - x2 18tb mirror
      - x2 24tb mirror
      - 42tb usable
    - scratch - download cache, misc. files
      - x2 2tb zfs raid zero
      - 4tb usable
- charlie [`dell precision t1700` | `ubuntu`]: k3s "lab" master
  - runs home assistant using a zigbee usb reciver
- jack [`dell precision 7520` | `ubuntu`]: k3s "lab" worker
  - runs frigate with a [coral tpu](https://coral.ai/products/accelerator) usb

### garage

the poe pass through switch in my garage provides internet to three thinkpad laptops mounted to pegboard next to my 3d printer on my workspace:

- t480-0 [`thinkpad t480` | `nixos`]: i do all my development remotely on this machine (vscode server) and it also runs my central prometheus server that gathers metrics on all my machines/clusters
- claire [`thinkpad t470p` | `ubuntu`]: k3s "lab" worker
- plex `[thinkpad t480` | `ubuntu`]: runs plex and tautuli, accesses media via nfs shares on storage server

### backup

- zaius [`dell precision t1700` | `ubuntu`]: backup server,  k3s single node server
  - pools
    - pale - offsite backup
      - x1 10tb
      - 10tb usable

## hosting

i am starting to run newer services in kubernetes, because i was running on docker compose for many years and needed a new challenge. most mission critial things are still run using plain docker or systemd.

![network diagram](https://github.com/rssnyder/isengard/assets/7338312/a0c83b34-a182-4eff-b3e5-0c046c335af2)

### kubernetes

- applications are (usually) launched as a deployment
- when a service is added [metallb](https://metallb.universe.tf/) provisions the service an ip address on my local network
  - optionally the service is added to the [tailnet](https://tailscale.com/) using the [tailscale operator](https://tailscale.com/kb/1236/kubernetes-operator) and/or given a [local dns](https://pi-hole.net/) entry (usually `<service>.r.ss`) using [external dns](https://github.com/kubernetes-sigs/external-dns).
- if external public access is needed an [ingress](https://github.com/kubernetes/ingress-nginx) record is created with a `<service>.k8s.rileysnyder.dev` domain
  - routed from a [caddy](https://caddyserver.com/) reverse proxy acting as the entrypoint to my local network (pi4)
- [longhorn](https://longhorn.io/) for storage within the cluster, nfs for critial items (using main storage server)
- manifests are under `infra/k8s` applied either with kubectl, [k3s manifests directory](https://docs.k3s.io/installation/packaged-components), or [harness](https://www.harness.io/) (both regular deployments and gitops), because i need to try everything

applications are deployed using `kubectl apply`, whereas cluster baselines and core services are created by running an ansible playbook that places manifests on the master nodes [manifest directory](https://docs.k3s.io/installation/packaged-components#auto-deploying-manifests-addons). i strive to be simple.

a few apps like frigate and home assistant are deployed using [harness](https://www.harness.io/) (my current employer).

my "lab" cluster is my main cluster, i have another running in oracle cloud using their [free tier](https://gist.github.com/rssnyder/51e3cfedd730e7dd5f4a816143b25dbd) where i run some paid services, and one at my parnets which serves as my offsite backup. all clusters remote-write their metrics to my main prometheus server which I use with grafana to create dashboards and alerts.

### secrets

using ansible vault with a password in a local file

#### encrypt

```shell
ansible-vault encrypt_string --vault-password-file .vault_password 'bar' --name 'foo'
```

# notes

## cidr

|              | cidr             | notes                           |
|--------------|------------------|---------------------------------|
| home         | 192.168.2.0/24   |                                 |
| lab          | 192.168.254.0/24 |                                 |
| micro        | 192.168.253.0/24 |                                 |
| tailscale    | 100.64.0.0/10    |                                 |
| lab cluster  | 10.42.0.0/16     |                                 |
| lab svc      | 10.43.0.0/16     |                                 |
| oc cluster   | 10.42.0.0/16     | need to migrate to 10.44.0.0/16 |
| oc svc       | 10.43.0.0/16     | need to migrate to 10.45.0.0/16 |
| ocdr cluster | 10.46.0.0/16     |                                 |
| ocdr svc     | 10.47.0.0/16     |                                 |
| oc2 cluster  | 10.48.0.0/16     |                                 |
| oc2 svc      | 10.49.0.0/16     |                                 |
