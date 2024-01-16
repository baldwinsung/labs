# Packer
Use packer to build the vm template for CentOS 8

# Build the vm template for CentOS 8
```
packer build centos8-template.json 
```

# Notes
ssh to the ESXi host, cd to the datastore directory and run wget to download the iso
wait25 in the boot command is to skip the cdrom check
time to build the vm template is about 14 minutes

# Credit
Credit to https://github.com/guillermo-musumeci/packer-vsphere-iso-linux for CentOS 7 template

