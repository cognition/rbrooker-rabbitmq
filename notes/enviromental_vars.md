## List of ALL Environmental Variables

All these flages can be altered with ```-e VAR="your_value" ``` in your 
```docker run ``` instantiation. 
Its not wise to alter most of these if you are not sure what you are doing. 
that said, this is probably the best way to test them out, in a safe environment. 

I have created another page with the most common variables you will want to alter. 



##### Key Config 
+  AMQP_IP_LISTEN     "0.0.0.0"
+  AMQP_TCP_PORT     "5672"

##### Authorisation
+  USER     "admin"
+  PASSWORD     "admin"
+  DEFAULT_USER_TAG     "['administrator']"
+  DEFAULT_VHOST     "/"
+  AUTH_BACKENDS     "[rabbit_auth_backend_internal,rabbitmq_auth_mechanism_ssl]"
+  AUTH_MECHANISMS     "['PLAIN','AMQPLAIN','EXTERNAL']"


##### Configuration 
+  CHANNEL_MAX     "128"
+  DISK_FREE_LIMIT_MEM_RELATIVE     "1.0"
+  FRAME_MAX     "131072"
+  HANDSHAKE_TIMEOUT     "10000"
+  HEARTBEAT     "600"
+  NUM_SSL_ACCEPTORS     "1"
+  NUM_TCP_ACCEPTORS     "10"
+  INITIAL_MAX_FRAME     "4096"
+  MEM_MONITOR_INTERVAL     "2500"
+  VM_MEM_HIGHT_WATERMARK     "0.5"
+  VM_MEM_HIGHT_WATERMARK_PAGING_RATIO     "0.6"

##### Log Details
+  LOG_LEVEL     "{connection,error},{channel,warning},{federation,warning}"

##### Erlang Kernel
+  NET_TICKTIME     "120"
+  ERLANG_KERNEL_PORT_MAX     "440010"
+  ERLANG_KERNEL_PORT_MIN     "440001"

##### OpenSSL Support
+  SSL     "true"
+  SSL_AMQP_IP_LISTEN     "0.0.0.0"
+  SSL_TCP_PORT     "5671"
+  SSL_CERT_LOGIN_FROM     "common_name"
+  SSL_CIPHER     "[{rsa,aes_256_cbc,sha256}]"
+  SSL_HANDSHAKE_TIMEOUT     "5000"
+  SSL_VERSION     "['tlsv1.2']"
+  REVERSE_DNS_LOOKUPS     "false"
+  FAIL_IF_NO_PEER_CERT     "true"
+  CACERTFILE     "/server/cacert.pem"
+  CERTFILE     "/server/cert.pem"
+  KEYFILE     "/server/key.pem"

##### This Container Flags
+  MASTER     1
+  FEDERATION     1
+  SHOVEL     0



##### Management Plugin 
+  MANAGEMENT_IP     "0.0.0.0"
+  MANAGEMENT_PORT     "15672"
+  HTTP_ACCESS_LOG_PATH     "/logs/access.log"

This Var is IMPORTANT you attach a Volume or Bind Directory 
that holds a copy of your exported configurations from the Management console, 
this way all your vhosts, users, policies, etc.. will be there on start up. 

+  LOAD_DEFINITIONS     "/custom_configs/schema.json"


##### Cluster Sepcific Variables
        some are from the rabbitmq.config and some are specific to this project
+  CLUSTER_AGENT     1
+  CLUSTER_NODE_NAMES     "'rabbit@node1','rabbit@node2','rabbit@node3','rabbit@node0'"
+  CLUSTER_KEEPALIVE_INTERVAL     "10000"
+  CLUSTER_NODE     "rabbit@${other_host_name}"
+  CLUSTER_PARTITION_HANDLING     "autoheal"
+  NODE_TYPE     "disc"