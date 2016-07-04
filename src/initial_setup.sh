#!/bin/bash -x
#
# Written By: Ramon Brooker <rbrooker@aetherealmind.com>
# (c) 2016




echo "Setting up the Initialization of RabbitMQ"
#
echo " ++ initial_setup ++" 
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
echo "plugin choices loaded"

if [ $MASTER = 0 ]; then 
  CLUSTER_AGENT=1
fi

# sub default, and custom ENV vars in first pass of rabbitmq.config
/bin/bash /rabbitmq.config.sh
echo "first config written"

if [ ! $LOAD_DEFINITIONS = 'nil' ]; then
  LOAD_DEFINITIONS="{load_definitions,\"$LOAD_DEFINITIONS\"},"
  sed -i -e  "s|%%LOAD_DEFINITIONS_HERE|${LOAD_DEFINITIONS}|g" rabbitmq.config.0 
fi

mv rabbitmq.config.0 /etc/rabbitmq/rabbitmq.config

echo "Set the Erlang Cookie"
echo $ERLANG_COOKIE > /var/lib/rabbitmq/.erlang.cookie
chmod 400 /var/lib/rabbitmq/.erlang.cookie  
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/


if [ $CLUSTER_AGENT = 1 ]; then 
  if [ $MASTER_NAME = 'nil' ]; then
   echo "in order to cluster you need to supply a -e MASTER_NAME "
  else
    /usr/sbin/rabbitmq-server  &
    sleep 3;
    /bin/bash /auto_cluster.sh; 
    killall5
  fi
fi


touch /.setup_done
echo ""
echo "Setup is done" 
echo ""
echo " -- initial_setup --" 

exit $?
