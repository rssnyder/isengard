# :eye: isengard :eye:
personal ansible-tower like tool using github actions

[![Run playbook](https://github.com/rssnyder/isengard/actions/workflows/run_playbook.yml/badge.svg)](https://github.com/rssnyder/isengard/actions/workflows/run_playbook.yml)

[![Run nightly](https://github.com/rssnyder/isengard/actions/workflows/run_nightly.yml/badge.svg)](https://github.com/rssnyder/isengard/actions/workflows/run_nightly.yml)

[![Run Discord Stock Ticker](https://github.com/rssnyder/isengard/actions/workflows/run_dst.yml/badge.svg)](https://github.com/rssnyder/isengard/actions/workflows/run_dst.yml)

![ACTIONS](https://user-images.githubusercontent.com/7338312/118890029-9dc50380-b8c3-11eb-81d7-131dc2f6687e.png)

## why

because running [awx](https://github.com/ansible/awx/) takes k8s

i currently run all my ansible locally, but want some centeralized place to run my playbooks

i also have a dislike for cron

## what about secrets

using ansible vault with a password in a local file

### encrypt

```
ansible-vault encrypt_string --vault-password-file .vault_password 'bar' --name 'foo'
```

## connections

use [nebula-network-connect](https://github.com/marketplace/actions/nebula-network-connect) to join the GHA runner to my [nebula](https://github.com/slackhq/nebula) mesh net
