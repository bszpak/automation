#!/bin/bash

cd "$(dirname "$0")" 
THIS_DIR="$(pwd)"

#if grep -qs "$THIS_DIR/Safe" /proc/mounts; then
if grep -qs "/dev/hydra/hydra_safe/Safe" /proc/mounts; then
  echo "SUCCESS! Safe is mounted. We can continue..."
else
  echo "FAILED! Safe is not mounted. Please mount the Safe directory with mount.sh and EncFS password."
  exit 1
fi
