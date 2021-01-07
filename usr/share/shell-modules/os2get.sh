#!/bin/bash

#########################
# a script by lazy-pwny #
#########################

[ ${EUID} != 0 ] && { echo "Run it as root" ; exit 1 ; }

    ##!-> not yet finished
    ##!-> do not use know
    ##!-> or
    ##!-> source os2get <package names>

if [[ $(command -v apt) != "" ]] ; then
    if [ "${#}" -gt 0 ] ; then
        for i in $( seq 1 $# ) ; do
            apt install -y ${@:i:1}
        done
    else
        echo "wrong use. If you want to know how to use it, try 'modules-sh --module os2get'"
    fi
elif [[ $(command -v pacman) != "" ]] ; then
    echo "comming soon"    
fi