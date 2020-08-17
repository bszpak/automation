#!/bin/bash

source basefunctions.conf

export SERVER_PATH=/home/bamboo/vm/u12-build-server
export REPO_PATH=/home/bamboo/vm/u12-build-server/vada
export SNAPSHOT=ready_to_build

$(declare -f start_machine copy_artifacts print_version)


# Verify vars are set correctly
source verify-vars.sh

# Verify build-target is up
start_machine

# Verify build-server is up
ssh_into_ciserver <<EOF1
    echo "### INFO: Starting \"${bamboo_OS}\" build server ... ###"
    set -e
    cd "${SERVER_PATH}"
    vagrant up
EOF1

# Sync NTP on build-target
ssh_into_target <<EOF2
    set -e
    $(declare -f sync_ntp)
    sync_ntp
EOF2

# Build Operations
ssh_into_ciserver <<EOF3
    set -e
    $(declare -f checkout run_nodesetup build_vada)

    rm -rf ${REPO_PATH}/${bamboo_PRODUCT}/builds/* && echo "### INFO: Successfully cleaned out \"${bamboo_PRODUCT}/builds/\" directory."
    cd ${REPO_PATH} && echo "### INFO: Changed directory to ${REPOPATH}"
    cp -v package.json /tmp         # Copy previous package.json for comparison 

    checkout
    run_nodesetup
    sudo localedef -i en_US -f UTF-8 en_US.UTF-8
    build_vada
EOF3

# Upload build - Had to separate the upload_fw function from above heredoc, otherwise build_vada "release" fab operation pulls it into child shell
ssh_into_precise <<EOF4
    set -e
    $(declare -f upload_fw)
    upload_fw
EOF4

# Copy artifacts and show buildinfo
copy_artifacts
print_version
