#!/bin/bash

set -m

if [ ! -f /.setup_done ]; then
	/initial_setup.sh
fi

# make rabbit own its own files
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq
if [ ! -f /.MASTER ] || [ ! -f /.AGENT ]
then
# Correct Clustered Plugins
  if [[ $CLUSTERED == 1 ]] 
  then
    if [[ ! -f /.AGENT ]]
    then
      rabbitmq-plugins disable rabbitmq_management 
      rabbitmq-plugins enable rabbitmq_management_agent
      rabbitmq-plugins enable rabbitmq_shovel
      touch /.AGENT
    fi
  elif [[ ! -f /.MASTER ]]
  then
      rabbitmq-plugins enable rabbitmq_management
      rabbitmq-plugins enable rabbitmq_shovel
      rabbitmq-plugins enable rabbitmq_shovel_management
      touch /.MASTER
  fi
fi
# start server 
/usr/sbin/rabbitmq-server

