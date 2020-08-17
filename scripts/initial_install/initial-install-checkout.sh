#!/bin/bash
U12=u12-build-server
C7=c7-build-server
ssh -T -o StrictHostKeyChecking=no $bamboo_CISERVER <<-EOSSH
    set -e
    if \
    [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "precise" ] || \
    [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "precise" ] || \
    [ "$bamboo_PRODUCT" = "ip2av3" ] || \
    [ "$bamboo_PRODUCT" = "digistream" ]; then
        cd /home/bamboo/vm/"$U12"/vada
    elif \
    [ "$bamboo_PRODUCT" = "analogout" ] && [ "$bamboo_DISTRO" = "centos7" ] || \
    [ "$bamboo_PRODUCT" = "epgdata" ] && [ "$bamboo_DISTRO" = "centos7" ] || \
    [ "$bamboo_PRODUCT" = "burnin" ] || \
    [ "$bamboo_PRODUCT" = "ip2av4" ]; then
        cd /home/bamboo/vm/"$C7"/vada
    else
        echo "ERROR: Source code checkout failed. Incorrect PRODUCT or DISTRO value entered."
        exit 1
    fi
    git fetch
    git-lfs fetch
    if [ ! -z "$bamboo_BRANCH" ]; then
        git checkout -f "$bamboo_BRANCH"
        git pull
    else
        git checkout -f "$bamboo_repository_git_branch"
        git reset --hard "$bamboo_repository_revision_number"
        git pull
    fi
EOSSH
