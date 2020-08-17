#! /bin/bash

source basefunctions.conf 

if [ ${bamboo_U12_NAME} ]; then
    ssh -T "${bamboo_U12_SSH}" <<-EOF1
        $(typeset -f upgrade_target)
        export TARGET_PYTHON=python2.7
	export DEFAULT_SKU=${bamboo_PRODUCT}
        if [ "${UNIT_IP}" ]; then
            export bamboo_TARGET_IP="${UNIT_IP}"
        fi
        upgrade_target
EOF1
elif [ ${bamboo_C7_NAME} ]; then
    ssh -T "${bamboo_C7_SSH}" <<-EOF2
        $(typeset -f upgrade_target)
        upgrade_target
EOF2
else
    ssh_into_container <<-EOF3
        $(typeset -f upgrade_target)
        # After upgrading docker containers to C7.4.1708, require the following:
        export PYTHONIOENCODING=utf-8
        sudo localedef -i en_US -f UTF-8 en_US.UTF-8
        upgrade_target
EOF3
fi
