#!/bin/bash

source basefunctions.conf

if [[ ${bamboo_OS} = 'bionic' ]] || [[ ${bamboo_PRODUCT} = 'passport' ]]; then
    ssh_into_bionic <<EOF1
        echo "$bamboo_AUTO_PASSWORD" | sudo -S timedatectl set-ntp off
        echo "$bamboo_AUTO_PASSWORD" | sudo -S timedatectl set-ntp on
        timedatectl
EOF1

elif [[ ${bamboo_OS} != 'bionic' ]]; then
    ssh -T "$bamboo_PRODUCT"@"$bamboo_TARGET_IP" <<-EOF2
        if [[ ${bamboo_OS} = 'centos7' ]]; then
            echo "$bamboo_SECRETPW" | sudo -S systemctl stop ntpd.service
            echo "$bamboo_SECRETPW" | sudo -S ntpdate pool.ntp.org
            echo "$bamboo_SECRETPW" | sudo -S systemctl start ntpd.service

        elif [[ ${bamboo_OS} = 'precise' ]]; then
            echo "$bamboo_SECRETPW" | sudo -S service ntp stop
            echo "$bamboo_SECRETPW" | sudo -S ntpdate-debian
            echo "$bamboo_SECRETPW" | sudo -S service ntp start
	fi
EOF2

fi
sleep 10
