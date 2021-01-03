#!/bin/bash

#########################
# a script by lazy-pwny #
#########################

function chksuperuser {
    [ $(id -u) = 0 ] && echo "it is super user"  || { echo "try with 'sudo bash installer.sh --${arg}'" ; exit 1; }
}

function chk {
    if [ -d "./usr/share" ] ; then
        if [ -d "./usr/share/shell-modules" ] ; then
            echo "./usr/share/shell-modules directory exist"
        else
            echo "./usr/share/shell-modules directory isn't exist"
            exit 1
        fi
        echo "./usr/share directory exist"
    else
        echo "./usr/share directory isn't exist"
        exit 1
    fi

    if [ -e "./include-sh" ] ; then
        echo "./include-sh file exist"
    else
        echo "./include-sh file isn't exist"
        exit 1
    fi

    if [ -e "./modules-sh" ] ; then
        echo "./modules-sh file exist"
    else
        echo "./modules-sh file isn't exist"
        exit 1
    fi
}

function install {
    arg="install"
    chksuperuser
    chk
    cp -r "./usr/share/shell-modules" "/usr/share"
    cp "modules-sh" "include-sh" "/bin"
    chmod 755 "/bin/include-sh"
    chmod 755 "/bin/modules-sh"
    chmod 755 /usr/share/shell-modules/*

    if [[ $(echo "$SHELL" | tr "/" " " | awk '{print $NF}') = "bash" ]] ; then
        if [[ $(cat /home/${SUDO_USER:-${USER}}/.bashrc | grep "alias include-sh='source include-sh'") = "" ]] ; then
            read -p "simple to use save the .bashrc file in? [Y/n]:> " x
            case $x in
                [nN])
                    echo "passed.."
                ;;
                *)
                    echo "alias include-sh='source include-sh'" >> /home/${SUDO_USER:-${USER}}/.bashrc
                    echo "pls restart your shell session. ['close all open terminal and reopen' or 'type source ~/.bashrc']"
                ;;
            esac
        fi
    fi

    echo "${arg} completed successfully"
}

function uninstall {
    arg="uninstall"
    chksuperuser
    rm "/bin/modules-sh" "/bin/include-sh"
    rm -rf "/usr/share/shell-modules"
    echo "${arg} completed successfully"
}

function reinstall {
    arg="reinstall"
    chksuperuser
    chk
    uninstall
    install
    echo "${arg} completed successfully"
}

## argv
if [[ ${@:1:1} =~ ^(-i|--install|-I|--INSTALL|install)$ ]] ; then
    install
elif [[ ${@:1:1} =~ ^(-u|--uninstall|-I|--UNINSTALL|uninstall)$ ]] ; then
    uninstall
elif [[ ${@:1:1} =~ ^(-r|--reinstall|-R|--REINSTALL|reinstall)$ ]] ; then
    reinstall
elif [[ ${@:1:1} =~ ^(-h|--help|-H|--HELP|help)$ ]] ; then
    echo "--install: install the module includer on your system."
    echo "--uninstall: uninstall the module includer on your system."
    echo "--reinstall: reinstall the module includer on your system."
    echo "--help: show this menu."
    echo "NOTE: After installation you can use 'modules-sh --help' to see what do you can use this tool."
else
    echo "invalid argunent type 'bash ./installer.sh --help' to see what can be done."
    exit 1
fi