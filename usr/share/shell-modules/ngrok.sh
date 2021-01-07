#!/bin/bash

#########################
# a script by lazy-pwny #
#########################

    ##!-> if ngrok file not yet installed in your shell-modules then type on your shell:
    ##!-> sudo modules-sh --req2get ngrok

getngrok() { 
    source include-sh os2get curl jq
    [ -d /usr/share/shell-modules/ngrok ] && rm -rf mkdir /usr/share/shell-modules/ngrok
    cd /usr/share/shell-modules
    [ -d ngrok ]  && echo "dir exist" || mkdir ngrok
    
    cd ngrok
    wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && unzip ngrok-stable-linux-amd64.zip && rm ngrok-stable-linux-amd64.* && echo -e "Ngrok Has Been Downloaded." || { echo -e "Error while To Download a Ngrok pls Try Again!"; exit 1 ;}
    cd -
}

case ${1} in
    req2get|--req2get|--REQ2GET|REQ2GET|-r2g)
        getngrok
    ;;
esac

    ##!-> ngrokon function start tunnelling with ngrok
    ##!-> usage:
    ##!-> ngrokon
    ##!-> it is given to you $setlink variable or you can directly print link
    ##!-> ngrokon -p 

ngrokon() {
    if [[ $(command -v curl ) = "" ]] ; then
        echo -e "curl: Command Not Found Pls Type 'sudo modules-sh --req2get ngrok'"
        exit 1
    fi

    if [[ $(command -v jq ) = "" ]] ; then
        echo -e "jq: Command Not Found Pls Type 'sudo modules-sh --req2get ngrok'"
        exit 1
    fi

    [ $(command -v jq ) = "" ] && { echo -e "jq: Command Not Found Pls Type 'sudo modules-sh --req2get ngrok'" ; exit 1 ; } 
    
    if ! [ -e /usr/share/shell-modules/ngrok/ngrok ] ; then
        echo "ngrok: File Not Found Pls Type 'modules-sh --req2get ngrok'" # kısaca niye siliyon olm dosyayı arızamısın
        exit 1
    fi
    [ -z ${1} ] && setlport="8080" || setlport="${1}"
    exec /usr/share/shell-modules/ngrok/ngrok http ${setlport}  > /dev/null &
    setlink='$(curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url)'
}

    ##!-> no description for ngrokoff just kill ngrok process
    ##!-> usage:
    ##!-> ngrokoff
    ##!-> NOT: do not forget after ngrokon, put the function end of line

ngrokoff() {
    killall ngrok
}

    ##!-> this function check ngrok is open or no
    ##!-> usage:
    ##!-> getlink -p

getlink() {
    setlink=$(curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url)
    [ -z $setlink ] && echo "Ngrok is closed" || [[ ${1} =~ ^(print|--print|PRINT|--PRINT|-p)$ ]] && echo "${setlink}"
}