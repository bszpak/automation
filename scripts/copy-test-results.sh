#!/bin/bash

source basefunctions.conf

scp -P ${bamboo_CONTAINER_PORT} -r -o StrictHostKeyChecking=no \
atx@${bamboo_CISERVER_IP}:/home/atx/vada/${bamboo_PRODUCT}/test-reports/ ${bamboo_build_working_directory}
