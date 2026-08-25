#! /bin/bash

# # Handle different registry scenarios. 
# if [ -n "${REGISTRY_FLAGS:-}" ] && [ -n "${REGISTRY_MIRROR_FLAGS:-}" ]; then
#   echo "REGISTRY_* detected."
#   # Scenario: Using REGISTRY_FLAGS (primary registry)
  
#   if [ "${LOCAL_REGISTRY_INSTALL:-}" = true ]; then
#     echo "Installing local registry..."
#     if ! bash ${HOME}/scripts/harbor-install.sh; then
#       echo "ERROR: Harbor installation failed!" >&2
#       exit 1
#     fi
#   fi

  # echo "Creating Management Cluster with REGISTRY_FLAGS..."
  # echo "  → This will take 10-15 minutes. Progress will be logged to /var/log/nkp-mgmt-cluster-install.log"
  # echo "  → You can monitor progress in another terminal with: tail -f /var/log/nkp-mgmt-cluster-install.log"
  # nkp create cluster nutanix \
  #   --cluster-name=${CLUSTER_NAME} \
  #   --control-plane-prism-element-cluster=${PC_CONTROL_PLANE_CLUSTER_NAME} \
  #   --worker-prism-element-cluster=${PC_WORKER_CLUSTER_NAME} \
  #   --control-plane-subnets=${CONTROL_PLANE_SUBNET} \
  #   --worker-subnets=${WORKER_SUBNET} \
  #   --control-plane-endpoint-ip=${CONTROLPLANE_VIP} \
  #   --csi-storage-container=${STORAGE_CONTAINER} \
  #   --endpoint=${NUTANIX_ENDPOINT} \
  #   --control-plane-vm-image=${IMAGE} \
  #   --worker-vm-image=${IMAGE} \
  #   --kubernetes-service-load-balancer-ip-range=${LB_IP_RANGE} \
  #   --ssh-username=${SSH_USERNAME} \
  #   --ssh-public-key-file=${SSH_PUBLIC_KEY} \
  #   ${REGISTRY_FLAGS} \
  #   ${REGISTRY_MIRROR_FLAGS} \
  #   --insecure=true \
  #   --self-managed

# elif [ -n "${REGISTRY_MIRROR_FLAGS:-}" ]; then
#   # Scenario: Using REGISTRY_MIRROR_FLAGS (mirror registry)
#   echo "REGISTRY_MIRROR_FLAGS detected."
  
#   if [ -n "${LOCAL_REGISTRY_INSTALL:-}" ] && [ "${LOCAL_REGISTRY_INSTALL:-}" = true ]; then
#     echo "Installing local registry..."
#     if ! bash ${HOME}/scripts/harbor-install.sh; then
#       echo "ERROR: Harbor installation failed!" >&2
#       exit 1
#     fi
#   fi

  # echo "Creating Management Cluster with REGISTRY_MIRROR_FLAGS..."
  # echo "  → This will take 10-15 minutes. Progress will be logged to /var/log/nkp-mgmt-cluster-install.log"
  # echo "  → You can monitor progress in another terminal with: tail -f /var/log/nkp-mgmt-cluster-install.log"
  # nkp create cluster nutanix \
  #   --cluster-name=${CLUSTER_NAME} \
  #   --control-plane-prism-element-cluster=${PC_CONTROL_PLANE_CLUSTER_NAME} \
  #   --worker-prism-element-cluster=${PC_WORKER_CLUSTER_NAME} \
  #   --control-plane-subnets=${CONTROL_PLANE_SUBNET} \
  #   --worker-subnets=${WORKER_SUBNET} \
  #   --control-plane-endpoint-ip=${CONTROLPLANE_VIP} \
  #   --csi-storage-container=${STORAGE_CONTAINER} \
  #   --endpoint=${NUTANIX_ENDPOINT} \
  #   --control-plane-vm-image=${IMAGE} \
  #   --worker-vm-image=${IMAGE} \
  #   --kubernetes-service-load-balancer-ip-range=${LB_IP_RANGE} \
  #   --ssh-username=${SSH_USERNAME} \
  #   --ssh-public-key-file=${SSH_PUBLIC_KEY} \
  #   ${REGISTRY_MIRROR_FLAGS} \
  #   --insecure=true \
  #   --self-managed \
  #   --airgapped=${AIRGAPPED:-false}

# elif [ -n "${REGISTRY_FLAGS:-}" ]; then
#   echo "REGISTRY_FLAGS detected."
#   echo "Creating Management Cluster with REGISTRY_FLAGS..."
#   echo "  → This will take 10-15 minutes. Progress will be logged to /var/log/nkp-mgmt-cluster-install.log"
#   echo "  → You can monitor progress in another terminal with: tail -f /var/log/nkp-mgmt-cluster-install.log"
#   nkp create cluster nutanix \
#     --cluster-name=${CLUSTER_NAME} \
#     --control-plane-prism-element-cluster=${PC_CONTROL_PLANE_CLUSTER_NAME} \
#     --worker-prism-element-cluster=${PC_WORKER_CLUSTER_NAME} \
#     --control-plane-subnets=${CONTROL_PLANE_SUBNET} \
#     --worker-subnets=${WORKER_SUBNET} \
#     --control-plane-endpoint-ip=${CONTROLPLANE_VIP} \
#     --csi-storage-container=${STORAGE_CONTAINER} \
#     --endpoint=${NUTANIX_ENDPOINT} \
#     --control-plane-vm-image=${IMAGE} \
#     --worker-vm-image=${IMAGE} \
#     --kubernetes-service-load-balancer-ip-range=${LB_IP_RANGE} \
#     --ssh-username=${SSH_USERNAME} \
#     --ssh-public-key-file=${SSH_PUBLIC_KEY} \
#     ${REGISTRY_FLAGS} \
#     --insecure=true \
#     --self-managed \
#     --airgapped=${AIRGAPPED:-false}
# else