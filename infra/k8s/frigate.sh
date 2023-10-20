helm repo add blakeblackshear https://blakeblackshear.github.io/blakeshome-charts/

helm upgrade --install frigate blakeblackshear/frigate --namespace frigate -f values/frigate.yaml