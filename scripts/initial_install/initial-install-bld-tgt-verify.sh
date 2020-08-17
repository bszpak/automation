#!/bin/bash
# Rollback VM to specific snapshot or start Docker container

ANALOGOUT_C7=200
ANALOGOUT_U12=201
BURNIN=202
DIGISTREAM=203
EPGDATA_C7=204
EPGDATA_U12=205
IP2AV4=206
IP2AV3=207

SNAP1="starting_point"
SNAP2="ready_for_initial_install"

### ANALOGOUT ###
if [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "centos7" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        ssh -T -o StrictHostKeyChecking=no $bamboo_C7_BUILD_SERVER bash -c "'
            source /vagrant/vada-env/bin/activate
            cd /vagrant/vada/$bamboo_PRODUCT && ./docker-dev/start-dev.py
            '"
    else
        # Rollback VM to specific snapshot
        ssh -T -o StrictHostKeyChecking=no $bamboo_PROXMOX "qm rollback $ANALOGOUT_C7 $SNAP1"
    fi
    
elif [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "precise" ]; then
    ssh -T -o StrictHostKeyChecking=no $bamboo_PROXMOX "qm rollback $ANALOGOUT_U12 $SNAP2"

### BURNIN ###
elif [ "$bamboo_PRODUCT" = "burnin" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        ssh -T -o StrictHostKeyChecking=no $bamboo_C7_BUILD_SERVER bash -c "'
            source /vagrant/vada-env/bin/activate
            cd /vagrant/vada/$bamboo_PRODUCT && ./docker-dev/start-dev.py
            '"
    elif [ ! -z "$bamboo_TARGET_IP" ]; then
        exit 0
    elif [ -z "$bamboo_TARGET_IP" ]; then
        echo "INFO: Rollback VM to specific snapshot"
        ssh -T -o StrictHostKeyChecking=no $bamboo_PROXMOX "qm rollback $BURNIN $SNAP2"
    fi

### DIGISTREAM ###
#TODO: when time permits

### EPGDATA ###
elif [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "centos7" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        ssh -T -o StrictHostKeyChecking=no $bamboo_C7_BUILD_SERVER bash -c "'
            source /vagrant/vada-env/bin/activate
            cd /vagrant/vada/$bamboo_PRODUCT && ./docker-dev/start-dev.py
            '"
    else
        # Rollback VM to specific snapshot
        ssh -T -o StrictHostKeyChecking=no $bamboo_PROXMOX "qm rollback $EPGDATA_C7 $SNAP2"
    fi
    
elif [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "precise" ]; then
    ssh -T -o StrictHostKeyChecking=no $bamboo_PROXMOX "qm rollback $EPGDATA_U12 $SNAP2"
    
### IP2AV3 ###
elif [ "$bamboo_PRODUCT" = "ip2av3" ]; then
    ssh -T -o StrictHostKeyChecking=no $bamboo_PROXMOX "qm rollback $IP2AV3 $SNAP2"
    
### IP2AV4 ###
elif [ "$bamboo_PRODUCT" = "ip2av4" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        ssh -T -o StrictHostKeyChecking=no $bamboo_C7_BUILD_SERVER bash -c "'
            source /vagrant/vada-env/bin/activate
            cd /vagrant/vada/$bamboo_PRODUCT && ./docker-dev/start-dev.py
            '"
    else
        # Rollback VM to specific snapshot
        ssh -T -o StrictHostKeyChecking=no $bamboo_PROXMOX "qm rollback $IP2AV4 $SNAP2"
    fi
else
    echo "ERROR: Could not start build-target machine. Please check your variable settings."
    exit 1
fi
