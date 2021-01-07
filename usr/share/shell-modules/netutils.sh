#!/bin/bash

#########################
# a script by lazy pwny #
#########################

##!-> source include-sh netutils

endline="false"

    ##!-> netcheck is a function show if you are online or not
    ##!-> usage:
    ##!-> netcheck -p

netcheck() {
    ping -q -w1 -c1 google.com &>/dev/null && netcheck="online" || netcheck="offline"
    case ${1} in
        print|PRINT|-p)
            echo "${netcheck}"
        ;;
    esac
}

    ##!-> mylocalip function is show your local ip adress
    ##!-> usage:
    ##!-> mylocalip -p 

mylocalip() {
        mylocalip=$(hostname -I || ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
        case ${1} in
            print|--print|-p)
            echo "$mylocalip"
            ;;
        esac
}

    ##!-> mypublicip function is show your public ip adress
    ##!-> usage:
    ##!-> mypublicip -p 

mypublicip() {
        mypublicip=$(curl -s ip.me || wget -qO- ipinfo.io/ip) &> /dev/null
        case ${1} in
            print|--print|-p)
            echo "$mypublicip"
        ;;
        json|JSON|--json)
            mypublicipJSON=$(curl -s 'https://api.ipify.org?format=json')
            case ${2} in
                print|PRINT|-p)
                    echo "$mypublicipJSON"
            ;;  
            esac
        ;;
        esac
}

    ##!-> getinfo is the best funciton of netutils
    ##!-> usage:
    ##!-> endline="true" or endline="false"
    ##!-> getinfo <ip adress> -p/-pJ
    ##!-> or
    ##!-> getinfo me -p

getinfo() {
    case ${1} in
        me|ME)
            thatip2=$(curl -s ip.me || wget -qO- ipinfo.io/ip) &> /dev/null
        ;;

        print|PRINT|-p|printasJSON|PRINASJSON|-pJ)
            echo "you need to enter ip adress before use print argument"
        ;;
        ""|" ")
            echo "first argument can not be a null because this variable the target if you want to get your info so try 'getinfo me -p'"
        ;;
        *)
            thatip2="${1}"
        ;;
    esac
        curl -s "https://ipinfo.io/${thatip2}/json" | jq -r 'to_entries | .[] | .key + "=\"" + .value + "\""' > /tmp/setinfo && source /tmp/setinfo 
        if [[ ${2} =~ ^(print|PRINT|-p)$ ]] ; then
            cat /tmp/setinfo
        elif [[ ${2} =~ ^(printasJSON|PRINASJSON|-pJ)$ ]] ; then
            curl -s "https://ipinfo.io/${thatip2}/json" ; [ ${endline} = true ] && echo ""
        fi
    rm /tmp/setinfo &> /dev/null
}

    ##!-> getsipeip funciton is get site ip adrees to domain
    ##!-> usage:
    ##!-> getsiteip google.com

getsiteip() {
    case ${1} in
        ""|" ")
            echo "first argument can not be a null because this variable the target. For example 'network getip google.com'"
            exit 1
        ;;
        
        print|PRINT|-p)
            echo "you need to enter target before use print argument"
        ;;
        *)
            targV="${1}"
        ;;
    esac
    getsiteip=$(ping -c1 ${targV} | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p')
    if [[ ${2} =~ ^(print|PRINT|-p)$ ]] ; then
        echo "$getsiteip"   
    fi
}

    ##!-> is the check port function.
    ##!-> usage: 
    ##!-> amisee 127.0.0.1 8080 -p
    ##!-> if that port is open amisee="true" else amisee="false"
amisee() {

    case ${1} in 
        ""|" ")
            echo "first argument cannot be null: because this is the host"
        ;;
        print|PRINT|-p)
            echo "you need to enter target before use print argument"
        ;;
        *)
            host="${1}"
            case ${2} in
                ""|" ")
                    echo "second argument cannot be null: because this is the port"
                ;;
                print|PRINT|-p)
                    echo "you need to enter target before use print argument"
                ;;
                *)
                    port="${2}"
                ;;
            esac
        ;;
    esac

    timeout 3 bash -c "</dev/tcp/${host}/${port}" &> /dev/null 
    if [ $? = 0 ] ; then
        amisee="open"
    else
        amisee="close"
    fi

    case ${3} in
        print|PRINT|-p)
            echo "${host}:${port} ${amisee}"
        ;;
    esac
}
