#!/bin/bash

source config

docker run --name $NAME --hostname $NAME -p $PORT:22 --restart=unless-stopped --tmpfs /run -d dev/c73-dev
