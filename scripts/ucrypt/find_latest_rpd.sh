#!/bin/bash
#
# Find and Retrieve latest RPD UPDATE FILE

array=(`find . -type f -name "ctn9120_noah*"`)
latest_rpd=${array[0]}
    
for filename in "${array[@]}"; do
    [[ $filename > $latest_rpd ]] && latest_rpd=$filename
done
    
echo "INFO: Latest RPD UPDATE FILE is $latest_rpd"
echo $latest_rpd | cut -c 3- > latest_rpd.txt
scp $latest_rpd vagrant@10.1.0.234:/home/vagrant/dev/hydra/hw_images/
scp latest_rpd.txt bamboo@10.1.0.236:/home/bamboo/build-dir/UCRYPT-BUILD-JOB1/
