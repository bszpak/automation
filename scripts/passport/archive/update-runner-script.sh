#!/bin/bash
echo "INFO: Updating update_fpga_embassy.sh file with latest packages ..."
latest_fpga=`cat latest_fpga.txt`
latest_embassy=`cat latest_embassy.txt`

sed -i "4s|pkg-.*tgz|$latest_fpga|" update_fpga_embassy.sh
sed -i "5s|embassy-.*tgz|$latest_embassy|" update_fpga_embassy.sh

#scp -o StrictHostKeyChecking=no update_fpga_embassy.sh passport@"$bamboo_TARGET_IP":/home/passport/
