FROM ubuntu
MAINTAINER Ramon Brooker <rbrooker@aetherealmind.com>

ENV DEBIAN_FRONTEND noninteractive


# for setting
LABEL rabbit_version.major="3.6" \
      rabbit_version.minor="3.6.2-1" 

# Environmental Values, sporting defauls, but allowing for configuration at run
ENV MASTER=1 FEDERATION=0 SHOVEL=0 USER="admin" PASSWORD="admin" HEARTBEAT=600 CLUSTER_AGENT=1 LOG_LEVEL="{connection,warning},{channel,info}" TCP_PORT=5672 SSL_TCP_PORT=5671 ERLANG_KERNEL_PORT_MAX=44010 ERLANG_KERNEL_PORT_MIN=44001 NET_TICKTIME=120 NODE_TYPE="disc" CLUSTER_KEEPALIVE_INTERVAL=10000 VM_MEM_HIGHT_WATERMARK="0.5" VM_MEM_HIGHT_WATERMARK_PAGING_RATIO="0.6" REVERSE_DNS_LOOKUPS="true" MEM_RELATIVE="1.0" AUTH_MECHANISMS="['PLAIN','AMQPLAIN','EXTERNAL']" TCP_MANAGEMENT_PORT=15672 TCP_MANAGEMENT_IP="0.0.0.0" SSL=0 CACERTFILE="/server/cacert.pem" CERTFILE="/server/cert.pem" KEYFILE="/server/key.pem" SSL_CERT_LOGIN_FROM="common_name" FAIL_IF_NO_PEER_CERT="false" SSL_HANDSHAKE_TIMEOUT=5000 NUM_TCP_ACCEPTORS=10 NUM_SSL_ACCEPTORS=1 ERLANG_COOKIE="BAI0VA7ROHXEOQUASH6AIRAGHE9NOH0EOQUAECIE" R_VERISON_MINOR="3.6.2-1"

# to allow updates to be installed
RUN echo exit 1 > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

# Install Updates, and other needed prgms
RUN apt-get update ; apt-get -y install logrotate wget apt-utils; apt-get -y upgrade


# Install RabbitMQ

RUN wget -O-  https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add - 
RUN wget -O-  https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add - 
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" | tee /etc/apt/sources.list.d/rabbitmq.list  
RUN echo "deb https://packages.erlang-solutions.com/ubuntu xenial contrib" tee /etc/apt/sources.list.d/erlang.list 
RUN apt-get update; apt-get install -y rabbitmq-server=$R_VERISON_MINOR 

# clean extra-files 
RUN  apt-get autoremove -y ; apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo $ERLANG_COOKIE > /var/lib/rabbitmq/.erlang.cookie; chmod 400 /var/lib/rabbitmq/.erlang.cookie; chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/ 


ENV CLUSTER=0 NODE_TYPE="disc" CLUSTER_NODE_NAME="" FILE_NAME="" 



ADD src/ /

RUN  /set-time.sh


VOLUME ["/etc/rabbitmq","/var/log/rabbitmq","/server","/var/lib/rabbitmq"]

EXPOSE 5672 15672 44001 5671

CMD ["/run.sh"]

