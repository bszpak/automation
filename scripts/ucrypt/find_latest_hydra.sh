#!/bin/bash
#
# Find and Retrieve latest Hydra BOARD IMAGE

array=(`find . -type f -name "hydra*"`)
latest_hydra=${array[0]}
    
for filename in "${array[@]}"; do
    [[ $filename > $latest_hydra ]] && latest_hydra=$filename
done
    
echo "INFO: Latest hydra_board_update IMAGE is $latest_hydra"
echo $latest_hydra | cut -c 3- > latest_hydra.txt
scp $latest_hydra vagrant@10.1.0.234:/home/vagrant/dev/hydra/images/
scp latest_hydra.txt bamboo@10.1.0.236:/home/bamboo/build-dir/UCRYPT-BUILD-JOB1/
