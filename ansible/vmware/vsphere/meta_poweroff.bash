#!/bin/bash
#
# 
source `which virtualenvwrapper.sh`
workon ansible5.8.0
TEST=`which termdown`
if [ $? = 1 ]; then
	echo "installing termdown"
	pip install termdown
fi

echo "Shut down k8s lab"
sleep 5
ansible-playbook poweroff_k8slabs.yml
termdown 2m

echo "Put hosts into maintenance mode for vsan..."
sleep 5
ansible-playbook put_esxi_to_maintenance_mode_vsan.yml
termdown 2m

echo "Power off vCenter aka vcsa..."
sleep 5
ansible-playbook poweroff_vcenter.yml 
termdown 3m --title "vcsa . . ."

echo "Power off esxi hosts..."
sleep 5
ansible-playbook poweroff_esxi_mgmt_hosts.yml

echo "Till next time..."
