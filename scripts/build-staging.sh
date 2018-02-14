#! /bin/bash
#
# This script is meant to run a set of python fabric scripts 
# to prepare a staging server machine:
# 1. create_product_user
# 2. image
 
# Exit immediately if a command exists with a non-zero status
set -e

. prefs.cfg
. /vagrant/vada-env/bin/activate

echo
echo -n "What product are we staging? (ie. burnin, ip2av3, epgdata): "
_get_product_
_get_targetip_
_get_sshuser_
ssh-copy-id -i ~/.ssh/id_rsa.pub $SSHUSER@$IP

_get_ostarget_
echo $CENTOS

_add_atxuser_


# 1. Create product user
cd /vagrant/vada/$PRODUCT
#if [ ${CENTOS7} == 'y' ]; then
#    TARGET_OS=centos7 fab -H $IP -p atxpassword $TASK1
#else
#    export $PREFIX; fab -H $IP -p atxpassword $TASK1
#fi
#echo
#echo "'create_product_user' task completed successfully!"


# 2. Perform image task
echo
if [ $CENTOS7 == 'y' ]; then
    TARGET_OS=centos7 fab -H $IP $TASK7
else
    export $PREFIX; fab -H $IP $TASK7
fi
echo
echo "image' task completed successfully!"
