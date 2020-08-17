#/bin/bash

df -h /
    if [ `df -h --output=pcent "$PWD" | tail -n 1 | sed -e "s/%//"` -gt 85 ]; then
        exit 1
    fi
