#!/bin/bash

# Install docker
curl https://get.docker.com | sh

# Location of DDC license
LICENSE_URL="https://s3-us-west-1.amazonaws.com/dockerdatacenterlicense/docker_subscription.lic"

# Setting UCP_VERSION
UCP_VERSION="2.1.4"

# Grab temporary DDC licence from S3 bucket
# Change address if licence is located elsewhere
curl $LICENSE_URL > /tmp/docker_subscription.lic

# Set variable for host address
UCPIP=$(curl http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)

# Install and licence Docker UCP
sudo docker pull docker/ucp:$UCP_VERSION
sudo docker run --rm --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp/docker_subscription.lic:/config/docker_subscription.lic \
  docker/ucp:$UCP_VERSION install \
  --host-address "$UCPIP" \
  --admin-username "admin" \
  --admin-password "orcaorca" 2>&1 | tee /tmp/ucp-output.txt

# Cleanup
rm /tmp/docker_subscription.lic
