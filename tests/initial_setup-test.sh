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
sleep 1
echo "override values"
source $PWD/new_values


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

echo "PLUGINS"
echo $PLUGINS 
echo ""
echo "[$PLUGINS]." > enabled_plugins 
# for test mode
echo ""
echo "MASTER = $MASTER_NAME ;; CLUSTER_AGENT = $CLUSTER_AGENT"
if [ $MASTER = 0 ]; then 
    CLUSTER_AGENT=1
fi
echo "CLUSTER_AGENT = $CLUSTER_AGENT"


echo "setup config"

echo "set up configuration using another script" 
/bin/bash rabbitmq.config-test.sh
echo "done setup other" 


echo ""
if [ ! $LOAD_DEFINITIONS = 'nil' ]; then

LOAD_DEFINITIONS="{load_definitions,\"$LOAD_DEFINITIONS\"},"

   echo ""
   sed -i -e  "s|%%LOAD_DEFINITIONS_HERE|${LOAD_DEFINITIONS}|g" rabbitmq.config.0 

fi
echo "mv rabbitmq.config.0 rabbitmq.config.final "
echo "" 
echo "/usr/bin/rabbitmq-server start &"
echo ""

if [ $CLUSTER_AGENT = 1 ]; then
  echo $MASTER_NAME
  echo "autocluster"
  /bin/bash $HOME/REPO/rbrooker-rabbitmq/tests/auto_cluster-test.sh
  echo "autocluster out"
fi
echo "/usr/bin/rabbitmq-server stop"

touch ${PWD}/.setup_done
echo "Setup is done" 


exit $?
