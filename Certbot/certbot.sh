#!/bin/bash
#DOMAIN_NAME="www.example.com"
#WEB_PATH="/var/www/html/www.example.com/"
while getopts d:p: option
	do
		case "${option}"
			in
			d) DOMAIN_NAME=${OPTARG};;
			p) WEB_PATH=${OPTARG};;
		esac
done

LETSENCRYPT_DIRECTORY="/var/www/html/letsencrypt/"
CONFIG_PATH="/var/www/html/letsencrypt/cli.ini"

echo "
	# Script Start #"
	# We display date
date
cd LETSENCRYPT_DIRECTORY

#array domains
declare -A DOMAINS

#you can add more elements
DOMAINS[${DOMAIN_NAME}]=${WEB_PATH}
for i in "${!DOMAINS[@]}"
	do
	#domain name
	domain=$i
	#domain path
	path=${DOMAINS[$domain]};
	echo -e "\nDomain $i : \n############################################"
	#run command
	result=$(certbot --config ${CONFIG_PATH} -d ${domain} --authenticator webroot --webroot-path ${path} certonly)
	echo "${result}"
done