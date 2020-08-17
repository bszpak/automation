#!/bin/bash
#
# Find and Retrieve latest DQAM IMAGE

array=(`find . -type f -name "*DQ801B*"`)
latest_dqam=${array[0]}
    
for filename in "${array[@]}"; do
    [[ $filename > $latest_dqam ]] && latest_dqam=$filename
done
    
echo "INFO: Latest DQAM IMAGE is $latest_dqam"
echo $latest_dqam | cut -c 3- > latest_dqam.txt
scp $latest_dqam vagrant@10.1.0.234:/home/vagrant/dev/hydra/dqam_images/
scp latest_dqam.txt bamboo@10.1.0.236:/home/bamboo/build-dir/UCRYPT-BUILD-JOB1/
