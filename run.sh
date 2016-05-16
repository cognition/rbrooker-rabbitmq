#!/bin/bash


echo "Starting RabbitMQ " 
echo "    $(date -u +%Y-%m-%d_%Hh%M_UTC) "
set -m
/usr/sbin/rabbitmq-server

