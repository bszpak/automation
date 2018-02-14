#! /bin/bash
#
# This script is meant to run a set of python fabric scripts 
# to provision a Build-Target machine with:
# 1. create_product_user
# 2. initial_install
# 3. upgrade_pips and upgrade_migration_pips
 
# Exit immediately if a command exists with a non-zero status
set -e

. prefs.cfg


options=("Vagrant VM" "Bare Metal" "Quit")

echo "What type of machine is this Build-Target going on?"
select opt in "${options[@]}"
do
  case $opt in
    "Vagrant VM")
      _vagrant_vm_
      break;;
    "Container")
      # exec ./localhost.sh
      break;;
    "Bare Metal")
      _bare_metal_
      break;;
    "Quit")
      _quit_
      break;;
    *) echo invalid option;;
  esac
done

# Activate python virtualenv
source /vagrant/vada-env/bin/activate

# Run get OSTARGET
_get_ostarget_
echo

# Run create_product_user
_create_product_user_
echo

# Run initial_install
_initial_install_
echo

# Run upgrade_pips
_upgrade_pips_
echo
echo "Build-Target completed successfully!"
