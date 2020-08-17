#!/bin/bash
# Create Product User if this is an unknown machine
# ===== TODO: Figure out a way to get past secondary sudo prompt and how to pipe in PRODUCT secret PW later on =====

if [ "$bamboo_INSTALL_ON_DOCKER" = "true" ]; then
    exit 0
elif [ ! -z "$bamboo_TARGET_USER" ] && [ ! -z "$bamboo_TARGET_IP" ]; then

    # Setup password-less access for target machine atxproduct user
    sshpass -p "$bamboo_TARGET_PASSWORD" ssh-copy-id -i ~/.ssh/id_rsa.pub atxproduct@"$bamboo_TARGET_IP"
    
    ssh -T atxproduct@"$bamboo_TARGET_IP" <<-'EOSSH'
        id -u "$bamboo_PRODUCT"     #check if product user already exists
        if [ $? -eq 0 ]; then
            echo "$bamboo_PRODUCT user already exists, moving on..."
        else
            echo "Creating product user on $bamboo_PRODUCT $bamboo_DISTRO machine @ $bamboo_TARGET_IP."
            if [ "$bamboo_DISTRO" = "centos7" ]; then
                ssh -T -o StrictHostKeyChecking=no $bamboo_C7_BUILD_SERVER bash -c "'
                    source /vagrant/vada-env/bin/activate
                    cd /vagrant/vada/$bamboo_PRODUCT
                    export TARGET_OS=centos7
                    export DJANGO_SETTINGS_MODULE=$bamboo_PRODUCT.settings
                    fab -H $bamboo_TARGET_IP --disable-known-hosts --sudo-password=$bamboo_AUTO_PASSWORD create_product_user
                    '"
            else    # Must be a precise machine
                ssh -T -o StrictHostKeyChecking=no $bamboo_U12_BUILD_SERVER bash -c "'
                    source /vagrant/vada-env/bin/activate
                    cd /vagrant/vada/$bamboo_PRODUCT
                    export DEFAULT_SKU=$bamboo_PRODUCT
                    export DJANGO_SETTINGS_MODULE=$bamboo_PRODUCT.settings
                    fab -H $TARGET --disable-known-hosts --sudo-password=$bamboo_AUTO_PASSWORD create_product_user
                    '"        
            fi
        fi
EOSSH
echo "'create_product_user' task completed."
else
    echo "ERROR: Either invalid TARGET_IP or TARGET_USER entered."
    exit 1
fi
