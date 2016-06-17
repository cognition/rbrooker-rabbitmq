#!/bin/bash
#
echo "Setting up the Initialization of RabbitMQ"
#

# Needed Local ENV for this 
# To test set the PWD to reflect your path
PWD="$HOME/REPO/rbrooker-rabbitmq/tests"

echo " Envriroment Variables "
source $PWD/enviromental_vars
echo "check if Env are loading" 



echo "Enable Chosen Plugins"
# Federation Plugins
MASTER_FEDERATION=",rabbitmq_federation_management,rabbitmq_federation"
FEDERATION_PLUGIN=",rabbitmq_federation"

# Shovel Plugins
MASTER_SHOVEL=",rabbitmq_shovel,rabbitmq_shovel_management"
SHOVEL_PLUGIN=",rabbitmq_shovel"

# Management Console
MASTER_CONSOLE=",rabbitmq_management"

PLUGINS="rabbitmq_management_agent"

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

# Environment Values

echo $PLUGINS 

echo "[$PLUGINS]." > enabled_plugins 
# for test mode

echo "setup config"
# set up configuration using another script
/bin/bash $HOME/REPO/rbrooker-rabbitmq/tests/rabbitmq.config-test.sh

if [ $CLUSTER_AGENT = 1 ]; then
  echo $CLUSTER_NODE_NAMES
  /bin/bash $HOME/REPO/rbrooker-rabbitmq/tests/auto_cluster-test.sh
fi

touch ${PWD}/.setup_done
echo "Setup is done" 


exit $?
