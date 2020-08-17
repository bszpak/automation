#!/bin/bash
PORT=2305
PRODUCT=passport

ssh -T -o StrictHostKeyChecking=no atx@10.1.0.213 -p "$PORT" <<-EOSSH
    source ~/vada-env/bin/activate
    
    if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw "$PRODUCT"; then
        echo "INFO: $PRODUCT database already exists... moving on."
    else
        echo "INFO: $PRODUCT database not found, need to create it."
        cd ~/vada/"$PRODUCT"
        pip install -r test-requirements.txt
        echo "INFO: Installed $PRODUCT test-requirements.txt successfully!"
        fab -H localhost create_postgres_db_local
    fi
EOSSH
