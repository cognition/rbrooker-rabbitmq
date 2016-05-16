#!/bin/bash

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

MASERT_PLUGINS="[rabbitmq_management,rabbitmq_management_agent,rabbitmq_shovel,rabbitmq_shovel_management]."
#AGENT_PLUGINS="[rabbitmq_management_agent,rabbitmq_shovel]."

# Environment Values

echo $MASERT_PLUGINS >> /etc/rabbitmq/enabled_plugins   



