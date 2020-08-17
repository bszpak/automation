#!/bin/bash

source basefunctions.conf

#Precise
if [[ ${bamboo_OS} = 'precise' ]]; then
    ssh -T "${bamboo_U12_SSH}" <<EOF1
        $(typeset -f build_vada)
        # Use specified Versative Version if supplied:
        if [[ "${bamboo_VERSATIVE_VERSION}" =~ [0-9].[0-9].[0-9].[0-9][0-9][0-9][0-9].[0-9][0-9][0-9] ]]; then
            echo "### INFO: Building with specified VERSATIVE_VERSION=${bamboo_VERSATIVE_VERSION}"
            export VERSATIVE_VERSION="${bamboo_VERSATIVE_VERSION}"
        else
            echo "### INFO: Using the default Versative version."
        fi
        export BUILD=1
        export TARGET_PYTHON=python2.7
        export DEFAULT_SKU=${bamboo_PRODUCT}
	export TARGET_OS=precise
	export INIT_SYSTEM=SYSV
        build_vada
EOF1

#Bionic
elif [[ ${bamboo_OS} = 'bionic' ]] || [[ ${bamboo_PRODUCT} = 'passport' ]]; then
    ssh_into_bionic <<-EOF2
	$(typeset -f build_vada)
	export TARGET_PYTHON=python3.6
	export TARGET_OS=bionic
	export INIT_SYSTEM=systemd
	build_vada
EOF2

#Build Embassy
elif [[ ${BUILD_SERVER} = 'ciserver' ]]; then
    ssh_into_ciserver <<EOF3
        $(typeset -f build_embassy)
	export BUILD_SERVER=${BUILD_SERVER}
	export BUILD=${BUILD}
	build_embassy
EOF3

#CentOS
else
    ssh_into_container <<EOF4
        $(typeset -f build_vada)
        # After upgrading docker containers to C7.4.1708, require the following:
        export PYTHONIOENCODING=utf-8
        sudo localedef -i en_US -f UTF-8 en_US.UTF-8
        build_vada
EOF4
fi
