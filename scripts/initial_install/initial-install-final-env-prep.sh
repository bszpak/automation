#!/bin/bash
# Modify any necessary file(s) and/or configuration settings for a smooth "initial_install" run

### ANALOGOUT
echo "INFO: Modifying necessary file(s) to raise minimum file descriptors = 64000 in order for /etc/init.d/supervisor to start"
if [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "centos7" ]; then
    exit 0

elif [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "precise" ]; then
    if [ ! -z "$bamboo_TARGET_IP" ]; then
        TARGET="$bamboo_TARGET_IP"
    elif [ -z "$bamboo_TARGET_IP" ]; then
        TARGET=10.1.1.41
    fi
    ssh -T -o StrictHostKeyChecking=no "$bamboo_PRODUCT"@"$TARGET" <<-EOSSH
        echo "INFO: Modifying /etc/security/limits.conf"
        echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S chmod o+w /etc/security/limits.conf
        echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S echo "*       soft    nofile    64000" >> /etc/security/limits.conf
        echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S echo "*       hard    nofile    64000" >> /etc/security/limits.conf
        echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S echo "root    soft    nofile    64000" >> /etc/security/limits.conf
        echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S echo "root    hard    nofile    64000" >> /etc/security/limits.conf
        
        echo "INFO: Modifying /etc/pam.d/common-session"
        echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S chmod o+w /etc/pam.d/common-session
        echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S echo "session required pam_limits.so" >> /etc/pam.d/common-session
        
        echo "INFO: Modifying /etc/pam.d/common-session-noninteractive"
        echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S chmod o+w /etc/pam.d/common-session-noninteractive
        echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S echo "session required pam_limits.so" >> /etc/pam.d/common-session-noninteractive
EOSSH

### BURNIN
elif [ "$bamboo_PRODUCT" = "burnin" ]; then
    exit 0

### DIGISTREAM
#TODO: when time permits

### EPGDATA
elif [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "centos7" ]; then
    exit 0
elif [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "precise" ]; then
    exit 0

### IP2AV3
elif [ "$bamboo_PRODUCT" = "ip2av3" ]; then
    exit 0
    
### IP2AV4
elif [ "$bamboo_PRODUCT" = "ip2av4" ]; then
    exit 0
    
else
    echo "ERROR: Failed setting final env preparations."
    exit 1
fi
