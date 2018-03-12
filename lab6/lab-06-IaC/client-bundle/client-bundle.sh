#!/bin/bash
##
# title           : UCP Client Bundle script to accompany dockerfile
# file            : Bash script
# created         : 2017-1-18
# modified        : 2017-1-25
# author          : richard laub
# www-site        : http://nebulaworks.com
# description     : installs client bundle for existing ucp controller
#                 : outputs swarm token
# version         :
# docker_version  : 1.12.6
##
AUTHTOKEN=$(eval "curl -sk -d '{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}' https://$UCP_IP/auth/login" | jq -r .auth_token)
curl -sk -H "Authorization: Bearer $AUTHTOKEN" "https://$UCP_IP/api/clientbundle" -o bundle.zip
unzip -q bundle.zip
eval "$(<env.sh)"
if [ -z "$2" ] ; then
	curl -sk "https://$UCP_IP$1" --cert "$DOCKER_CERT_PATH/cert.pem" --key "$DOCKER_CERT_PATH/key.pem"
else
	curl -sk "https://$UCP_IP$1" --cert "$DOCKER_CERT_PATH/cert.pem" --key "$DOCKER_CERT_PATH/key.pem" | jq "$2"
fi
