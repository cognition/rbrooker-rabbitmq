#!/bin/bash
#
echo "Setting up the Initialization of RabbitMQ"
#
#
# Envriroment Variables
#
#
MASTER=${MASTER:-0}
FEDERATION=${FEDERATION:-0}
SHOVEL=${SHOVEL:-0}


#
# SSL support off by default
SSL=${SSL:-0}  
#

# Check if this is a restart
if [ -f /.setup_done ]; then
	echo "RabbitMQ Container Already Initialized"
  exit 0
fi

#
# Set up RabbitMQ Configurations
USER=${RABBITMQ_USER:-"admin"}
PASSWORD=${RABBITMQ_PASS:-"admin"}
#
echo ""
echo "=> Securing RabbitMQ with a password  -- ${PASSWORD} "
echo ""
#
if [ $SSL = 0 ]; then 
  echo "ssl added " 
  cat  > /etc/rabbitmq/rabbitmq.config <<EOF
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

fi
#
if [ $SSL = 1 ]; then 
  echo "setting up RabbitMQ config with SSL support" 
  cat > /etc/rabbitmq/rabbitmq.config <<EOF
[
 {rabbit, [
              {default_user, <<"$USER">>},
              {default_pass, <<"$PASSWORD">>},
              {vm_memory_high_watermark,0.5 },
              {vm_memory_high_watermark_paging_ratio,0.6 },
              {disk_free_limit,500000000},
              {cluster_partition_handling,pause_minority},
              {delegate_count,32},
              {tcp_listeners, [{"0.0.0.0", 5672}]},
              {ssl_listeners, [{"0.0.0.0", 5671}]},
              {ssl_options, [
                  {cacertfile,"/server/cacert.pem"},
                  {certfile,"/server/cert.pem"},
                  {keyfile,"/server/key.pem"},
                  {verify,verify_peer},
                  {fail_if_no_peer_cert,false}
              ]}
          ]},
    {kernel,[
          {inet_dist_listen_max, 44001},
          {inet_dist_listen_min, 44001},
          {net_ticktime,  120}
    ]}
].

EOF

else 
  echo "Something when wrong" 
fi


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

# Environment Values

echo "[$PLUGINS]." > /etc/rabbitmq/enabled_plugins 

if [ $MASTER = 0 ]; then 
  export CLUSTER_AGENT=1
fi




echo "ls -l /var/log/"

touch /.setup_done
echo "Setup is done" 

exit 0
