nkp create image nutanix rhel-9.6 \
  --cluster "PHX-POC263" \
  --endpoint "https://10.38.35.7:9440" \
  --subnet "secondary-PHX-POC263" \
  --source-image "rhel-9-x86_64-20260825-1107" \
  --bundle "nkp-image-builder-bundle-v2.17.1.tar" \
  --gpu-name "NVIDIA-A100-PCIE-80GB" \
  --overrides gpu-overrides.yaml
  --vgpu-runfile ? driver [grid]