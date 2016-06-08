#!/bin/bash

chown -R rabbitmq:rabbitmq  /var/log/rabbitmq

/bin/sh -c /initial_setup.sh 
echo "  ##############################  "
echo "Starting Container RabbitMQ " 
echo "    $(date -u +%Y-%m-%d_%Hh%M_UTC) "
echo " ##############################  " 
set -m
/usr/sbin/rabbitmq-server

