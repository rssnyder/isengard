# /bin/sh 


PROXY_HOST=ff-proxy.k8s.rileysnyder.dev
PROXY_PATH=ff-proxy
TARGET=proxytest
API_KEY=b89d7f72-547f-49df-b8a4-70a24efd2171dddd

# Authenticate as Client SDK with target
AUTH_TOKEN=$(curl -s -X POST "https://$PROXY_HOST/$PROXY_PATH/client/auth" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"apiKey\":\"$API_KEY\",\"target\":{\"identifier\":\"$TARGET\"}}" | jq -r '.authToken')

# Get custer id and env id from the token
CLUSTER_ID=$(echo $AUTH_TOKEN | jq -R 'split(".") | .[1] | @base64d | fromjson' | jq -r '.clusterIdentifier')
ENV_ID=$(echo $AUTH_TOKEN | jq -R 'split(".") | .[1] | @base64d | fromjson' | jq -r '.environment')

echo "auth token: $AUTH_TOKEN"
echo "cluster id: $CLUSTER_ID"
echo "env id: $ENV_ID"
