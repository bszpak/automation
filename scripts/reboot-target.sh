#! /bin/bash

source basefunctions.conf 

if [ "${UNIT_IP}" ]; then
    export bamboo_TARGET_IP="${UNIT_IP}"
fi
echo "### INFO: System is rebooting ..."
ssh ${bamboo_PRODUCT}@${bamboo_TARGET_IP} "echo ${bamboo_SECRETPW} | sudo -S shutdown -r 1"
