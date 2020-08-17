#! /bin/bash

FILE1=upgrade-to-C7.4.1708.sh
FILE2=CentOS-7.4.1708.repo

echo "Password21!" | sudo -S scp -P $1 ${FILE1} ${FILE2} atx@10.1.0.213:/tmp
ssh atx@10.1.0.213 -p $1 "cd /tmp && ./upgrade-to-C7.4.1708.sh"
