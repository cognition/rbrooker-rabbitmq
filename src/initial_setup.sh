#!/bin/bash
#
echo "Setting up the Initialization of RabbitMQ"
#

echo "Enable Chosen Plugins"
# Federation Plugins
MASTER_FEDERATION=",rabbitmq_federation_management,rabbitmq_federation"
FEDERATION_PLUGIN=",rabbitmq_federation"

# Shovel Plugins
MASTER_SHOVEL=",rabbitmq_shovel,rabbitmq_shovel_management"
SHOVEL_PLUGIN=",rabbitmq_shovel"

# Management Console
MASTER_CONSOLE=",rabbitmq_management"

PLUGINS="rabbitmq_management_agent "
if [ $MASTER = 1 ]; then
  PLUGINS+=$MASTER_CONSOLE
  if [ $SHOVEL = 1 ]; then
    PLUGINS+=$MASTER_SHOVEL
  fi
  if [ $FEDERATION = 1 ]; then
    PLUGINS+=$MASTER_FEDERATION
  fi
else 
  if [ $SHOVEL = 1 ]; then
    PLUGINS+=$SHOVEL_PLUGIN
  fi
  if [ $FEDERATION = 1 ]; then
    PLUGINS+=$FEDERATION_PLUGIN
  fi
fi

echo "[$PLUGINS]." > /etc/rabbitmq/enabled_plugins 

if [ $MASTER = 0 ]; then 
  export CLUSTER_AGENT=1
fi

echo "setup config"
# set up configuration using another script
/bin/bash /rabbitmq.config.sh

if [ $CLUSTER_AGENT = 1 ]; then 
/bin/bash /auto_cluster.sh
else
  mv rabbitmq.config.0 /etc/rabbitmq/rabbitmq.config
fi

echo "Set the Erlang Cookie"
echo $ERLANG_COOKIE > /var/lib/rabbitmq/.erlang.cookie
chmod 400 /var/lib/rabbitmq/.erlang.cookie  
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/


touch /.setup_done
echo "Setup is done" 

exit $?
