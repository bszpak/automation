#!/bin/bash

source basefunctions.conf

#Precise
if [[ ${bamboo_OS} = 'precise' ]]; then
    scp -o StrictHostKeyChecking=no "${bamboo_U12_SSH}":~/vada/"${bamboo_PRODUCT}"/builds/* \
    "${bamboo_build_working_directory}"

#Bionic    
elif [[ ${bamboo_OS} = 'bionic' ]] || [[ ${bamboo_PRODUCT} = 'passport' ]]; then
    scp -o StrictHostKeyChecking=no atxuser@${bamboo_TARGET_IP}:~/vada/${bamboo_PRODUCT}/builds/* \
    "${bamboo_build_working_directory}"

#Embassy
elif [[ ${BUILD_SERVER} = 'ciserver' ]]; then
    scp -o StrictHostKeyChecking=no "${bamboo_CISERVER}":~/repos/"${bamboo_REPO}"/dist/embassy-* \
    "${bamboo_build_working_directory}"

#CentOS
else
    scp -o StrictHostKeyChecking=no -P "${bamboo_CONTAINER_PORT}" \
    atx@"${bamboo_CISERVER_IP}":~/vada/"${bamboo_PRODUCT}"/builds/* "${bamboo_build_working_directory}"
fi

print_version
