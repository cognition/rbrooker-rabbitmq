#!/bin/bash -x 
# 
echo "++ autocluster ++"
rabbitmqctl stop_app; rabbitmqctl join_cluster rabbit@${MASTER_NAME} ; rabbitmqctl start_app

echo "-- autocluster  --"


exit $?
