#!/bin/bash 


echo "++ rabbitmq.config.sh ++"
cat > rabbitmq.config.0 <<EOF
                                      
%% -*- mode: erlang -*-
%% ----------------------------------------------------------------------------
[
 {rabbit,
  [
      {tcp_listeners, [{"${AMQP_IP_LISTEN}", ${AMQP_TCP_PORT}}]},
      {ssl_listeners, [{"${SSL_AMQP_IP_LISTEN}",${SSL_TCP_PORT}}]},
      %% IPv6 References have been removed untill the bugs with the Erlang Libs RabbitMQ 
      %% requires have fixed the issues with referencing both IPv4 and IPv6 in the same config 
      %% pointing at the same object.
      {num_tcp_acceptors, ${NUM_TCP_ACCEPTORS}},
      {num_ssl_acceptors, ${NUM_SSL_ACCEPTORS}},
      {log_levels, [${LOG_LEVEL}]},
      {reverse_dns_lookups, ${REVERSE_DNS_LOOKUPS}},
      {ssl_options, [
                {cacertfile,"${CACERTFILE}"},
                {certfile,"${CERTFILE}"},
                {keyfile,"${KEYFILE}"},
                {verify,verify_peer},
                {fail_if_no_peer_cert,${FAIL_IF_NO_PEER_CERT}}
              ]
      },
      {versions, ${SSL_VERSION}},
      {ciphers,  ${SSL_CIPHER}},
      {auth_mechanisms, ${AUTH_MECHANISMS}},
      {auth_backends, ${AUTH_BACKENDS}},
      {ssl_cert_login_from, ${SSL_CERT_LOGIN_FROM}},
      {ssl_handshake_timeout, ${SSL_HANDSHAKE_TIMEOUT}},
      {password_hashing_module, rabbit_password_hashing_sha256},
      {default_vhost,       <<"${DEFAULT_VHOST}">>},
      {default_user,        <<"${USER}">>},
      {default_pass,        <<"${PASSWORD}">>},
      {default_permissions, [<<".*">>, <<".*">>, <<".*">>]},
      {default_user_tags,${DEFAULT_USER_TAG}},
   %%
   %% Additional network and protocol related configuration
   %% =====================================================
   %%
       {heartbeat, ${HEARTBEAT}},
       {frame_max, ${FRAME_MAX}},
       {initial_frame_max, ${INITIAL_MAX_FRAME}},
       {channel_max, ${CHANNEL_MAX}},
       {vm_memory_high_watermark,${VM_MEM_HIGHT_WATERMARK}},
       {vm_memory_high_watermark_paging_ratio, ${VM_MEM_HIGHT_WATERMARK_PAGING_RATIO}},
       {memory_monitor_interval, ${MEM_MONITOR_INTERVAL}},
       {disk_free_limit, {mem_relative, ${DISK_FREE_LIMIT_MEM_RELATIVE}}},
       {cluster_partition_handling,${CLUSTER_PARTITION_HANDLING}}, 

       %%SUB_CLUSTER_NODE_DETAILS_HERE 

       {cluster_keepalive_interval, ${CLUSTER_KEEPALIVE_INTERVAL}},
       {collect_statistics, none}
  ]},
 %% ----------------------------------------------------------------------------
 %% Advanced Erlang Networking/Clustering Options.
 %%
 %% See http://www.rabbitmq.com/clustering.html for details
 %% ----------------------------------------------------------------------------
 {kernel,
  [
    {net_ticktime,${NET_TICKTIME}},
    {inet_dist_listen_max, ${ERLANG_KERNEL_PORT_MAX}},
    {inet_dist_listen_min, ${ERLANG_KERNEL_PORT_MIN}} 
  ]
 },
 %% ----------------------------------------------------------------------------
 %% RabbitMQ Management Plugin
 %% ----------------------------------------------------------------------------
 {rabbitmq_management,
  [
   %%LOAD_DEFINITIONS_HERE

   {http_log_dir, "${HTTP_ACCESS_LOG_PATH}"},
   {listener, [ {port,  ${MANAGEMENT_PORT}},
                {ip,   "${MANAGEMENT_IP}"},
                {ssl,   ${SSL}},
                {ssl_opts, 
                  [{cacertfile,"${CACERTFILE}"},
                   {certfile,"${CERTFILE}"},
                   {keyfile,"${KEYFILE}"}
                  ]
                }
              ]
    }
  ]
 }
].
EOF

echo "-- rabbitmq.config --" 
exit $?
