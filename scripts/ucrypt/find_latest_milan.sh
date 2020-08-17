#!/bin/bash
#
# Find and Retrieve latest MILAN FPGA IMAGE

array=(`find . -type f -name "ctn9120_atx_milan*"`)
latest_milan=${array[0]}
    
for filename in "${array[@]}"; do
    [[ $filename > $latest_milan ]] && latest_milan=$filename
done
    
echo "INFO: Latest MILAN FPGA IMAGE is $latest_milan"
echo $latest_milan | cut -c 3- > latest_milan.txt
scp $latest_milan vagrant@10.1.0.234:/home/vagrant/dev/hydra/hw_images/
scp latest_milan.txt bamboo@10.1.0.236:/home/bamboo/build-dir/UCRYPT-BUILD-JOB1/
