#!/bin/bash -x 
# 
echo "++ autocluster ++"

echo "rabbitmqctl stop_app; rabbitmqctl join_cluster rabbit@${MASTER_NAME} --${NODE_TYPE}; rabbitmqctl start_app"


exit $?
