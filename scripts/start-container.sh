#!/bin/bash

source basefunctions.conf

#Precise
if [[ ${bamboo_OS} = 'precise' ]]; then
    ssh_into_ciserver <<EOF1
        echo "### INFO: Starting \"${bamboo_OS}\" build server ..."
        set -e
        cd ~/vm/${bamboo_U12_NAME}
        vagrant up
EOF1

#Bionic
elif [[ ${bamboo_OS} = 'bionic' ]] || [[ ${bamboo_PRODUCT} = 'passport' ]]; then
    # Start VM
    ssh -T "$bamboo_PROXMOX" "qm start $VMID"
    if [ $? -eq 0 ]; then
        echo "### INFO: Target-VM starting... please wait."
        sleep 30
    elif [ $? -eq 255 ]; then
        exit 0
    fi

    # Rollback VM to specific snapshot
    # ssh -T "$bamboo_PROXMOX" "qm rollback $VMID $SNAP2"

#CentOS
else
    ssh_into_ciserver <<EOF2
        echo "### INFO: Build-driver is a docker container ..." 
        if docker ps | grep ${bamboo_CONTAINER_NAME}; then
            echo "### INFO: Container \"${bamboo_CONTAINER_NAME}\" already running, moving on..."
        else
            if docker ps -a | grep ${bamboo_CONTAINER_NAME}; then     # Container may have exited and just needs to be started
                echo "### INFO: Starting container ${bamboo_CONTAINER_NAME} ..."
                docker start ${bamboo_CONTAINER_NAME}
            else                                                    # Container doesn't exist and needs to be instantiated
                echo "### INFO: Running container ${bamboo_CONTAINER_NAME} ..."
                cd ${bamboo_CONTAINER_PATH}/${bamboo_CONTAINER_NAME} && ./run.sh
            fi
        fi
EOF2
fi
