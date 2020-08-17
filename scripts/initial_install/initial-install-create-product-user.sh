#!/bin/bash
# Create Product User if this is an unknown machine
# ===== TODO: Figure out a way to get past secondary sudo prompt and how to pipe in PRODUCT secret PW later on =====

if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
    exit 0
elif [ ! -z "$bamboo_TARGET_USER" ] && [ ! -z "$bamboo_TARGET_IP" ]; then

    # Setup password-less access for target machine atxproduct user
    sshpass -p "$bamboo_AUTO_PASSWORD" ssh-copy-id -i ~/.ssh/id_rsa.pub atxproduct@"$bamboo_TARGET_IP"
    
    # Copy over known-good sudoers file to /home/atxproduct
    scp -o StrictHostKeyChecking=no ${bamboo.build.working.directory}/scripts/sudoers_centos7 \
    atxproduct@"$bamboo_TARGET_IP":~/sudoers_centos7
    
    #TODO: prepare an Ubuntu-based sudoers file for copy
    
    ssh -T -o StrictHostKeyChecking=no atxproduct@"$bamboo_TARGET_IP" <<-EOSSH1
        if id -u "$bamboo_PRODUCT" >/dev/null 2>&1; then     #check if product user already exists
            echo "$bamboo_PRODUCT user already exists, moving on..."
        else
            echo "Creating product user on $bamboo_PRODUCT $bamboo_DISTRO machine @ $bamboo_TARGET_IP."
            echo "$bamboo_AUTO_PASSWORD" | sudo -S adduser "$bamboo_PRODUCT"
            
            if [ "$bamboo_DISTRO" = "centos7" ]; then
                echo "$bamboo_AUTO_PASSWORD" | sudo -S usermod -aG adm "$bamboo_PRODUCT"
                echo "$bamboo_AUTO_PASSWORD" | sudo -S usermod -aG dialout "$bamboo_PRODUCT"
                echo "$bamboo_AUTO_PASSWORD" | sudo -S usermod -aG wheel "$bamboo_PRODUCT"
                
                # Change permissions and move /home/atxproduct/sudoers file as /etc/sudoers_mod
                echo "$bamboo_AUTO_PASSWORD" | sudo -S chown root:root ~/sudoers_centos7
                echo "$bamboo_AUTO_PASSWORD" | sudo -S mv ~/sudoers_centos7 /etc/sudoers_mod
                    
            elif [ "$bamboo_DISTRO" = "precise" ]; then
                echo "$bamboo_AUTO_PASSWORD" | sudo -S usermod -aG sudo "$bamboo_PRODUCT"
                echo "$bamboo_AUTO_PASSWORD" | sudo -S usermod -aG plugdev "$bamboo_PRODUCT"
                echo "$bamboo_AUTO_PASSWORD" | sudo -S usermod -aG frontend "$bamboo_PRODUCT"
                echo "$bamboo_AUTO_PASSWORD" | sudo -S usermod -aG www-data "$bamboo_PRODUCT"
                
                # TODO: Change permissions and move /home/atxproduct/sudoers file as /etc/sudoers for Ubuntu systems
                #echo "$bamboo_AUTO_PASSWORD" | sudo -S chown root:root ~/sudoers_centos7
                #echo "$bamboo_AUTO_PASSWORD" | sudo -S mv ~/sudoers_centos7 /etc/sudoers
            fi
            echo "$bamboo_AUTO_PASSWORD" | sudo -S chown --reference=/etc/sudoers /etc/sudoers_mod
            echo "$bamboo_AUTO_PASSWORD" | sudo -S chmod --reference=/etc/sudoers /etc/sudoers_mod
            echo "$bamboo_AUTO_PASSWORD" | sudo -S visudo -c -f /etc/sudoers_mod
            echo "$bamboo_AUTO_PASSWORD" | sudo -S mv /etc/sudoers_mod /etc/sudoers
            
            # Create .ssh directory if not present
            echo "$bamboo_AUTO_PASSWORD" | sudo -S mkdir /home/"$bamboo_PRODUCT"/.ssh
        fi
EOSSH1

    # Copy over authorized_keys file  
    if \
    [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "centos7" ] || \
    [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "centos7" ] || \
    [ "$bamboo_PRODUCT" = "burnin" ] || \
    [ "$bamboo_PRODUCT" = "ip2av4" ]; then
        echo "$bamboo_AUTO_PASSWORD" | sudo -S scp -o StrictHostKeyChecking=no "$bamboo_C7_BUILD_SERVER":/home/vagrant/vada/atxstyle/common-config/home/.ssh/authorized_keys \
        atxproduct@"$bamboo_TARGET_IP":/home/"$bamboo_PRODUCT"/.ssh/
    elif \
    [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "precise" ] || \
    [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "precise" ] || \
    [ "$bamboo_PRODUCT" = "ip2av3" ] || \
    [ "$bamboo_PRODUCT" = "digistream" ]; then
        echo "$bamboo_AUTO_PASSWORD" | sudo -S scp -o StrictHostKeyChecking=no "$bamboo_U12_BUILD_SERVER":/home/vagrant/vada/atxstyle/common-config/home/.ssh/authorized_keys \
        atxproduct@"$bamboo_TARGET_IP":/home/"$bamboo_PRODUCT"/.ssh/
    fi
    
    ssh -T -o StrictHostKeyChecking=no atxproduct@"$bamboo_TARGET_IP" <<-EOSSH2
        # Set final permissions
        echo "$bamboo_AUTO_PASSWORD" | sudo -S chown -R "$bamboo_PRODUCT":"$bamboo_PRODUCT" /home/"$bamboo_PRODUCT"/.ssh
        echo "$bamboo_AUTO_PASSWORD" | sudo -S chmod 0700 /home/"$bamboo_PRODUCT"/.ssh
        echo "$bamboo_AUTO_PASSWORD" | sudo -S restorecon -iR /home
            
        # Set sudo product password
        if [ "$bamboo_PRODUCT" = "analogout" ]; then
            echo "$bamboo_PRODUCT":"$bamboo_SECRETPW_ANALOGOUT" | sudo -S chpasswd "$bamboo_PRODUCT"
        elif [ "$bamboo_PRODUCT" = "epgdata" ]; then
            echo "$bamboo_PRODUCT":"$bamboo_SECRETPW_EPGDATA" | sudo -S chpasswd "$bamboo_PRODUCT"
        elif [ "$bamboo_PRODUCT" = "burnin" ]; then
            echo "Setting sudo product password"
            echo "$bamboo_PRODUCT":"$bamboo_SECRETPW_BURNIN" | sudo -S chpasswd "$bamboo_PRODUCT"
        elif [ "$bamboo_PRODUCT" = "ip2av3" ]; then
            echo "\"$bamboo_PRODUCT\":\"$bamboo_SECRETPW_IP2AV3\"" | sudo -S chpasswd "$bamboo_PRODUCT"
        elif [ "$bamboo_PRODUCT" = "ip2av4" ]; then
            echo "$bamboo_PRODUCT":"$bamboo_SECRETPW_IP2AV4" | sudo -S chpasswd "$bamboo_PRODUCT"
        fi
EOSSH2
echo "'create_product_user' task completed."
else
    echo "ERROR: Either invalid TARGET_IP or TARGET_USER entered."
    exit 1
fi
