#!/bin/bash 

echo "setting up RabbitMQ with " 

cat > rabbitmq.config <<EOF
                                      
%% -*- mode: erlang -*-
%% ----------------------------------------------------------------------------
%% RabbitMQ Sample Configuration File.
%%
%% See http://www.rabbitmq.com/configure.html for details.
%% ----------------------------------------------------------------------------
[
 {rabbit,
  [%%
   %% Network Connectivity
   %% ====================
   %%

   %% By default, RabbitMQ will listen on all interfaces, using
   %% the standard (reserved) AMQP port.
   %%
   %% {tcp_listeners, [5672]},
      {tcp_listeners, [{"${AMQP_IP_LISTEN}", ${AMQP_TCP_PORT} },
                       {"${AMQP_IP_LISTEN_6}",${AMQP_TCP_PORT} }
                      ]
      },
   %% To listen on a specific interface, provide a tuple of {IpAddress, Port}.
   %% For example, to listen only on localhost for both IPv4 and IPv6:
   %%
   %% {tcp_listeners, [{"127.0.0.1", 5672},
   %%                  {"::1",       5672}]},

   %% SSL listeners are configured in the same fashion as TCP listeners,
   %% including the option to control the choice of interface.
   %%
   %% {ssl_listeners, [5671]},
      {ssl_listeners, [{"${SSL_AMQP_IP_LISTEN}",${SSL_TCP_PORT} },
                       {"${SSL_AMQP_IP_LISTEN_6}",${SSL_TCP_PORT}}
                      ]
      },
       
   %% Number of Erlang processes that will accept connections for the TCP
   %% and SSL listeners.
   %%
   {num_tcp_acceptors, ${NUM_TCP_ACCEPTORS} },
   {num_ssl_acceptors, ${NUM_SSL_ACCEPTORS} },

   %% Maximum time for AMQP 0-8/0-9/0-9-1 handshake (after socket connection
   %% and SSL handshake), in milliseconds.
   %%
   {handshake_timeout, ${HANDSHAKE_TIMEOUT}},

   %% Log levels (currently just used for connection logging).
   %% One of 'debug', 'info', 'warning', 'error' or 'none', in decreasing
   %% order of verbosity. Defaults to 'info'.
   %%
   %% {log_levels, [{connection, info}, {channel, info}]},
      {log_levels, ${LOG_LEVEL}},
   %% Set to 'true' to perform reverse DNS lookups when accepting a
   %% connection. Hostnames will then be shown instead of IP addresses
   %% in rabbitmqctl and the management plugin.
   %%
     {reverse_dns_lookups, ${REVERSE_DNS_LOOKUPS}},

   %%
   %% Security / AAA
   %% ==============
   %%

   %% The default "guest" user is only permitted to access the server
   %% via a loopback interface (e.g. localhost).
   %% {loopback_users, [<<"guest">>]},
   %%
   %% Uncomment the following line if you want to allow access to the
   %% guest user from anywhere on the network.
   %% {loopback_users, []},

   %% Configuring SSL.
   %% See http://www.rabbitmq.com/ssl.html for full documentation.
   %%
   %% {ssl_options, [{cacertfile,           "/path/to/testca/cacert.pem"},
   %%                {certfile,             "/path/to/server/cert.pem"},
   %%                {keyfile,              "/path/to/server/key.pem"},
   %%                {verify,               verify_peer},
   %%                {fail_if_no_peer_cert, false}]},
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
   %% Choose the available SASL mechanism(s) to expose.
   %% The two default (built in) mechanisms are 'PLAIN' and
   %% 'AMQPLAIN'. Additional mechanisms can be added via
   %% plugins.
   %%
   %% See http://www.rabbitmq.com/authentication.html for more details.
   %%
   {auth_mechanisms, ${AUTH_MECHANISMS}},

   %% Select an authentication database to use. RabbitMQ comes bundled
   %% with a built-in auth-database, based on mnesia.
   %%
   {auth_backends, ${AUTH_BACKENDS}},

   %% NB: These options require that the relevant plugin is enabled.
   %% See http://www.rabbitmq.com/plugins.html for further details.

   %% The RabbitMQ-auth-mechanism-ssl plugin makes it possible to
   %% authenticate a user based on the client's SSL certificate.
   %%
   %% To use auth-mechanism-ssl, add to or replace the auth_mechanisms
   %% list with the entry 'EXTERNAL'.

   %% To use the SSL cert's CN instead of its DN as the username
   %%
   {ssl_cert_login_from, ${SSL_CERT_LOGIN_FROM}},

   %% SSL handshake timeout, in milliseconds.
   %%
   {ssl_handshake_timeout, ${SSL_HANDSHAKE_TIMACERTFILE}},

   %% Password hashing implementation. Will only affect newly
   %% created users. To recalculate hash for an existing user
   %% it's necessary to update her password.
   %%
   {password_hashing_module, rabbit_password_hashing_sha256},

   %%
   %% Default User / VHost
   %% ====================
   %%

   %% On first start RabbitMQ will create a vhost and a user. These
   %% config items control what gets created. See
   %% http://www.rabbitmq.com/access-control.html for further
   %% information about vhosts and access control.
   %%
    {default_vhost,       <<"${DEFAULT_VHOST}">>},
    {default_user,        <<"${USER}">>},
    {default_pass,        <<"${PASSWORD}">>},
    {default_permissions, [<<".*">>, <<".*">>, <<".*">>]},

   %% Tags for default user
   %%
   %% For more details about tags, see the documentation for the
   %% Management Plugin at http://www.rabbitmq.com/management.html.
   %%
   {default_user_tags,${DEFAULT_USER_TAG}},

   %%
   %% Additional network and protocol related configuration
   %% =====================================================
   %%

   %% Set the default AMQP heartbeat delay (in seconds).
   %%
   {heartbeat, ${HEARTBEAT},

   %% Set the max permissible size of an AMQP frame (in bytes).
   %%
   {frame_max, ${FRAME_MAX}},

   %% Set the max frame size the server will accept before connection
   %% tuning occurs
   %%
   {initial_frame_max, ${INITIAL_MAX_FRAME}},

   %% Set the max permissible number of channels per connection.
   %% 0 means "no limit".
   %%
   {channel_max, ${CHANNEL_MAX}},

    %% Message TTL 
   {message-ttl,${MESSAGE_TTL}},
     
   %% Queues Expires
   {expires,${EXPIRES}},
     
   %% Customising Socket Options.
   %%
   %% See (http://www.erlang.org/doc/man/inet.html#setopts-2) for
   %% further documentation.
   %%
   %% {tcp_listen_options, [{backlog,       128},
   %%                       {nodelay,       true},
   %%                       {exit_on_close, false}]},

   %%
   %% Resource Limits & Flow Control
   %% ==============================
   %%
   %% See http://www.rabbitmq.com/memory.html for full details.

   %% Memory-based Flow Control threshold.
   %%
   %%

   {vm_memory_high_watermark,${VM_MEM_HIGHT_WATERMARK}},

   %% Alternatively, we can set a limit (in bytes) of RAM used by the node.
   %%
   %% {vm_memory_high_watermark, {absolute, 1073741824}},
   %%
   %% Or you can set absolute value using memory units.
   %%
   %% {vm_memory_high_watermark, {absolute, "1024M"}},
   %%
   %% Supported units suffixes:
   %%
   %% k, kiB: kibibytes (2^10 bytes)
   %% M, MiB: mebibytes (2^20)
   %% G, GiB: gibibytes (2^30)
   %% kB: kilobytes (10^3)
   %% MB: megabytes (10^6)
   %% GB: gigabytes (10^9)

   %% Fraction of the high watermark limit at which queues start to
   %% page message out to disc in order to free up memory.
   %%
   %% Values greater than 0.9 can be dangerous and should be used carefully.

   {vm_memory_high_watermark_paging_ratio, ${VM_MEM_HIGHT_WATERMARK_PAGING_RATIO}},

   %% Interval (in milliseconds) at which we perform the check of the memory
   %% levels against the watermarks.
   %%
   %% {memory_monitor_interval, ${MEM_MONITOR_INTERVAL} },

   %% Set disk free limit (in bytes). Once free disk space reaches this
   %% lower bound, a disk alarm will be set - see the documentation
   %% listed above for more details.
   %%
   %%
   %% Or you can set it using memory units (same as in vm_memory_high_watermark)
   %% {disk_free_limit, "50MB"},
   %% {disk_free_limit, "50000kB"},
   %% {disk_free_limit, "2GB"},

   %% Alternatively, we can set a limit relative to total available RAM.
   %%
   %% Values lower than 1.0 can be dangerous and should be used carefully.

   
   {disk_free_limit, {mem_relative, ${DISK_FREE_LIMIT_MEM_RELATIVE} } },

   %%
   %% Misc/Advanced Options
   %% =====================
   %%
   %% NB: Change these only if you understand what you are doing!
   %%

   %% To announce custom properties to clients on connection:
   %%
   %% {server_properties, []},

   %% How to respond to cluster partitions.
   %% See http://www.rabbitmq.com/partitions.html for further details.
   %%
   {cluster_partition_handling,${CLUSTER_PARTITION_HANDLING} },

   %% Make clustering happen *automatically* at startup - only applied
   %% to nodes that have just been reset or started for the first time.
   %% See http://www.rabbitmq.com/clustering.html#auto-config for
   %% further details.
   %%
   {cluster_nodes, {['${CLUSTER_NODE}'], ${NODE_TYPE}}},


   %% Interval (in milliseconds) at which we send keepalive messages
   %% to other cluster members. Note that this is not the same thing
   %% as net_ticktime; missed keepalive messages will not cause nodes
   %% to be considered down.
   %%
   {cluster_keepalive_interval, ${CLUSTER_KEEPALIVE_INTERVAL}},

   %% Set (internal) statistics collection granularity.
   %%
   %% {collect_statistics, none},

   %% Statistics collection interval (in milliseconds).
   %%
   %% {collect_statistics_interval, 5000},

   %% Explicitly enable/disable hipe compilation.
   %%
   %% {hipe_compile, true},

   %% Timeout used when waiting for Mnesia tables in a cluster to
   %% become available.
   %%
   %% {mnesia_table_loading_timeout, 30000},

   %% Size in bytes below which to embed messages in the queue index. See
   %% http://www.rabbitmq.com/persistence-conf.html
   %%
   %% {queue_index_embed_msgs_below, 4096}

  ]},

 %% ----------------------------------------------------------------------------
 %% Advanced Erlang Networking/Clustering Options.
 %%
 %% See http://www.rabbitmq.com/clustering.html for details
 %% ----------------------------------------------------------------------------
 {kernel,
  [%% Sets the net_kernel tick time.
   %% Please see http://erlang.org/doc/man/kernel_app.html and
   %% http://www.rabbitmq.com/nettick.html for further details.
   %%
    { net_ticktime,${NET_TICKTIME}},
     {inet_dist_listen_max, ${ERLANG_KERNEL_PORT_MAX} },
     {inet_dist_listen_min, ${ERLANG_KERNEL_PORT_MIN} }, 
  ]},

 %% ----------------------------------------------------------------------------
 %% RabbitMQ Management Plugin
 %%
 %% See http://www.rabbitmq.com/management.html for details
 %% ----------------------------------------------------------------------------

 {rabbitmq_management,
  [%% Pre-Load schema definitions from the following JSON file. See
   %% http://www.rabbitmq.com/management.html#load-definitions
   %%
   {load_definitions,"${LOAD_DEFINITIONS}" },

   %% Log all requests to the management HTTP API to a file.
   %%
   {http_log_dir, "${HTTP_ACCESS_LOG_PATH}" },

   %% Change the port on which the HTTP listener listens,
   %% specifying an interface for the web server to bind to.
   %% Also set the listener to use SSL and provide SSL options.
   %%
    {listener, [{port,  ${MANAGEMENT_PORT}},
                {ip,   "${MANAGEMENT_IP}"},
                {ssl,   ${SSL} },
                {ssl_opts, 
                  [{cacertfile,"${CACERTFILE}"},
                            {certfile,"${CERTFILE}"},
                            {keyfile,"${KEYFILE}"}
                           ]
                }
              ]
    },

   %% One of 'basic', 'detailed' or 'none'. See
   %% http://www.rabbitmq.com/management.html#fine-stats for more details.
   %% {rates_mode, basic},

   %% Configure how long aggregated data (such as message rates and queue
   %% lengths) is retained. Please read the plugin's documentation in
   %% http://www.rabbitmq.com/management.html#configuration for more
   %% details.
   %%
   %% {sample_retention_policies,
   %%  [{global,   [{60, 5}, {3600, 60}, {86400, 1200}]},
   %%   {basic,    [{60, 5}, {3600, 60}]},
   %%   {detailed, [{10, 5}]}]}
  ]},

 %% ----------------------------------------------------------------------------
 %% RabbitMQ Shovel Plugin
 %%
 %% See http://www.rabbitmq.com/shovel.html for details
 %% ----------------------------------------------------------------------------

%% {rabbitmq_shovel,
 %% [{shovels,
   %% [%% A named shovel worker.
     %% {my_first_shovel,
     %%  [

     %% List the source broker(s) from which to consume.
     %%
     %%   {sources,
     %%    [%% URI(s) and pre-declarations for all source broker(s).
     %%     {brokers, ["amqp://user:password@host.domain/my_vhost"]},
     %%     {declarations, []}
     %%    ]},

     %% List the destination broker(s) to publish to.
     %%   {destinations,
     %%    [%% A singular version of the 'brokers' element.
     %%     {broker, "amqp://"},
     %%     {declarations, []}
     %%    ]},

     %% Name of the queue to shovel messages from.
     %%
     %% {queue, <<"your-queue-name-goes-here">>},

     %% Optional prefetch count.
     %%
     %% {prefetch_count, 10},

     %% when to acknowledge messages:
     %% - no_ack: never (auto)
     %% - on_publish: after each message is republished
     %% - on_confirm: when the destination broker confirms receipt
     %%
     %% {ack_mode, on_confirm},

     %% Overwrite fields of the outbound basic.publish.
     %%
     %% {publish_fields, [{exchange,    <<"my_exchange">>},
     %%                   {routing_key, <<"from_shovel">>}]},

     %% Static list of basic.properties to set on re-publication.
     %%
     %% {publish_properties, [{delivery_mode, 2}]},

     %% The number of seconds to wait before attempting to
     %% reconnect in the event of a connection failure.
     %%
     %% {reconnect_delay, 2.5}

     %% ]} %% End of my_first_shovel
  %%  ]}
   %% Rather than specifying some values per-shovel, you can specify
   %% them for all shovels here.
   %%
  %% {defaults, [{prefetch_count,     0},
  %%              {ack_mode,           on_confirm},
  %%              {publish_fields,     []},
  %%              {publish_properties, [{delivery_mode, 2}]},
  %%              {reconnect_delay,    2.5}]}
 %% ]}
].

%% NOTE THE REMAINING CONFIGURATION HAS BEEN REMOVED 

EOF

