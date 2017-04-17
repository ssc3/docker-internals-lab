#!/bin/bash

# Install Docker
curl https://get.docker.com | sh

sudo docker image build --tag ucp-api .
SWMTKN=$(sudo docker container run --rm \
    --env USERNAME=admin \
    --env PASSWORD=orcaorca \
    --env "UCP_IP=$UCPIP" \
    ucp-api /v1.24/swarm ".JoinTokens.Worker" | tr -d '"')

# Joins to existing UCP
sudo docker swarm join \
	--token "$SWMTKN" \
	"$UCPIP:2377"
