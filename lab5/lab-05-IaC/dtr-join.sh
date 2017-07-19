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

# Set DTR Version
VERSION="2.2.6"

# Set variable for host address
HOSTIP=$(curl http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)


dtr_install() {
    # Installs DTR
    sudo docker run -it --rm docker/dtr:$VERSION install \
        --dtr-external-url "https://$HOSTIP:443" \
        --ucp-node "$(hostname)" \
        --ucp-username "admin" \
        --ucp-password "orcaorca" \
        --ucp-insecure-tls \
        --ucp-url "https://$UCPIP:443" 2>&1 | tee /tmp/dtr-output.txt
}

check_node_status () {
    # Uses client bundle container to check node status
	sudo docker container run --rm \
		--env USERNAME=admin \
		--env PASSWORD=orcaorca \
		--env "UCP_IP=$UCPIP" \
		ucp-api "/v1.24/nodes/$(hostname)" .Status.State
}

# Check node status with client bundle
echo "Checking node status"
while [ "$(check_node_status)" != '"ready"' ] ; do
	echo 'Waiting for node to be ready'
	check_node_status
	sleep 1
done

dtr_install
