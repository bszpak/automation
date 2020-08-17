#!/bin/bash

source basefunctions.conf

### For building Embassy 
if [[ ${bamboo_REPO} = 'embassy' ]]; then

    FILE=embassy-*.tgz
    export K=`echo $FILE`
    
    ssh -T "${bamboo_FW_REPO}" <<EOF
	cd /home/configserver/media/firmware/passport/demod/images && ./update-symlinks.sh $K
EOF
fi
