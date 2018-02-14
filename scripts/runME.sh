#! /bin/bash

# Prompt user for what they want to do
set -e

options=("Build-Server" "Build-Target (must be ran from Build-Server)" "Staging Server (must be ran from Build-Server)" "Quit")

echo
echo "What would you like to setup?"
echo

select opt in "${options[@]}"
do
  case $opt in
    "Build-Server")
      echo
      echo "You chose 'Build-Server', here we go..."
      exec ./build-server.sh
      break
      ;;
    "Build-Target (must be ran from Build-Server)")
      echo
      echo "You chose 'Build-Target', here we go..."
      exec ./build-target.sh
      break
      ;;
    "Staging Server (must be ran from Build-Server)")
      echo
      echo "You chose 'Staging Server', here we go..."
      exec ./build-staging.sh
      break
      ;;
    "Quit")
      break
      ;;
    *) echo invalid option;;
  esac
done
