#!/bin/bash
# Remove atxproduct user
if [ ! -z "$bamboo_TARGET_USER" ]; then
    ssh -tt -o StrictHostKeyChecking=no "$bamboo_PRODUCT"@"$bamboo_TARGET_IP" <<-EOSSH
        if id -u atxproduct >/dev/null 2>&1; then    #check atxproduct user exists
            
            # If TARGET_USER is root
            if [ "$bamboo_TARGET_USER" = "root" ]; then
                pkill -9 -u `id -u atxproduct`
                
                if [ "$bamboo_DISTRO" = "centos7" ]; then
                    userdel -r atxproduct
                else
                    deluser --remove-home atxproduct
                fi
                if id -u atxproduct >/dev/null 2>&1; then      #check atxproduct user exists
                    echo "User still exists and could not be removed."
                    exit 1
                else
                    echo "User removed successfully!"
                    exit 0
                fi
                
            # If TARGET_USER is non-root user
            elif [ "$bamboo_TARGET_USER" != "root" ]; then
            
                if [ "$bamboo_PRODUCT" = "analogout" ]; then
                    echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S pkill -9 -u `id -u atxproduct`
                    if [ "$bamboo_DISTRO" = "centos7" ]; then
                        echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S userdel -r atxproduct
                    else
                        echo "$bamboo_SECRETPW_ANALOGOUT" | sudo -S deluser --remove-home atxproduct
                    fi
                    
                elif [ "$bamboo_PRODUCT" = "burnin" ]; then
                    echo "$bamboo_SECRETPW_BURNIN" | sudo -S pkill -9 -u `id -u atxproduct`
                    echo "$bamboo_SECRETPW_BURNIN" | sudo -S userdel -r atxproduct
                    
                elif [ "$bamboo_PRODUCT" = "epgdata" ]; then
                    echo "$bamboo_SECRETPW_EPGDATA" | sudo -S pkill -9 -u `id -u atxproduct`
                    if [ "$bamboo_DISTRO" = "centos7" ]; then
                        echo "$bamboo_SECRETPW_EPGDATA" | sudo -S userdel -r atxproduct
                    else
                        echo "$bamboo_SECRETPW_EPGDATA" | sudo -S deluser --remove-home atxproduct
                    fi
                
                elif [ "$bamboo_PRODUCT" = "ip2av3" ]; then
                    echo "$bamboo_SECRETPW_IP2AV3" | sudo -S pkill -9 -u `id -u atxproduct`
                    if [ "$bamboo_DISTRO" = "centos7" ]; then
                        echo "$bamboo_SECRETPW_IP2AV3" | sudo -S userdel -r atxproduct
                    else
                        echo "$bamboo_SECRETPW_IP2AV3" | sudo -S deluser --remove-home atxproduct
                    fi
                    
                elif [ "$bamboo_PRODUCT" = "ip2av4" ]; then
                    echo "$bamboo_SECRETPW_IP2AV4" | sudo -S pkill -9 -u `id -u atxproduct`
                    echo "$bamboo_SECRETPW_IP2AV4" | sudo -S userdel -r atxproduct
                fi
                
                if id -u atxproduct >/dev/null 2>&1; then      #check atxproduct user exists
                    echo "User still exists and could not be removed."
                    exit 1
                else
                    echo "User removed successfully!"
                    exit 0
                fi
            fi
        else
            echo "User atxproduct does not exist, nothing to remove. Moving on..."
        fi
EOSSH
fi
