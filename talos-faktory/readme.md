# talos faktory

the goal here is to boostrap a talos k8s cluster on a proxmox cluster through 100% hcl

this is achivable by using the [talos image factory](https://factory.talos.dev/) which lets us download an image compatable with proxmox (and includes the qemu-guest tools) and bootstrap the nodes with the talos provider

## defaults

defaults are provided based on my cluster and networking configuration, but are avalible to make this flexable for any other proxmox setup

at a minimum i just have to specify which nodes to use and the ips for the control plan and worker nodes

## ips

ips have to be set explicety because if we let proxmox and my router assign dynamic ips, we have to do a two part apply to first create the vms, then do the talos bootrstrapping, since we for_each over the created vms and use their outputs (ips) as inputs to the later resources

this is a small price to pay for a one-shot apply 0-talos in 

i have a set of 126 reserved ips on my network i can pick from, i count down to make it easy

## workspaces

i have never used todu workspaces, so this seemed like a great use case and lets me keep this config seperate from the rest of my homelab, which can sometimes be in a wonky state

a makefile has been created so i can easily swap workspaces and be sure and set the right var file on plan/apply

## result

[00h:00m:00s] configuration built
[00h:00m:54s] image downloaded, vms provisioned
[00h:02m:49s] vm running, configuration applied