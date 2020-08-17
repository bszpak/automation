#! /bin/bash

source basefunctions.conf

ssh_into_target <<-EOF
    echo "${bamboo_AUTO_PASSWORD}" | sudo -S yum --disablerepo=nodesource --disablerepo=pgdg11 install -y \
    lsof \
    ntp \
    git
EOF
