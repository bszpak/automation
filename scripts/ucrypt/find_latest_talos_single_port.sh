#!/bin/bash
#
# Find and Retrieve latest TALOS_FPGA_IMAGE_SINGLE_PORT

array=(`find . -type f -name "*_single_port.bin"`)
latest_talos_single_port=${array[0]}
    
for filename in "${array[@]}"; do
    [[ $filename > $latest_talos_single_port ]] && latest_talos_single_port=$filename
done
    
echo "INFO: Latest TALOS_FPGA_IMAGE_SINGLE_PORT is $latest_talos_single_port"
echo $latest_talos_single_port | cut -c 3- > latest_talos_single_port.txt
scp $latest_talos_single_port vagrant@10.1.0.234:/home/vagrant/dev/hydra/hw_images/
scp latest_talos_single_port.txt bamboo@10.1.0.236:/home/bamboo/build-dir/UCRYPT-BUILD-JOB1/
