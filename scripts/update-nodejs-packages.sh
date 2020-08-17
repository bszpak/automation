#!/bin/bash

source basefunctions.conf

if [ ${bamboo_U12_NAME} ]; then
    ssh -T "${bamboo_U12_SSH}" <<-EOF1
        $(typeset -f run_nodesetup)
        run_nodesetup
EOF1
elif [ ${bamboo_C7_NAME} ]; then
    ssh -T "${bamboo_C7_SSH}" <<-EOF2
        $(typeset -f run_nodesetup)
        run_nodesetup
EOF2
elif [[ ${bamboo_OS} = 'bionic' ]] || [[ ${bamboo_PRODUCT} = 'passport' ]]; then
    ssh_into_bionic <<EOF3
	$(typeset -f run_nodesetup)
	run_nodesetup
EOF3
else
    ssh_into_container <<-EOF4
        $(typeset -f run_nodesetup)
        run_nodesetup
EOF4
fi
