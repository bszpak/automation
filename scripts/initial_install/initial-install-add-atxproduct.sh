#!/bin/bash
# Add atxproduct user if $bamboo_TARGET_USER is populated
if [ ! -z "$bamboo_TARGET_USER" ] && [ ! -z "$bamboo_TARGET_IP" ]; then
    
    #Setup password-less access for target machine TARGET_USER
    sshpass -p "$bamboo_TARGET_PASSWORD" ssh-copy-id -i ~/.ssh/id_rsa.pub "$bamboo_TARGET_USER"@"$bamboo_TARGET_IP"
    
    ssh -T "$bamboo_TARGET_USER"@"$bamboo_TARGET_IP" <<-EOSSH
        id -u atxproduct >/dev/null 2>&1    #check atxproduct user exists
        if [ $? -ne 0 ]; then              
            # If TARGET_USER is root user
            if [ "$bamboo_TARGET_USER" = "root" ]; then
                adduser atxproduct
                if [ "$bamboo_DISTRO" = "centos7" ]; then
                    usermod -aG wheel atxproduct
                else
                    usermod -aG admin atxproduct
                fi
            
                echo "atxproduct:atxpassword" | chpasswd
                sed -i -e 's|^PasswordAuthentication.*|PasswordAuthentication yes|' /etc/ssh/sshd_config
            
                if [ "$bamboo_DISTRO" = "centos7" ]; then
                    systemctl restart sshd
                else
                    service ssh restart
                fi
                
            # If TARGET_USER is non-root user
            elif [ "$bamboo_TARGET_USER" != "root" ]; then
                echo "$bamboo_TARGET_PASSWORD" | sudo -S adduser atxproduct
                if [ "$bamboo_DISTRO" = "centos7" ]; then
                    echo "$bamboo_TARGET_PASSWORD" | sudo -S usermod -aG wheel atxproduct
                else
                    echo "$bamboo_TARGET_PASSWORD" | sudo -S usermod -aG admin atxproduct
                fi
            
                echo "atxproduct:atxpassword" | sudo -S chpasswd
                echo "$bamboo_TARGET_PASSWORD" | sudo -S sed -i -e 's|^PasswordAuthentication.*|PasswordAuthentication yes|' /etc/ssh/sshd_config
                
                if [ "$bamboo_DISTRO" = "centos7" ]; then
                    echo "$bamboo_TARGET_PASSWORD" | sudo -S systemctl restart sshd
                else
                    echo "$bamboo_TARGET_PASSWORD" | sudo -S service ssh restart
                fi
            fi
            echo "User 'atxproduct' created successfully!"
        else
            echo "User 'atxproduct' already exists, moving on .. "
        fi
EOSSH
fi
