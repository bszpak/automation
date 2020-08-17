#!/bin/bash

# Store a filename in a variable minus the extension
GPG="$(cat latest-build.txt | grep \.gpg$)"
TXT="$(cat latest-build.txt | grep \.release.txt$)"
DIR="${GPG%%.*}"
    
# SSH into build-server and perform decrypt, untar, augment, tar, encrypt
ssh -T $bamboo_C7_BUILD_SERVER <<-EOSSH
    source ${HOME}/$bamboo_VENV/bin/activate
    cd ${HOME}/vada/$bamboo_PRODUCT/builds

    # Decrypt and untar newly built package
    gpg --output $DIR.tar.gz -d $GPG
    tar -zxf $DIR.tar.gz
    
    # Augment release.conf
    sed -i "s|revision=.*|revision=$bamboo_VERSION|g" $DIR/etc/$bamboo_PRODUCT/release.conf

    # tar and encrypt the augmented package
    tar -czf $DIR-$bamboo_VERSION.tar.gz $DIR
    fussy-sign -k E71D21F6 -f $DIR-$bamboo_VERSION.tar.gz
    
    # Augment release.txt and rename
    sed -i "s|revision=.*|revision=$bamboo_VERSION|g" $TXT
    sed -i "s|filename=.*|filename=$DIR-$bamboo_VERSION.tar.gz.gpg|g" $TXT
    mv $TXT $DIR-$bamboo_VERSION.tar.gz.gpg.release.txt
    
    # Remove temp files/folders
    rm -rf $DIR $DIR.tar.gz*
EOSSH
