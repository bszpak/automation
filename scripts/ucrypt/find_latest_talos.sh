#!/bin/bash
#
# Find and Retrieve latest TALOS_FPGA_IMAGE

array=(`find . -type f -name "talos_top*"`)
latest_talos=${array[0]}
    
for filename in "${array[@]}"; do
    [[ $filename > $latest_talos ]] && latest_talos=$filename
done
    
echo "INFO: Latest TALOS_FPGA_IMAGE is $latest_talos"
echo $latest_talos | cut -c 3- > latest_talos.txt
scp $latest_talos vagrant@10.1.0.234:/home/vagrant/dev/hydra/hw_images/
scp latest_talos.txt bamboo@10.1.0.236:/home/bamboo/build-dir/UCRYPT-BUILD-JOB1/
