#!/bin/bash

source basefunctions.conf

ssh_into_container <<-EOF
    set -e
    source ~/${bamboo_VENV}/bin/activate
    cd ~/vada/${bamboo_PRODUCT}
    
    if tox; then
        echo "${bamboo_PRODUCT} Tests PASSED!"
    else
        tox -r -- --create-db
    fi
EOF
exit 0
