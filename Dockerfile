FROM ubuntu
MAINTAINER Ramon Brooker <rbrooker@aetherealmind.com>

ENV DEBIAN_FRONTEND noninteractive
ENV RABBITMQ_VERSION="3.5.7-1"

# for setting
LABEL rabbit_version.major="3.5" \
      rabbit_version.minor="3.5.7-1" 

# IPv6 Env have been removed untill the support for IPv6 is stable in Erlang
# Environmental Values, sporting defauls, but allowing for configuration at run
ENV AMQP_IP_LISTEN="0.0.0.0" AMQP_TCP_PORT="5672" AUTH_BACKENDS="[rabbit_auth_backend_internal,rabbitmq_auth_mechanism_ssl]" AUTH_MECHANISMS="['PLAIN','AMQPLAIN','EXTERNAL']" CACERTFILE="/server/cacert.pem" CERTFILE="/server/cert.pem" CHANNEL_MAX="128" CLUSTER_KEEPALIVE_INTERVAL="10000" CLUSTER_PARTITION_HANDLING="autoheal" DEFAULT_USER_TAG="['administrator']" DEFAULT_VHOST="/" DISK_FREE_LIMIT_MEM_RELATIVE="1.0" ERLANG_KERNEL_PORT_MAX="44010" ERLANG_KERNEL_PORT_MIN="44001" EXPIRES="36000" FAIL_IF_NO_PEER_CERT="true" FRAME_MAX="131072" HANDSHAKE_TIMEOUT="10000" HEARTBEAT="600" HTTP_ACCESS_LOG_PATH="/logs/access.log" INITIAL_MAX_FRAME="4096" KEYFILE="/server/key.pem" LOAD_DEFINITIONS="nil" LOG_LEVEL="{connection,error},{channel,warning},{federation,warning}" MANAGEMENT_IP="0.0.0.0" MANAGEMENT_PORT="15672" MEM_MONITOR_INTERVAL="2500" MESSAGE_TTL="36000" NET_TICKTIME="120" NODE_TYPE="disc" NUM_SSL_ACCEPTORS="1" NUM_TCP_ACCEPTORS="10" PASSWORD="admin" REVERSE_DNS_LOOKUPS="false" SSL="false" SSL_AMQP_IP_LISTEN="0.0.0.0" SSL_CERT_LOGIN_FROM="common_name" SSL_CIPHER="[{rsa,aes_256_cbc,sha256}]" SSL_HANDSHAKE_TIMEOUT="5000" SSL_TCP_PORT="5671" SSL_VERSION="['tlsv1.2']" USER="admin" VM_MEM_HIGHT_WATERMARK="0.5" VM_MEM_HIGHT_WATERMARK_PAGING_RATIO="0.6" MASTER=1 FEDERATION=1 SHOVEL=0 CLUSTER_AGENT=0 MASTER_NAME='master'


# to allow updates to be installed
RUN echo exit 1 > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

# Install Updates, and other needed prgms
RUN apt-get update ; apt-get -y install logrotate wget apt-utils apt-transport-https; apt-get -y upgrade


# Install RabbitMQ

RUN wget -O-  https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add - 
RUN wget -O-  https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add - 
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" | tee /etc/apt/sources.list.d/rabbitmq.list  
RUN echo "deb https://packages.erlang-solutions.com/ubuntu/ xenial contrib" | tee /etc/apt/sources.list.d/erlang.list 
# Ensure APT installs from the proper repos
ADD preferences /etc/apt/preferences  
RUN apt-get update; apt-get install -y rabbitmq-server=$RABBITMQ_VERSION

# clean extra-files 
RUN  apt-get autoremove -y ; apt-get clean && rm -rf /var/lib/apt/lists/*

ENV ERLANG_COOKIE="BAI0VA7ROHXEOQUASH6AIRAGHE9NOH0EOQUAECIE"

ADD server/ /

ADD src/ /
RUN  /set-time.sh


VOLUME ["/etc/rabbitmq","/var/log/rabbitmq","/server","/var/lib/rabbitmq","/logs","/custom_config"]

EXPOSE 5671 5672 15672 44001-44010

CMD ["/run.sh"]


