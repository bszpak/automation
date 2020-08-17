#!/bin/bash
# Modify necessary file(s) to avoid getting hung at user input for `sensors-detect` command
echo "INFO: Modifying necessary file(s) to bypass 'sensors-detect' command."

### ANALOGOUT ###
if [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "centos7" ]; then
    exit 0

elif [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "precise" ]; then
    echo "INFO: Modifying $bamboo_PRODUCT/fabfile.py"
    ssh -T -o StrictHostKeyChecking=no "$bamboo_U12_SSH" "sed -i '/sensors-detect/ s/^/#/' ~/vada/$bamboo_PRODUCT/fabfile.py"

### BURNIN ###
elif [ "$bamboo_PRODUCT" = "burnin" ]; then
    exit 0

### DIGISTREAM ###
elif [ "$bamboo_PRODUCT" = "digistream" ] && [ "$bamboo_DISTRO" = "centos7" ]; then
    exit 0
elif [ "$bamboo_PRODUCT" = "digistream" ] && [ "$bamboo_DISTRO" = "precise" ]; then
    echo "INFO: Modifying $bamboo_PRODUCT/fabfile.py"
    ssh -T -o StrictHostKeyChecking=no "$bamboo_U12_SSH" "sed -i '/sensors-detect/ s/^/#/' ~/vada/$bamboo_PRODUCT/fabfile.py"

### EPGDATA ###
elif [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "centos7" ]; then
    exit 0
elif [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "precise" ]; then
    echo "INFO: Modifying $bamboo_PRODUCT/fabfile.py"
    ssh -T -o StrictHostKeyChecking=no "$bamboo_U12_SSH" "sed -i '/sensors-detect/ s/^/#/' ~/vada/$bamboo_PRODUCT/fabfile.py"

### IP2AV3 ###
elif [ "$bamboo_PRODUCT" = "ip2av3" ]; then
    echo "INFO: Modifying encprofile/basefab.py"
    ssh -T -o StrictHostKeyChecking=no "$bamboo_U12_SSH" "sed -i '/sensors-detect/ s/^/#/' ~/vada/encprofile/encprofile/basefab.py"
    
### IP2AV4 ###
elif [ "$bamboo_PRODUCT" = "ip2av4" ]; then
    exit 0
    
else
    echo "ERROR: Failed bypassing sensors on build-target machine. Please check your variable settings."
    exit 1
fi
