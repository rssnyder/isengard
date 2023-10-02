#!/bin/bash

# helm installs in the cluster

helm upgrade --install metallb metallb/metallb --namespace metallb-system --create-namespace

helm upgrade --install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.5.1
