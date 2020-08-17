#!/bin/bash

source basefunctions.conf
export REPOPATH=/home/atxuser/vada
$(declare -f start_machine copy_artifacts print_version)


# Verify build-server is up
start_machine

# Verify build-target is up & perform build operations
ssh_into_bionic <<EOF1
    export REPOPATH=${REPOPATH}
    $(declare -f start_qemu sync_ntp checkout run_nodesetup build_vada)
    
    start_qemu
    rm -rf ${REPOPATH}/${bamboo_PRODUCT}/builds/* && echo "### Successfully cleaned out \"${bamboo_PRODUCT}/builds/\" directory. ###"
    cd ${REPOPATH} && echo "### Changed directory to ${REPOPATH} ###"
    cp -v package.json /tmp         # Copy previous package.json for comparison
    
    sync_ntp 
    checkout
    run_nodesetup
    build_vada
EOF1

# Had to separate the upload_fw function from above heredoc, otherwise build_vada "release" fab operation pulls it into child shell
ssh_into_bionic <<EOF2
    $(declare -f upload_fw)
    upload_fw
EOF2

# Copy artifacts and show buildinfo
copy_artifacts
print_version
