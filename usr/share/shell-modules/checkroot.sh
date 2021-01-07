#!/bin/bash
reset='\033[0m'
red='\033[0;31m'          # Red
green='\033[0;32m' 

    ##!-> This module check if user root or no
    ##!-> usage:
    ##!-> source include-sh checkroot
    ##!-> checkroot -e # after check if the user not have 0 id so if the 
    ##!-> not root then terminate the proccess
    ##!-> or just:
    ##!-> checkroot # this is the simple usage just given a variable after executation the funciton
    ##!-> if root chekroot="true" else checkroot="false"

checkroot() {
    if [[ ${EUID} != 0 ]] ; then
            echo -e "${red}pls try with sudo${reset}"
            checkroot="false"
        [[ ${1} =~ ^(exit|EXIT|--exit|--EXIT|-e)$ ]] && exit 1
            checkroot="true"
        else
            echo -e "${green}set user have super powers....${reset}"
    fi
}