#!/bin/bash
#
# Find and Retrieve latest analogout master build

array=(`find . -type f -name "*analogout-[0-9][0-9][0-9][0-9][0-9].tar.gz.gpg"`)
latest_analogout=${array[0]}
    
for filename in "${array[@]}"; do
    [[ $filename > $latest_analogout ]] && latest_analogout=$filename
done
    
echo "INFO: Latest master is $latest_analogout"
echo $latest_analogout | cut -c 3- > latest_analogout.txt
scp $latest_analogout vagrant@10.1.0.234:/home/vagrant/dev/hydra/analogout_images/
scp latest_analogout.txt bamboo@10.1.0.236:/home/bamboo/build-dir/UCRYPT-BUILD-JOB1/   
