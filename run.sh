#!/bin/bash

set -m

if [ ! -f /.rabbitmq_password_set ]; then
	/set_rabbitmq_password.sh
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
      #rabbitmq-server stop
      rabbitmq-plugins enable rabbitmq_management_agent
      touch /.AGENT
    fi
  elif [[ ! -f /.MASTER ]]
  then
      rabbitmq-plugins enable rabbitmq_management
      #rabbitmq-server stop
      touch /.MASTER
  fi
fi
# start server 
/usr/sbin/rabbitmq-server

