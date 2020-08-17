#!/bin/bash

source basefunctions.conf

### For building Embassy 
if [[ ${bamboo_REPO} = 'embassy' ]]; then
    ssh_into_ciserver <<EOF
        cd ~/repos/"${bamboo_REPO}"/dist && \
	echo "${bamboo_SECRETPW}" | sudo -S tar -zxvf ./embassy-*.tgz --wildcards 'embassy-*.json'
EOF
fi
