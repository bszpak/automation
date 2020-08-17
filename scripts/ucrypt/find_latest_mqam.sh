#!/bin/bash
# Find and Retrieve latest MQAM IMAGE

array=(`find . -type f -name "MQAM_fw*"`)
latest_mqam=${array[0]}
    
for filename in "${array[@]}"; do
    [[ $filename > $latest_mqam ]] && latest_mqam=$filename
done
    
echo "INFO: Latest MQAM_IMAGE is $latest_mqam"
echo $latest_mqam | cut -c 3- > latest_mqam.txt
scp $latest_mqam vagrant@10.1.0.234:/home/vagrant/dev/hydra/dqam_images/
scp latest_mqam.txt bamboo@10.1.0.236:/home/bamboo/build-dir/UCRYPT-BUILD-JOB1/
