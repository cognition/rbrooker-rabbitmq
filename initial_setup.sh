#!/bin/bash

# Envriroment Variables

MASTER=0
FED=0   
SHOVEL=0

MASER=${MASTER:-0}
FED=${FED:-0}
SHOVEL=${SHOVEL:-0}



if [ -f /.setup_done ]; then
	echo "RabbitMQ Container Already Initialized"
	exit 0
fi


USER=${RABBITMQ_USER:-"admin"}
PASSWORD=${RABBITMQ_PASS:-"admin"}
echo ""
echo "=> Securing RabbitMQ with a ${_word} password"
echo ""
cat > /etc/rabbitmq/rabbitmq.config <<EOF
[
{rabbit, [
                {default_user, <<"$USER">>},
                {default_pass, <<"$PASSWORD">>},
                {tcp_listeners, [{"0.0.0.0", 5672}]},
                {vm_memory_high_watermark,0.5 },
                {vm_memory_high_watermark_paging_ratio,0.6 },
                {disk_free_limit,500000000},
                {cluster_partition_handling,pause_minority},
                {delegate_count,32}
                ]
        },
 {kernel, [
    {inet_dist_listen_max, 44001},
    {inet_dist_listen_min, 44001},
    {net_ticktime,  120}
  ]}
].

EOF


# Federation Plugins
MA_FED="rabbitmq_federation_management,rabbitmq_federation"
FED_PLUGIN="rabbitmq_federation"

# Shovel Plugins
MA_SHOVEL="rabbitmq_shovel,rabbitmq_shovel_management"
SHOVEL_PLUGIN="rabbitmq_shovel"

# Management Console
MA_CON="rabbitmq_management"
PLUGINS="rabbitmq_management_agent"

if [ $MASTER = 1 ]; then
  PLUGINS=$PLUGINS,$MA_CON
  if [ $SHOVEL = 1 ]; then
    PLUGINS=$PLUGINS,$MA_SHOVEL
  fi
  if [ $FED = 1 ]; then
    PLUGINS=$PLUGINS,$MA_FED
  fi
else 
  if [ $SHOVEL = 1 ]; then
    PLUGINS=$PLUGINS,$SHOVEL_PLUGIN
  fi
  if [ $FED = 1 ]; then
    PLUGINS=$PLUGINS,$FED_PLUGIN
  fi
fi

# Environment Values

echo "[$PLUGINS]." >> /etc/rabbitmq/enabled_plugins 

if [ $MASTER = 0 ]; then 
  export CLUSTER_AGENT=1
fi


exit 0

