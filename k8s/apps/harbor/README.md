# Harbor Artifact Repository

## Configuration

**Storage:** 100GB proxmox storage class  
**Service:** LoadBalancer at `harbor.r.ss`  
**Admin Password:** Encrypted via sealed-secrets

## Deployment

The Harbor Helm chart is deployed via Flux. The admin password is managed as a sealed secret for security.

### Admin Password

The admin password has been encrypted in `sealed-secret.yaml`. When the sealed-secrets controller decrypts it, the Secret `harbor-admin` will be created in the `harbor` namespace.

To update the admin password in the future:
```bash
# Create a new secret with the password
cat > /tmp/harbor-admin.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: harbor-admin
  namespace: harbor
type: Opaque
stringData:
  adminPassword: <new-password>
EOF

# Seal it
kubeseal -f /tmp/harbor-admin.yaml -w k8s/apps/harbor/sealed-secret.yaml

# Commit and push
git add k8s/apps/harbor/sealed-secret.yaml
git commit -m "chore: update harbor admin password"
```

## First-Time Setup

1. After deployment, the Helm release will create the Harbor deployment
2. The admin password from the sealed secret will be set during initial setup
3. You can access Harbor at `http://harbor.r.ss` once the service is ready

## Storage Breakdown

- **Registry:** 100GB (main artifact storage)
- **Job Service:** 1GB (job execution logs)
- **Database:** 1GB (metadata)
- **Redis:** 1GB (cache)
- **Trivy:** 5GB (vulnerability database, disabled for now)

To enable additional features in the future, edit the Helm values in `helm-release.yaml`.
