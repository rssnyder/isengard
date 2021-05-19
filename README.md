# isengard
personal ansible-tower like tool using github actions

## why

because running AWX takes k8s, and I like a good project

i currently run all my ansible locally, but want some centeralized place to run my playbooks

## what about secrets

using ansible vault with a password in a local file

### encrypt

```
ansible-vault encrypt_string --vault-password-file vault_password 'bar' --name 'foo'
```

## connections

use [nebula-network-connect](https://github.com/marketplace/actions/nebula-network-connect) to join the GHA running to my nebula mesh net
