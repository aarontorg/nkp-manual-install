#!/bin/bash
set -euo pipefail

# Debug: Confirm we're running with bash
echo "Running with shell: $SHELL"
echo "Script location: $0"

echo "Generating SSH key..."
mkdir -p ${HOME}/.ssh
chmod 700 ${HOME}/.ssh
ssh-keygen -t ed25519 -N '' -a 100 -f ${HOME}/.ssh/id_ed25519

cd ${HOME}

echo "Switching to NKP bundle directory and loading NKP images..."
NKP_DIR=$(ls --color=never | grep nkp-v | head -1)
if [ -z "$NKP_DIR" ]; then
  echo "ERROR: Could not find nkp-v* directory" >&2
  exit 1
fi
echo "Found NKP directory: $NKP_DIR"
cd "$NKP_DIR" 

echo "Sourcing environment variables..."
source ../nkp-manual-install/env.vars

echo "Loading NKP images..."
# docker load -i nkp-image-builder-image-${NKP_VERSION}.tar # Optional, only needed if you want to create a customized images.
podman load -i konvoy-bootstrap-image-${NKP_VERSION}.tar

echo "Creating folder for the management cluster..."
mkdir -p ${HOME}/${CLUSTER_NAME}
cd ${HOME}/${CLUSTER_NAME}

# Store NKP_DIR path for bundle reference (we're now in cluster directory, so need to go up one level)
NKP_BUNDLE_PATH="../${NKP_DIR}/container-images/*.tar"

# Create self-signed cert
#IP_ADDRESS='x.x.x.x' # modify for first IP in MetalLbRange

# To organize all the files, create a folder for this. The proceeding steps assume this folder is in your home directory
mkdir nkp-cert
cd nkp-cert

# Create the CA (in this example, it expires in 10 years)
openssl genrsa -out ca.key 4096

openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 \
  -subj "/CN=NKP" \
  -out ca.crt

# Now create the cnf file (with SAN).
# Optionally you could set hostname instead, for both the CN and replace IP.1 with DNS.1
cat > server.cnf <<EOF
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[dn]
CN = ${IP_ADDRESS}

[req_ext]
subjectAltName = @alt_names

[alt_names]
IP.1 = ${IP_ADDRESS}
EOF

# Generate the Server Key + CSR
openssl genrsa -out tls.key 4096
openssl req -new -key tls.key -out registry.csr -config server.cnf

# Sign with the CA
openssl x509 -req -in registry.csr \
  -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out tls.crt -days 365 -sha256 \
  -extensions req_ext -extfile server.cnf

# Lastly create the full chain:
cat tls.crt ca.crt > fullchain.pem

cd ..

# Scenario: No registry flags (use bundle, assume internal registry)
echo "No registry flags configured. Using bundle method (skipping local registry installation)."
echo "Creating Management Cluster with bundle..."
echo "  → This will take 10-15 minutes. Progress will be logged to /var/log/nkp-mgmt-cluster-install.log"
echo "  → You can monitor progress in another terminal with: tail -f /var/log/nkp-mgmt-cluster-install.log"
nkp create cluster nutanix \
  --cluster-name=${CLUSTER_NAME} \
  --control-plane-prism-element-cluster=${PC_CONTROL_PLANE_CLUSTER_NAME} \
  --worker-prism-element-cluster=${PC_WORKER_CLUSTER_NAME} \
  --control-plane-subnets=${CONTROL_PLANE_SUBNET} \
  --worker-subnets=${WORKER_SUBNET} \
  --control-plane-endpoint-ip=${CONTROLPLANE_VIP} \
  --csi-storage-container=${STORAGE_CONTAINER} \
  --endpoint=${NUTANIX_ENDPOINT} \
  --control-plane-vm-image=${IMAGE} \
  --worker-vm-image=${IMAGE} \
  --kubernetes-service-load-balancer-ip-range=${LB_IP_RANGE} \
  --ssh-username=${SSH_USERNAME} \
  --ssh-public-key-file=${SSH_PUBLIC_KEY} \
  --bundle="${NKP_BUNDLE_PATH}" \
  --insecure=true \
  --self-managed \
  --airgapped=${AIRGAPPED:-false} \
  --worker-replicas=3 \
  --worker-vcpus=16 \
  --worker-memory=24 \
  --ingress-ca=./nkp-cert/ca.crt \
  --ingress-certificate=./nkp-cert/fullchain.pem \
  --ingress-private-key=./nkp-cert/tls.key \
  --cluster-hostname=${IP_ADDRESS}

# --insecure is for Prism Central to not check the CA cert
# --self-managed is the flag to tell NKP this is a management cluster and not a workload cluster

echo "Setting kubeconfig as default (safely)..."
mkdir -p ${HOME}/.kube
mkdir -p ${HOME}/${CLUSTER_NAME}
cat ${CLUSTER_NAME}.conf >> ${HOME}/.kube/config
kx ${CLUSTER_NAME} # Switch to the new cluster

# Validate Kommander is installed properly (for cloud-init logs).
kubectl -n kommander wait --for condition=Ready helmreleases --all --timeout 15m

# Get the URL and default creds to Kommander and store in the cluster folder.
nkp get dashboard --kubeconfig=${CLUSTER_NAME}.conf > ${HOME}/${CLUSTER_NAME}/kommander.txt

# Pro Tip: To rotate the creds:
# nkp experimental rotate dashboard-password

 echo "=== NKP Management Cluster Installation Complete ==="