kubectl apply -f frigate.yaml

helm repo add blakeblackshear https://blakeblackshear.github.io/blakeshome-charts/

helm upgrade --install frigate blakeblackshear/frigate -n frigate -f helm/frigate.values.yaml