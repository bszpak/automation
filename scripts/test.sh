#! /bin/bash

IP=10.1.1.41
SSHUSER=vagrant

ssh-copy-id -i ~/.ssh/id_rsa.pub $SSHUSER@$IP
scp get_ostarget.sh $SSHUSER@$IP:/home/$SSHUSER

ssh -T $SSHUSER@$IP <<-EOSSH
    cd /home/$SSHUSER
    ./get_ostarget.sh
EOSSH

echo $CENTOS
