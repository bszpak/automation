#!/bin/bash

source basefunctions.conf

if [[ ${bamboo_OS} = 'precise' ]]; then
    ssh_into_ciserver <<-EOF1
        echo "### INFO: Build-driver is \"${bamboo_OS}\" VM."
	rm -rf /home/bamboo/vm/${bamboo_U12_NAME}/vada/${bamboo_PRODUCT}/builds/*
        echo "### Successfully cleaned out \"${bamboo_PRODUCT}/builds/\" directory."
EOF1
elif [[ ${bamboo_OS} = 'bionic' ]] || [[ ${bamboo_PRODUCT} = 'passport' ]]; then
    ssh_into_bionic <<EOF2
	echo "### INFO: Build-driver is \"${bamboo_OS}\" VM."
	rm -rf /home/atxuser/vada/${bamboo_PRODUCT}/builds/*
	echo "### Successfully clean out \"${bamboo_PRODUCT}/builds/\" directory."
EOF2
elif [[ ${BUILD_SERVER} = 'ciserver' ]]; then
    ssh_into_ciserver <<EOF3
        echo "### INFO: Build-driver is \"${BUILD_SERVER}\"."
	echo "$bamboo_SECRETPW" | sudo -S rm -rf /home/bamboo/repos/${bamboo_REPO}/dist/*
	echo "### Successfully cleaned out \"${bamboo_REPO}/dist/\" directory."
EOF3
else
    ssh_into_container <<EOF4
	echo "### INFO: Build-driver is \"${bamboo_CONTAINER_NAME}\"."
        rm -rf ~/vada/${bamboo_PRODUCT}/builds/*
        echo "### Successfully cleaned out \"${bamboo_PRODUCT}/builds/\" directory."
EOF4
fi
