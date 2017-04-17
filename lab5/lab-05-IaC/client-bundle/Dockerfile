##
# title           : UCP Client Bundle for API use
# file            : Dockerfile
# created         : 2017-1-18
# modified        : 2017-1-25
# author          : richard laub
# www-site        : http://nebulaworks.com
# description     : builds a container image which downloads a client bundle
#                 : and accepts arguments for api
# version         :
# docker_version  : 1.12.6
##
FROM alpine:3.5
MAINTAINER richard@nebulaworks.com
RUN apk add --update bash curl jq
WORKDIR /root
COPY client-bundle.sh .
ENTRYPOINT ["/root/client-bundle.sh"]
