#!/bin/bash

source basefunctions.conf

function install() {
    set -e
    source ~/"${bamboo_VENV}"/bin/activate
    cd ~/vada/"${bamboo_PRODUCT}"
    export DJANGO_SETTINGS_MODULE="${bamboo_PRODUCT}".settings 
    
    if [ "${bamboo_OS}" ]; then
        export TARGET_OS="${bamboo_OS}"
    fi

    fab -H "${bamboo_TARGET_IP}" --disable-known-hosts --sudo-password="${bamboo_SECRETPW}" initial_install
}

if [ ${bamboo_U12_NAME} ]; then
    ssh -T "${bamboo_U12_SSH}" <<EOF1
        $(typeset -f install)
        export TARGET_PYTHON=python2.7
        export DEFAULT_SKU=${bamboo_PRODUCT}
        install
EOF1
elif [ ${bamboo_C7_NAME} ]; then
    ssh -T "${bamboo_C7_SSH}" <<EOF2
        $(typeset -f install)
        install
EOF2
else
    ssh_into_container <<EOF3
        $(typeset -f install)
        # After upgrading docker containers to C7.4.1708, require the following:
        export PYTHONIOENCODING=utf-8
        sudo localedef -i en_US -f UTF-8 en_US.UTF-8
        install
EOF3
fi
