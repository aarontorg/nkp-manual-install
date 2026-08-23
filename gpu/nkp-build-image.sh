nkp create image nutanix rhel-8.10 \
  --cluster "Prism-Element-Cluster-01" \
  --endpoint "https://10.40.10.50:9440" \
  --subnet "VLAN_100_NKP_Provisioning" \
  --source-image "https://example.com" \
  --bundle "nkp-image-builder-bundle-v2.17.1.tar" \
  --gpu-name "NVIDIA-A100-PCIE-80GB" \
  --overrides gpu-overrides.yaml