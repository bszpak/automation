#!/bin/bash

ssh -T -o StrictHostKeyChecking=no -o ServerAliveInterval=1 -o ServerAliveCountMax=1 \
"$bamboo_PRODUCT"@"$bamboo_TARGET_IP" bash -c "'echo $bamboo_SECRETPW | sudo -S reboot'"

exit 0
