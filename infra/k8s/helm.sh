#!/bin/bash

# helm installs in the cluster

helm upgrade --install metallb metallb/metallb --namespace metallb-system --create-namespace 

helm upgrade --install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.5.1 -f longhorn-values.yaml

helm upgrade --install harness-delegate-work --namespace harness-delegate-work --create-namespace \
  harness-delegate/harness-delegate-ng \
  --set delegateName=lab \
  --set accountId=wlgELJ0TTre5aZhzpt8gVA \
  --set delegateToken=REDACTED \
  --set managerEndpoint=https://app.harness.io/gratis \
  --set delegateDockerImage=harness/delegate:23.09.80505 \
  --set replicas=1 --set upgrader.enabled=true
