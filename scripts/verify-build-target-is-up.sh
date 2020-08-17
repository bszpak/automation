#!/bin/bash

source basefunctions.conf

if [[ ${bamboo_OS} = 'bionic' ]] || [[ ${bamboo_PRODUCT} = 'passport' ]]; then
    ssh_into_bionic <<EOF1
	set -e
	cd ~/vada/passport/qemu-cloud
	if echo "$bamboo_AUTO_PASSWORD" | sudo -S ./run-qemu.sh; then
            echo '### INFO: qemu-vm starting... please wait.'
    	else
            echo '### INFO: qemu-vm already running, moving on...'
        fi
EOF1
exit 0
fi

ssh -T "$bamboo_PROXMOX" "qm start $VMID"
if [ $? -eq 0 ]; then
    echo "### INFO: Target-VM starting... please wait."
    sleep 30
elif [ $? -eq 255 ]; then
    exit 0
fi

# Rollback VM to specific snapshot
if [ "$ROLLBACK" ]; then
    if [ "$SNAP1" ]; then
        echo "### INFO: Rolling back to Snapshot: '${SNAP1}'"
        ssh -T "$bamboo_PROXMOX" "qm rollback $VMID $SNAP1"
    elif [ "$SNAP2" ]; then
        echo "### INFO: Rolling back to Snapshot: '${SNAP2}'"
        ssh -T "$bamboo_PROXMOX" "qm rollback $VMID $SNAP2"
    elif [ "$SNAP3" ]; then
        echo "### INFO: Rolling back to Snapshot: '${SNAP3}'"
        ssh -T "$bamboo_PROXMOX" "qm rollback $VMID $SNAP3"
    fi
fi
