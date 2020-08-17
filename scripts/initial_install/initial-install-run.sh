#!/bin/bash

### ANALOGOUT ###
if [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "centos7" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        echo "INFO: Performing 'initial_install' on new $bamboo_PRODUCT $bamboo_DISTRO container, this will take a while."
        ssh -T -o StrictHostKeyChecking=no "$bamboo_C7_BUILD_SERVER" bash -c "'
            source /vagrant/vada-env/bin/activate
            cd ~/vada/$bamboo_PRODUCT
            ./docker-fab.sh --disable-known-hosts --sudo-password=$bamboo_SECRETPW_ANALOGOUT initial_install
            '"
    else
        echo "INFO: Performing 'initial_install' on $bamboo_PRODUCT $bamboo_DISTRO VM, this will take a while."
        if [ ! -z "$bamboo_TARGET_IP" ]; then
            TARGET="$bamboo_TARGET_IP"
        elif [ -z "$bamboo_TARGET_IP" ]; then
            TARGET=10.1.1.40
        fi
        ssh -T -o StrictHostKeyChecking=no "$bamboo_C7_BUILD_SERVER" bash -c "'
            source /vagrant/vada-env/bin/activate
            cd /vagrant/vada/$bamboo_PRODUCT
            export TARGET_OS=centos7
            export DJANGO_SETTINGS_MODULE=$bamboo_PRODUCT.settings
            fab -H $TARGET --disable-known-hosts --sudo-password=$bamboo_SECRETPW_ANALOGOUT initial_install
            '"
    fi
elif [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "precise" ]; then
    if [ ! -z "$bamboo_TARGET_IP" ]; then
        TARGET="$bamboo_TARGET_IP"
    elif [ -z "$bamboo_TARGET_IP" ]; then
        TARGET=10.1.1.41
    fi
    echo "INFO: Performing 'initial_install' on $bamboo_PRODUCT $bamboo_DISTRO VM, this will take a while."
    ssh -T -o StrictHostKeyChecking=no "$bamboo_U12_BUILD_SERVER" bash -c "'
        # Clean up old container ECDSA key fingerprint in .ssh/known_hosts and bypass new

        sed -i '/$TARGET*/d' ~/.ssh/known_hosts
        ssh -o StrictHostKeyChecking=no $bamboo_PRODUCT@$TARGET 'exit'
    
        source /vagrant/vada-env/bin/activate
        cd /vagrant/vada/$bamboo_PRODUCT
        export DEFAULT_SKU=$bamboo_PRODUCT
        fab -H $TARGET --disable-known-hosts --sudo-password=$bamboo_SECRETPW_ANALOGOUT initial_install
        '"

### BURNIN ###
elif [ "$bamboo_PRODUCT" = "burnin" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        echo "INFO: Performing 'initial_install' on new $bamboo_PRODUCT $bamboo_DISTRO container, this will take a while."
        ssh -T -o StrictHostKeyChecking=no "$bamboo_C7_BUILD_SERVER" bash -c "'
            sed -i '/172.17*/d' ~/.ssh/known_hosts
            source /vagrant/vada-env/bin/activate
            cd ~/vada/$bamboo_PRODUCT
            ./docker-dev/start-dev.py | tail -n1 > docker-ip.txt
            scp -o StrictHostKeyChecking=no docker-ip.txt $bamboo_BAMBOO_VM:/${bamboo.build.working.directory}/
            '"
        HOST=$(cat docker-ip.txt)
    
        ssh -T -o StrictHostKeyChecking=no "$bamboo_C7_BUILD_SERVER" bash -c "'
            ssh -o StrictHostKeyChecking=no $bamboo_PRODUCT@$HOST 'exit'
            source /vagrant/vada-env/bin/activate
            cd ~/vada/$bamboo_PRODUCT
            ./docker-fab.sh --disable-known-hosts --sudo-password=$bamboo_SECRETPW_BURNIN initial_install
            '"
    else
        echo "INFO: Performing 'initial_install' on $bamboo_PRODUCT $bamboo_DISTRO VM, this will take a while."
        if [ ! -z "$bamboo_TARGET_IP" ]; then
            TARGET="$bamboo_TARGET_IP"
        elif [ -z "$bamboo_TARGET_IP" ]; then
            TARGET=10.1.1.42
        fi
        ssh -T -o StrictHostKeyChecking=no "$bamboo_C7_BUILD_SERVER" bash -c "'
            source /vagrant/vada-env/bin/activate
            cd /vagrant/vada/$bamboo_PRODUCT
            export TARGET_OS=centos7
            export DJANGO_SETTINGS_MODULE=$bamboo_PRODUCT.settings
            fab -H $TARGET --disable-known-hosts --sudo-password=$bamboo_SECRETPW_BURNIN initial_install
            '"
    fi

### DIGISTREAM ###
elif [ "$bamboo_PRODUCT" = "digistream" ] && [ "$bamboo_DISTRO" = "precise" ]; then
    echo "INFO: Performing 'initial_install' on $bamboo_PRODUCT $bamboo_DISTRO VM, this will take a while."
    if [ ! -z "$bamboo_TARGET_IP" ]; then
        TARGET="$bamboo_TARGET_IP"
    elif [ -z "$bamboo_TARGET_IP" ]; then
        TARGET=10.1.1.43
    fi
    ssh -T -o StrictHostKeyChecking=no "$bamboo_U12_BUILD_SERVER" bash -c "'
        # Clean up old container ECDSA key fingerprint in .ssh/known_hosts and bypass new

        sed -i '/$TARGET*/d' ~/.ssh/known_hosts
        ssh -o StrictHostKeyChecking=no digistream@$TARGET 'exit'
    
        source /vagrant/vada-env/bin/activate
        cd /vagrant/vada/$bamboo_PRODUCT
        export INIT_SYSTEM=sysv
        export DJANGO_SETTINGS_MODULE=$bamboo_PRODUCT.settings
        fab -H $TARGET --disable-known-hosts --sudo-password=$bamboo_SECRETPW_DIGISTREAM initial_install
        '"

### EPGDATA ###
elif [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "centos7" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        echo "INFO: Performing 'initial_install' on $bamboo_PRODUCT $bamboo_DISTRO container, this will take a while."
        ssh -t -o StrictHostKeyChecking=no "$bamboo_C7_BUILD_SERVER" <<-EOSSH
            source /vagrant/vada-env/bin/activate
            cd ~/vada/"$bamboo_PRODUCT"
            export PASS="$bamboo_SECRETPW_EPGDATA"            
            ./docker-fab.sh --disable-known-hosts --sudo-password="{$PASS}" initial_install
EOSSH
    elif [ "$bamboo_INSTALL_ON_DOCKER" = "false" ]; then
        echo "INFO: Performing 'initial_install' on $bamboo_PRODUCT $bamboo_DISTRO VM, this will take a while."
        if [ ! -z "$bamboo_TARGET_IP" ]; then
            TARGET="$bamboo_TARGET_IP"
        elif [ -z "$bamboo_TARGET_IP" ]; then
            TARGET=10.1.1.55
        fi
        ssh -T -o StrictHostKeyChecking=no "$bamboo_C7_BUILD_SERVER" bash -c "'
            source /vagrant/vada-env/bin/activate
            cd /vagrant/vada/$bamboo_PRODUCT
            export TARGET_OS=centos7
            export DJANGO_SETTINGS_MODULE=$bamboo_PRODUCT.settings
            ssh -T -o StrictHostKeyChecking=no digistream@$TARGET "exit"    #To bypass ECDSA host auth check during fab script
            fab -H $TARGET --disable-known-hosts --sudo-password=$bamboo_SECRETPW_EPGDATA initial_install
            '"
    fi
    
elif [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "precise" ]; then
    echo "INFO: Performing 'initial_install' on $bamboo_PRODUCT $bamboo_DISTRO VM, this will take a while."
    if [ ! -z "$bamboo_TARGET_IP" ]; then
        TARGET="$bamboo_TARGET_IP"
    elif [ -z "$bamboo_TARGET_IP" ]; then
        TARGET=10.1.1.45
    fi
    ssh -T -o StrictHostKeyChecking=no "$bamboo_U12_BUILD_SERVER" bash -c "'
        # Clean up old container ECDSA key fingerprint in .ssh/known_hosts and bypass new

        sed -i '/$TARGET*/d' ~/.ssh/known_hosts
        ssh -o StrictHostKeyChecking=no digistream@$TARGET 'exit'
    
        source /vagrant/vada-env/bin/activate
        cd /vagrant/vada/$bamboo_PRODUCT
        export INIT_SYSTEM=sysv
        export DJANGO_SETTINGS_MODULE=$bamboo_PRODUCT.settings
        fab -H $TARGET --disable-known-hosts --sudo-password=$bamboo_SECRETPW_EPGDATA initial_install
        '"
    
### IP2AV3 ###
elif [ "$bamboo_PRODUCT" = "ip2av3" ]; then
    echo "INFO: Performing 'initial_install' on $bamboo_PRODUCT $bamboo_DISTRO VM, this will take a while."
    if [ ! -z "$bamboo_TARGET_IP" ]; then
        TARGET="$bamboo_TARGET_IP"
    elif [ -z "$bamboo_TARGET_IP" ]; then
        TARGET=10.1.1.44
    fi
    ssh -T -o StrictHostKeyChecking=no "$bamboo_U12_BUILD_SERVER" bash -c "'
        # Clean up old container ECDSA key fingerprint in .ssh/known_hosts and bypass new

        sed -i '/$TARGET*/d' ~/.ssh/known_hosts
        ssh -o StrictHostKeyChecking=no $bamboo_PRODUCT@$TARGET 'exit'
    
        source /vagrant/vada-env/bin/activate
        cd /vagrant/vada/$bamboo_PRODUCT
        export INIT_SYSTEM=sysv
        export DJANGO_SETTINGS_MODULE=$bamboo_PRODUCT.settings
        fab -H $TARGET --disable-known-hosts --sudo-password=$bamboo_SECRETPW_IP2AV3 initial_install
        '"
    
### IP2AV4 ###
elif [ "$bamboo_PRODUCT" = "ip2av4" ]; then
    if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
        echo "INFO: Performing 'initial_install' on new $bamboo_PRODUCT container, this will take a while."
        ssh -T -o StrictHostKeyChecking=no "$bamboo_C7_BUILD_SERVER" bash -c "'
            source /vagrant/vada-env/bin/activate
            cd ~/vada/$bamboo_PRODUCT
            ./docker-fab.sh --disable-known-hosts --sudo-password=$bamboo_SECRETPW_IP2AV4 initial_install
            '"
    else
        echo "INFO: Performing 'initial_install' on $bamboo_PRODUCT $bamboo_DISTRO VM, this will take a while."
        if [ ! -z "$bamboo_TARGET_IP" ]; then
            TARGET="$bamboo_TARGET_IP"
        elif [ -z "$bamboo_TARGET_IP" ]; then
            TARGET=10.1.1.54
        fi
        ssh -T -o StrictHostKeyChecking=no "$bamboo_C7_BUILD_SERVER" bash -c "'
            source /vagrant/vada-env/bin/activate
            cd /vagrant/vada/$bamboo_PRODUCT
            export TARGET_OS=centos7
            export DJANGO_SETTINGS_MODULE=$bamboo_PRODUCT.settings
            fab -H $TARGET --disable-known-hosts --sudo-password=$bamboo_SECRETPW_IP2AV4 initial_install
            '"
    fi
else
    echo "ERROR: Could not start 'initial_install'. Please check your variable settings."
    exit 1
fi
