#!/bin/bash

if [ -f /.setup_done ]; then
	echo "RabbitMQ Container Already Initialized"
	exit 0
fi


USER=${RABBITMQ_USER:-"admin"}
_word=${RABBITMQ_PASS:-"admin"}
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


# make rabbit own its own files
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq


# Environment Values


DISC_RAM={$DISC_RAM:-"disc"}
MANAGER={$MANAGER:- 1}
CLUSTERED={$CLUSTERD:- 0}
MASTER_DOMAIN={$MASTER_DOMAIN:-"localpod"}

if [[ $MANAGER == 1 ]];  then
     rabbitmq-plugins enable rabbitmq_management rabbitmq_management_agent rabbitmq_shovel rabbitmq_shovel_management --offline
     echo "Manager Setup" 
elif; then
      rabbitmq-plugins enable rabbitmq_management_agent rabbitmq_shovel --offline    
     echo "Worker"
# 
      rabbitmqclt stop_app; rabbitmqclt join_cluster --${DISC_RAM} rabbit@${MASTER_DOMAIN} 
      rabbitmqclt cluster_status; rabbitmqclt start_app
fi





