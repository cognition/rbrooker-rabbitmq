#!/bin/bash -x 
# Written By: Ramon Brooker <rbrooker@aetherealmind.com>
# (c) 2017
# 
echo "++ autocluster ++"
rabbitmqctl stop_app; rabbitmqctl join_cluster rabbit@${MASTER_NAME} ; rabbitmqctl start_app

echo "-- autocluster  --"


exit $?
