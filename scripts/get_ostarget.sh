#! /bin/bash

function _get_ostarget_()
{
        uname -a | grep el
        if [ $? == 0 ]; then
            local CENTOS='y'
            echo 'This is a CentOS machine ...'
            echo "$CENTOS"
        else
            local CENTOS='n'
            echo 'This is a non-CentOS machine ...'
            echo "$CENTOS"
        fi
}

result=$(_get_ostarget_)
echo $result
