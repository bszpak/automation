#! /bin/bash
#
# This script is meant to run a set of git and fabric commands 
# to provision a Build-Host machine with:
# 1. Clone/checkout/pull VADA 'origin/develop' repo
# 2. Run python setup.py
# 3. Get a packaging key for building releases with a valid key
 
# Exit immediately if a command exists with a non-zero status
set -e

EXIT="Exiting setup..."

read -p "NOTE: Before continuing, make sure the target machine is up-to-date and has 'git' installed. Continue with Build-Server setup? (y/n) " CONTINUE
if [ $CONTINUE == 'n' ]; then
  echo $EXIT
  exit 0
fi

read -p "Are we seting up localhost (THIS machine)? (y/n) " ANSWER1
if [ $ANSWER1 == 'n' ]; then
  read -p "Then enter the remote machine's IP Address: " IP
  read -p "What username can I use to SSH into the machine? " SSHUSER
  echo
  echo "NOTE: The remote repository will be cloned and all subsequent files/directories"
  echo "placed into the remote user's HOME directory. If this is OK, continue with setup."
  echo "If not, then quit this setup, copy all related files into the remote machine's"
  echo "setup directory of your choosing, and run this Build-Host setup locally from that machine."
  read -p "Continue setup? (y/n) " ANSWER2
  if [ $ANSWER2 == 'n' ]; then
    echo $EXIT
    exit 0
  fi

# Otherwise, proceed with SSH into remote machine, copy packaging-key.txt, do git clone, checkout, pull, and run setup.py
  ssh-copy-id -i ~/.ssh/id_rsa.pub $SSHUSER@$IP
  scp .packaging-key.txt $SSHUSER@$IP:/home/$SSHUSER
  ssh -t $SSHUSER@$IP <<-END
    cd /home/$SSHUSER
    if [ ! -e vada ]; then
      echo "There is stuff happening in the background, just give it a few minutes..."
      git clone https://machine:atxpassword@eng.atxnetworks.com/bitbucket/scm/vada/vada.git
      echo
      echo "VADA repo cloning completed."
    fi
    cd vada
    git checkout develop
    git pull
    echo
    echo "Checkout and Pull of 'origin/develop' successful.  Running setup.py..."
    echo
    # Run setup.py
    python setup.py

# Perform gpg --import and remove packaging-key.txt from host
    cd /home/$SSHUSER
    gpg --import packaging-key.txt
    gpg -K E71D21F6
    rm .packaging-key.txt
END

elif [ $ANSWER1 == 'y' ]; then
  echo
  echo "NOTE: The remote repository will be cloned and all subsequent files/directories"
  echo "placed into the current user's HOME directory. If this is OK, continue with setup."
  echo "If you would like to make changes before proceeding, quit setup, move all related"
  echo "files into the setup directory of your choosing, then re-run this Build-Host setup."
  read -p "Continue setup? (y/n) " ANSWER2
  if [ $ANSWER2 == 'n' ]; then
    echo $EXIT
    exit 0
  fi
# Clone VADA repo and change active directory to vada/, do a checkout and pull of 'develop'
  cd $HOME
  if [ ! -e vada ]; then
    git clone https://machine:atxpassword@eng.atxnetworks.com/bitbucket/scm/vada/vada.git
    echo
    echo "VADA repo cloning completed."
  fi
  read -p "Ready to run 'python setup.py'? (y/n) " SETUP
  if [ $SETUP == 'n' ]; then
    echo $EXIT
    exit 0
  elif [ $SETUP == 'y' ]; then
    cd vada
    git checkout develop
    git pull
    echo
    echo "Checkout and Pull of 'origin/develop' successful.  Running setup.py..."
    echo
  fi
# Run setup.py
  python setup.py -D

# Perform gpg --import and remove packaging-key.txt from host
  cd $HOME
  gpg --import .packaging-key.txt
  gpg -K E71D21F6
  rm .packaging-key.txt
fi

