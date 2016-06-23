#!/bin/bash -x
#
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


if [ $CLUSTER_AGENT = 1 ]; then 
#/bin/bash /auto_cluster.sh
echo "autocluster"
echo $CLUSTER_NODE_NAMES
OIFS="$IFS"
IFS=','
read -a NODES <<< "${CLUSTER_NODE_NAMES}"
IFS="$OIFS"
i=0
disc='nil'
ram='nil'
for node in "${NODES[@]}"
  do
  echo "$node"
    if [ $(($i % 2)) -eq 0 ]; then
    if [ $disc = 'nil' ]; then 
      echo "@@@@@@"
      disc=\'$node\'
      echo "$disc"
      echo "@@@@@@"
    else
      echo "!!!!!!"
      disc="$disc,\'$node\'"
      echo "$disc"
      echo "!!!!!!"
    fi
  else
    if [ $ram = 'nil' ]; then
     echo "((((((("
      echo "$ram"
      ram=\'$node\'
      echo "((((("
    else
      echo ")))))"
      ram="$ram,\'$node\'"
      echo "$ram"
      echo ")))))"
    fi
  fi
    ((++i))
done
  if [ $ram = 'nil' ]; then
    echo "******"
    cluster_nodes="{cluster_node, {[$disc], disc}},"
    echo "******"
  elif [ $disc = 'nil' ] && !  [ $ram = 'nil' ] 
  then
    echo "#####"
    cluster_nodes="{cluster_node, {[$ram],ram}},"
    echo "#####"
  else
    echo "^^^^"
    cluster_nodes="{cluster_node, {[$disc], disc},{[$ram],ram}},"
    echo "^^^^"
  fi
  echo $cluster_nodes
  echo "&&&&&&&&"
  sed -i -e 's|%%SUB_CLUSTER_NODE_DETAILS_HERE|'"${cluster_nodes}"'|g' rabbitmq.config.0
  echo "&&&&&&&&" 
  echo "autocluster -- end"

fi

cp rabbitmq.config.0 /etc/rabbitmq/rabbitmq.config

echo "Set the Erlang Cookie"
echo $ERLANG_COOKIE > /var/lib/rabbitmq/.erlang.cookie
chmod 400 /var/lib/rabbitmq/.erlang.cookie  
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/


touch /.setup_done
echo ""
echo "Setup is done" 
echo ""
echo " -- initial_setup --" 

exit $?
