#!/bin/sh
mkdir -p /home/passport/upgrade/fpga
mkdir -p /home/passport/upgrade/embassy
wget --no-check-certificate https://10.1.0.224/media/firmware/passport/demod/images/pkg.tgz -P /home/passport/upgrade/fpga
wget --no-check-certificate https://10.1.0.224/media/firmware/passport/demod/images/embassy.tgz -P /home/passport/upgrade/embassy
cd /home/passport/upgrade/fpga
tar xvzf pkg.tgz
sudo mount -o remount,rw /boot
sudo mv BOOT.BIN plnx.ub kernel.ub /boot/
sudo mount -o remount,ro /boot
tar xvzf lib-modules.tgz -C /
cd /home/passport/upgrade/embassy
tar xvzf embassy.tgz
sudo mv passport_user passportcfg /usr/local/bin/
sudo mv /opt/firmware/current/env/bin/embassy /opt/firmware/current/env/bin/embassy-old
sudo mv embassy-arm64 /opt/firmware/current/env/bin/embassy
sudo rm -rf /home/passport/upgrade
