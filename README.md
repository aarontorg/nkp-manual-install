Mainly to collect files used during manual install of NKP

1. Create new Ubuntu OS image in Prism Central: https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
2. Add nkp-base image to prism central
    - Got to: https://portal.nutanix.com/page/downloads?product=nkp
    - Select "NKP Operating Sytems Images" in the top drop down
    - Filter by the desired NKP version
    - Look for "NKP Node OS Image (Ubuntu Linux 24.04 - CIS Hardened) for AHV
    - Click the dots on the right and select Copy download link
    - Go to prism central and create the image from the copied ULR (it is time limited so you may have to get a new link if it expires)
3. Create Jumpbox VM, use the Ubuntu image created in step 1
4. Follow Jumpbox setup instructions
    - Bundle url: https://portal.nutanix.com/page/downloads?product=nkp
5. Modify variables in env.vars file
6. Run nkp-mgmt-install.sh script