# :eye: isengard :eye:
personal ansible-tower like tool using github actions

[![Run playbook](https://github.com/rssnyder/isengard/actions/workflows/run_playbook.yml/badge.svg)](https://github.com/rssnyder/isengard/actions/workflows/run_playbook.yml)

[![Run nightly](https://github.com/rssnyder/isengard/actions/workflows/run_nightly.yml/badge.svg)](https://github.com/rssnyder/isengard/actions/workflows/run_nightly.yml)

[![Terraform](https://github.com/rssnyder/isengard/actions/workflows/terraform.yml/badge.svg)](https://github.com/rssnyder/isengard/actions/workflows/terraform.yml)

![ACTIONS](https://user-images.githubusercontent.com/7338312/118890029-9dc50380-b8c3-11eb-81d7-131dc2f6687e.png)

this is a living repo, master is not assumed stable. i learn by failing fast

## why

because running [awx](https://github.com/ansible/awx/) takes k8s

i currently run all my ansible locally, but want some centeralized place to run my playbooks

this keeps the playbooks, scripts, domains, automation, all as code and all in the same place

i also have a dislike for cron

## what about secrets

using ansible vault with a password in a local file

### encrypt

```
ansible-vault encrypt_string --vault-password-file .vault_password 'bar' --name 'foo'
```

## connections

previously: use [nebula-network-connect](https://github.com/marketplace/actions/nebula-network-connect) to join the GHA runner to my [nebula](https://github.com/slackhq/nebula) mesh net

currently: self hosted runner in my home network, connected to nebula net
