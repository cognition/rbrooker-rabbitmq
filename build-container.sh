#!/bin/bash
# build scripts to
TAG='3.7.12'
        docker build --no-cache --pull  --rm=true -t rbrooker/rabbitmq -t rbrooker/rabbitmq:${TAG} -f Dockerfile .
        docker build -t rbrooker/rabbitmq .  

exit $?

