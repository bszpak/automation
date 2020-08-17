#!/bin/bash

source basefunctions.conf

export REPOPATH=/home/atx/vada
export PYTHONIOENCODING=utf-8	#After upgrading docker containers to C7.4.1708, require exporting PYTHONIOENCODING=utf-8

$(declare -f start_machine copy_artifacts print_version)


# Verify build-server is up
ssh_into_ciserver <<EOF1
    echo "### INFO: Build-driver is \"${bamboo_CONTAINER_NAME}\" ###" 
    $(declare -f start_container)
    start_container
EOF1

# Verify build-target is up
start_machine

# Sync NTP on build-target
ssh_into_target <<EOF2
    $(declare -f sync_ntp)
    sync_ntp
EOF2

# Build Operations
ssh_into_container <<EOF3
    set -e
    $(declare -f checkout run_nodesetup build_vada)
    rm -rf ~/vada/${bamboo_PRODUCT}/builds/* && echo "### INFO: Successfully cleaned out \"${bamboo_PRODUCT}/builds/\" directory."
    cd ${REPOPATH} && echo "### INFO: Changed directory to ${REPOPATH}"
    cp -v package.json /tmp         # Copy previous package.json for comparison 
    checkout
    run_nodesetup
    sudo localedef -i en_US -f UTF-8 en_US.UTF-8
    build_vada
EOF3

# Upload build - Had to separate the upload_fw function from above heredoc, otherwise build_vada "release" fab operation pulls it into child shell
ssh_into_container <<EOF4
    $(declare -f upload_fw)
    upload_fw
EOF4

# Copy artifacts and show buildinfo
copy_artifacts
print_version
