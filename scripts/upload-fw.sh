#!/bin/bash

source basefunctions.conf

#Precise
if [ ${bamboo_U12_NAME} ]; then
    ssh -T "${bamboo_U12_SSH}" <<-EOF1
        $(typeset -f upload_fw)
        upload_fw
EOF1

#Bionic
elif [[ ${bamboo_OS} = 'bionic' ]] || [[ ${bamboo_PRODUCT} = 'passport' ]]; then
    ssh_into_bionic <<EOF2
        $(typeset -f upload_fw)
        upload_fw
EOF2

#Embassy
elif [[ ${BUILD_SERVER} = 'ciserver' ]]; then
    ssh_into_ciserver <<EOF3
	scp -p -o StrictHostKeyChecking=no /home/bamboo/repos/${bamboo_REPO}/dist/embassy-* \
	${bamboo_FW_REPO}:/home/configserver/media/firmware/passport/demod/images/
EOF3

else
#CentOS
    ssh_into_container <<-EOF4
        $(typeset -f upload_fw)
        upload_fw
EOF4
fi
