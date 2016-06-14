#!/bin/bash


echo "Setting up the Initialization of RabbitMQ"
#
#
# Envriroment Variables
#
#




if [ -d $FILE_NAME ];then
  LOAD_DEF="{load_definitions, "/custom_configs/${FILE_NAME}"},"
fi


# HOSTNAME is already populated by from the docker run cmd --hostname 
CLUSTER_NODE="{cluster_nodes, {['${CLUSTER_NODE_NAME}'], ${NODE_TYPE}}}"



###############
#   Cluster   #
###############
CLUSTER_CONFIGS <<EOF
   {cluster_partition_handling, pause_minority},
   ${CLUSTER_NODE},
   {cluster_keepalive_interval, 10000}
EOF




###############
#  SSL_CONFIG  #
###############



SSL_CONFIG <<EOF
    {ssl_listeners, [
                      {${SSL_AMQP_IP_LISTEN},${SSL_TCP_PORT}},
                      {${SSL_AMQP_IP_LISTEN_6},"${SSL_TCP_PORT}"}
                    ]
    },
    {ssl_options, [
        {cacertfile,${CACERTFILE}},
        {certfile,${CERTFILE}},
        {keyfile,${KEYFILE}},
        {verify,verify_peer},
        {fail_if_no_peer_cert,${FAIL_IF_NO_PEER_CERT}}
      ]
    },
    {ssl_cert_login_from, ${SSL_CERT_LOGIN_FROM}},
    {ssl_handshake_timeout, ${SSL_HANDSHAKE_TIMACERTFILE}},
EOF






echo "setting up RabbitMQ with " 

cat > /etc/rabbitmq/rabbitmq.config <<EOF


%% -*- mode: erlang -*-
%% ----------------------------------------------------------------------------
%% RabbitMQ Sample Configuration File.
%%
%% See http://www.rabbitmq.com/configure.html for details.
%% ----------------------------------------------------------------------------
[
 {rabbit,
  [
     {tcp_listeners, [{${AMQP_IP_LISTEN},${TCP_PORT}},
                       {${AMQP_IP_LISTEN_6},"${TCP_PORT}"}]},
     {log_levels, [${LOG_LEVEL}]},
     {reverse_dns_lookups, $REV_DNS},
%% SSL CONFIGURATION
$SSL_CONFIG
     {auth_mechanisms, ${AUTH_MECHANISMS}},
%% DEFAULT USER 
     {default_vhost,       <<"/">>},
     {default_user,        <<"${USER}">>},
     {default_pass,        <<"${PASSWORD}">>},
     {default_permissions, [<<".*">>, <<".*">>, <<".*">>]},
     {default_user_tags, [administrator]},
     {heartbeat, ${HEARTBEAT}},
     {vm_memory_high_watermark, ${VM_MEM_HIGHT_WATERMARK}},
     {vm_memory_high_watermark_paging_ratio,${VM_MEM_HIGHT_WATERMARK_PAGING_RATIO} },
     {disk_free_limit, {mem_relative, ${MEM_RELATIVE}}}
    ]
 },
 {kernel,
   [
     {net_ticktime, ${NET_TICKTIME}},
     {inet_dist_listen_max, ${ERLANG_KERNEL_PORT_MAX}},
     {inet_dist_listen_min, ${ERLANG_KERNEL_PORT_MIN}}, 
   ]
}

EOF



# Configure the Master section
if [ $MASTER=1 ]; then

  MANAGEMENT_CONFIG <<EOF

 %% RabbitMQ Management Plugin
 {rabbitmq_management,
  [ $LOAD_DEF="{load_definitions, "/custom_configs/${FILE_NAME}"},"
    {listener, [{port,     ${TCP_MANAGEMENT_PORT}},
                {ip,       ${TCP_MANAGEMENT_IP}},
                {ssl,      true},
                {ssl_opts, [{cacertfile, ${CACERTFILE}},
                            {certfile,   ${CERTFILE}},
                            {keyfile,    ${KEYFILE}}
                            ]
                }
               ]
    },
  ]
 }
EOF
fi











exit 0

