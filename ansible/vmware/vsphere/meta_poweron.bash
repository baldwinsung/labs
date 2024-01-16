#!/bin/bash
#
# physically power on mac minis before running this
# 
source `which virtualenvwrapper.sh`
workon ansible5.8.0
TEST=`which termdown`
if [ $? = 1 ]; then
	echo "installing termdown"
	pip install termdown
fi

echo "Power on vCenter aka vcsa. Usually takes about 10 minutes for vcsa to complete the startup process..."
if [ $TERM_PROGRAM = "Apple_Terminal" ]; then
	say "Power on vCenter aka v c s a . Usually takes about 10 minutes for vcsa to complete the startup process..."
fi
sleep 5
ansible-playbook poweron_vcenter.yml
termdown 10m --title "vcsa . . ."

echo "Remove hosts out of maintenance mode for vsan..."
sleep 5
ansible-playbook out_esxi_maintenance_mode.yml
termdown 5m --title "vsan . . ."

echo "Startup k8s lab"
sleep 5
ansible-playbook poweron_k8slab.yml
