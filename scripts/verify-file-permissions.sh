#! /bin/bash

souce basefunctions.conf

ssh -T atxproduct@${bamboo_TARGET_IP} <<-EOF
    echo "${bamboo_AUTO_PASSWORD}" | sudo -S chown ${bamboo_PRODUCT}:${bamboo_PRODUCT} /home/${bamboo_PRODUCT}/.ssh/authorized_keys
EOF
