#! /bin/bash

DIR=/etc/yum.repos.d
FILE1=CentOS-7.4.1708.repo

sudo mkdir $DIR/.disabled
sudo mv $DIR/* $DIR/.disabled/
sudo mv /tmp/${FILE1} $DIR/

sudo yum repolist
sudo yum clean all
sudo rm -rf /var/cache/yum
sudo yum update -y
