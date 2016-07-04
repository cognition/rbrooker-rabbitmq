#!/bin/bash
# Written By: Ramon Brooker <rbrooker@aetherealmind.com>
# (c) 2016



chown -R rabbitmq:rabbitmq  /var/log/rabbitmq
if [ ! -f /.setup_done ] ; then 
  /bin/bash /initial_setup.sh 
fi
echo "  ##############################  "
echo "Starting Container RabbitMQ " 
echo "    $(date -u +%Y-%m-%d_%Hh%M_UTC) "
echo " ##############################  " 
set -m
/usr/sbin/rabbitmq-server

