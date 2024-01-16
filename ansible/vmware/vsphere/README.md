# Ansible Playbooks for vSphere homelab

## Startup
Manually power on ESXi hosts. Once ESXi is running. Poweron the vCenter vm and then the k8slab vms using the playbooks. Use meta_poweron.bash. 

```
meta_poweron.bash
```

## Shutdown
Poweroff the k8slab vms and then vCenter vm using the playbooks. Once VMs are all down. Poweroff ESXi using the playbook. Use meta_poweroff.bash.

```
meta_poweroff.bash
```
