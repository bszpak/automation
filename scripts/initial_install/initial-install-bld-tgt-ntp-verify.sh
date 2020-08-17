#!/bin/bash
# Verify date/time on build-target machine is current

### ANALOGOUT ###
if [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "centos7" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        echo "INFO: NTP sync'ing for $bamboo_PRODUCT $bamboo_DISTRO container not required, moving on..."
        exit 0
    elif [ "$bamboo_INSTALL_ON_DOCKER" = "false" ]; then    # means we're installing on a VM
        if [ ! -z "$bamboo_TARGET_IP" ]; then
            TARGET="$bamboo_TARGET_IP"
        elif [ -z "$bamboo_TARGET_IP" ]; then
            TARGET=10.1.1.40
        fi
        ssh -T -o StrictHostKeyChecking=no "$bamboo_PRODUCT"@"$TARGET" bash -c "'
            echo $bamboo_SECRETPW_ANALOGOUT | sudo -S yum install -y ntp
            echo $bamboo_SECRETPW_ANALOGOUT | sudo -S systemctl start ntpd.service
#            echo $bamboo_SECRETPW_ANALOGOUT | sudo -S ntpdate pool.ntp.org
#            echo $bamboo_SECRETPW_ANALOGOUT | sudo -S systemctl start ntpd.service
            '"
    fi
elif [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "precise" ]; then
    if [ ! -z "$bamboo_TARGET_IP" ]; then
        TARGET="$bamboo_TARGET_IP"
    elif [ -z "$bamboo_TARGET_IP" ]; then
        TARGET=10.1.1.41
    fi
    ssh -T -o StrictHostKeyChecking=no "$bamboo_PRODUCT"@"$TARGET" bash -c "'
        echo $bamboo_SECRETPW_ANALOGOUT | sudo -S apt-get install -y ntp
        echo $bamboo_SECRETPW_ANALOGOUT | sudo -S service ntp stop
        echo $bamboo_SECRETPW_ANALOGOUT | sudo -S ntpdate-debian
        echo $bamboo_SECRETPW_ANALOGOUT | sudo -S service ntp start
        '"

### BURNIN ###
elif [ "$bamboo_PRODUCT" = "burnin" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        echo "INFO: NTP sync'ing for $bamboo_PRODUCT $bamboo_DISTRO container not required, moving on..."
        exit 0
    elif [ "$bamboo_INSTALL_ON_DOCKER" = "false" ]; then    # means we're installing on a VM
        if [ ! -z "$bamboo_TARGET_IP" ]; then
            TARGET="$bamboo_TARGET_IP"
        elif [ -z "$bamboo_TARGET_IP" ]; then
            TARGET=10.1.1.42
        fi
        ssh -T -o StrictHostKeyChecking=no "$bamboo_PRODUCT"@"$TARGET" bash -c "'
            echo $bamboo_SECRETPW_BURNIN | sudo -S yum install -y ntp
            echo $bamboo_SECRETPW_BURNIN | sudo -S systemctl start ntpd.service
#            echo $bamboo_AUTO_PASSWORD | sudo -S ntpdate pool.ntp.org
#            echo $bamboo_AUTO_PASSWORD | sudo -S systemctl start ntpd.service
            '"
    fi

### DIGISTREAM ###
elif [ "$bamboo_PRODUCT" = "digistream" ] && [ "$bamboo_DISTRO" = "precise" ]; then   # means we're installing on a precise VM
        if [ ! -z "$bamboo_TARGET_IP" ]; then
            TARGET="$bamboo_TARGET_IP"
        elif [ -z "$bamboo_TARGET_IP" ]; then
            TARGET=10.1.1.43
        fi
        ssh -T -o StrictHostKeyChecking=no digistream@"$TARGET" bash -c "'
            echo $bamboo_SECRETPW_EPGDATA | sudo -S apt-get install -y ntp
            echo $bamboo_SECRETPW_EPGDATA | sudo -S service ntp stop
            echo $bamboo_SECRETPW_EPGDATA | sudo -S ntpdate-debian
            echo $bamboo_SECRETPW_EPGDATA | sudo -S service ntp start
            '"

### EPGDATA ###
elif [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "centos7" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        echo "INFO: NTP sync'ing for $bamboo_PRODUCT $bamboo_DISTRO container not required, moving on..."
        exit 0
    elif [ "$bamboo_INSTALL_ON_DOCKER" = "false" ]; then    # means we're installing on a centos7 VM
        if [ ! -z "$bamboo_TARGET_IP" ]; then
            TARGET="$bamboo_TARGET_IP"
        elif [ -z "$bamboo_TARGET_IP" ]; then
            TARGET=10.1.1.55
        fi
        ssh -T -o StrictHostKeyChecking=no digistream@"$TARGET" bash -c "'
#            echo $bamboo_SECRETPW_EPGDATA | sudo -S yum install -y ntp
            echo $bamboo_SECRETPW_EPGDATA | sudo -S systemctl stop ntpd.service
            echo $bamboo_SECRETPW_EPGDATA | sudo -S ntpdate pool.ntp.org
            echo $bamboo_SECRETPW_EPGDATA | sudo -S systemctl start ntpd.service
            '"
    fi
elif [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "precise" ]; then   # means we're installing on a precise VM
        if [ ! -z "$bamboo_TARGET_IP" ]; then
            TARGET="$bamboo_TARGET_IP"
        elif [ -z "$bamboo_TARGET_IP" ]; then
            TARGET=10.1.1.45
        fi
        ssh -T -o StrictHostKeyChecking=no digistream@"$TARGET" bash -c "'
            echo $bamboo_SECRETPW_EPGDATA | sudo -S apt-get install -y ntp
            echo $bamboo_SECRETPW_EPGDATA | sudo -S service ntp stop
            echo $bamboo_SECRETPW_EPGDATA | sudo -S ntpdate-debian
            echo $bamboo_SECRETPW_EPGDATA | sudo -S service ntp start
            '"
    
### IP2AV3 ###
elif [ "$bamboo_PRODUCT" = "ip2av3" ]; then
    if [ ! -z "$bamboo_TARGET_IP" ]; then
        TARGET="$bamboo_TARGET_IP"
    elif [ -z "$bamboo_TARGET_IP" ]; then
        TARGET=10.1.1.44
    fi
    ssh -T -o StrictHostKeyChecking=no "$bamboo_PRODUCT"@"$TARGET" bash -c "'
        echo $bamboo_SECRETPW_IP2AV3 | sudo -S apt-get install -y ntp
        echo $bamboo_SECRETPW_IP2AV3 | sudo -S service ntp stop
        echo $bamboo_SECRETPW_IP2AV3 | sudo -S ntpdate-debian
        echo $bamboo_SECRETPW_IP2AV3 | sudo -S service ntp start
        '"
    
### IP2AV4 ###
elif [ "$bamboo_PRODUCT" = "ip2av4" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        echo "INFO: NTP sync'ing for $bamboo_PRODUCT container not required, moving on..."
        exit 0
    elif [ "$bamboo_INSTALL_ON_DOCKER" = "false" ]; then    # means we're installing on a VM
        if [ ! -z "$bamboo_TARGET_IP" ]; then
            TARGET="$bamboo_TARGET_IP"
        elif [ -z "$bamboo_TARGET_IP" ]; then
            TARGET=10.1.1.54
        fi
        ssh -T -o StrictHostKeyChecking=no "$bamboo_PRODUCT"@"$TARGET" bash -c "'
            echo $bamboo_SECRETPW_IP2AV4 | sudo -S systemctl stop ntpd.service
            echo $bamboo_SECRETPW_IP2AV4 | sudo -S ntpdate pool.ntp.org
            echo $bamboo_SECRETPW_IP2AV4 | sudo -S systemctl start ntpd.service
            sleep 5
            '"
    fi
else
    echo "ERROR: Could not verify NTP on build-target machine. Please check your variable settings."
    exit 1
fi
