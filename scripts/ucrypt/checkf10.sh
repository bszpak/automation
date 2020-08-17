#!/bin/bash

vboxmanage list runningvms | grep f10bld

if [ "$?" -eq 0 ]; then
    echo "INFO: f10bld-build-server is already running, moving on.."

elif [ "$?" -eq 1 ]; then
    echo "INFO: Starting f10bld-build-server..."
    vboxmanage startvm f10bld-build-server --type headless
    sleep 20
fi
