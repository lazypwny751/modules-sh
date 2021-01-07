#!/bin/bash

source include-sh color ngrok checkroot

#checkroot -e

echo -e "${red} kırmızı ${black}siyah ${green} yeşil ${yellow} sarı ${blue} mavi ${purple} mor ${cyan} cyan ${white} beyaz ${reset} default"

ngrokon 
sleep 5 && getlink
ngrokoff
getlink
