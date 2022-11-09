kubectl apply -f frigate.yaml

helm upgrade --install frigate blakeblackshear/frigate -n frigate -f helm/frigate.values.yaml