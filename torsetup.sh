#!/bin/bash
#
#This is easy setup script for Tor.
#Jie Liau@TDoH2017

function torRelay () 
{
	relayResult=$(grep '^ORPort' /etc/tor/torrc)
	if [ "$relayResult" == "" ]; then
		local torConfig="/etc/tor/torrc"
		read -p "Which port for ORPort: " orport
		read -p "Your nickname: " nickname
		read -p "Contact Info: " contactinfo
        echo "Log notice file /var/log/tor/notices.log" | tee -a $torConfig
        echo "Log debug file /var/log/tor/debug.log" | tee -a $torConfig
        echo "ORPort $orport" | tee -a $torConfig
        echo "ExitPolicy reject *:*" | tee -a $torConfig
        echo "Nickname $nickname" | tee -a $torConfig
        echo "ContactInfo $contactinfo" | tee -a $torConfig
    fi
    systemctl restart tor.service
    arm
}
function torHiddenService ()
{
	hiddenResult=$(grep '^HiddenService' /etc/tor/torrc)
	if [ "$hiddenResult" == "" ]; then
		local torConfig="/etc/tor/torrc" 
		read -p "Your real service port: " realport
		read -p "Your hidden service port: " hiddenport
		echo "HiddenServiceDir /var/lib/tor/hidden_service/" | tee -a $torConfig
		echo "HiddenServicePort $hiddenport 127.0.0.1:$realport" | tee -a $torConfig
	fi
	systemctl restart tor.service
	local i=0
	local timeout=5
	while [ $i -lt $timeout ];do
		if [ -e /var/lib/tor/hidden_service/hostname ]; then
			break
		fi
		sleep 1
		i=$(expr $i + 1)
	done
	echo "You onion URL: $(cat /var/lib/tor/hidden_service/hostname)"
}

echo "Welcome to the Tor Setup."
if [ $UID != 0 ]
then
    echo "Please execute this script as root."
    exit 1
fi

apt-get install lsb-core -y
codename=$(lsb_release -a | grep Codename | awk '{print $2}')
resultSources=$(grep "deb.torproject.org" /etc/apt/sources.list)
if [ "$resultSources" == "" ]
then
	echo "deb http://deb.torproject.org/torproject.org $codename main" >> /etc/apt/sources.list
	echo "deb-src http://deb.torproject.org/torproject.org $codename main" >> /etc/apt/sources.list
fi
gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
apt-get update
apt-get install tor deb.torproject.org-keyring tor-arm -y

read -p "Please select which service you want 1) Tor Relay 2) Tor Hidden Service:" choice
if [ $choice == 1 ]
then 
    echo "Tor Relay:"
    torRelay
elif [ $choice == 2 ]
then
    echo "Tor Hidden Service:"
    torHiddenService
else
    echo "Please chose one"
    exit 1
fi
