#!/bin/bash

# Written and Maintained by 
# Ramon Brooker rbrooker@aetherealmind.com 
# 2016 

DOCKER_IMAGE=rbrooker/rabbitmq

## ***************************  Variables you may want to Alter ***************************
#

RABBIT_VERSION="3.6.2-1"
#RABBIT_VERSION="latest"



NAME="roger"  

MANAGEMENT=1

# RabbitMQ default Credentials
RABBITMQ_USER="admin"
RABBITMQ_PASS="admin"



HOST_VOL_DIR_ROOT="/opt/docker/${NAME}"   # host directory path for mounting key guest directories 

# Exposed Ports 
# Change only if you want to expose non-standard ports 
AMQP_PORT=5672 	          # AMQP connection port
MANAGEMENT_PORT=15672     # Management Console port
CLUSTER_PORT=44001

# Plugins Shovel or Federation or Both
SHOVEL=1
FEDERATION=1
AUTO_RESTART=1


# Advanced 

 
# ** Only use if you have a cluster host you wish to connect
# if you aren't using it leave it blank
ERLANG_COOKIE=   

#  SSL Cert Support 
SSL=0 # 
SSL_AMQP_PORT=5671   


# Host Directories Mount Directories

# Config Directory
HOST_VOL_ETC="${HOST_VOL_DIR_ROOT}/configs"

# Mnesia Directory [default not used - cattle/pet]
HOST_VOL_LIB="${HOST_VOL_DIR_ROOT}/mnesia"

# Logs
HOST_VOL_LOGS="${HOST_VOL_DIR_ROOT}/logs"

# SSL Cert Root Dir   -- not based on container name, since many want to mount many times
# suggest action is to create a docker vol with just this directory to mount 

HOST_VOL_CERTS="/opt/certs" 


#  ************************************   don't alter below ******************************

# for CentOS 
ETC_VOLS="--volume ${HOST_VOL_ETC}:/etc/rabbitmq:Z "
LOG_VOLS="--volume ${HOST_VOL_LOGS}:/var/log/rabbitmq:Z "
SSL_VOLS="--volume ${HOST_VOL_CERTS}:/certs:Z "


OPTIONS=""
if [ $SHOVEL = 1 ]; then
  OPTIONS+="-e SHOVEL=$SHOVEL "
fi
if [ $FEDERATION = 1 ]; then 
  OPTIONS+="-e FEDERATION=$FEDERATION "
fi
OPTIONS+=" -e RABBITMQ_USER=\"$RABBITMQ_USER\" -e RABBITMQ_PASS=\"$RABBITMQ_PASS\" "

HOSTNAME="--hostname=${NAME}"
NAME="--name=$NAME "


PORTS="-p ${HOST_AMQP_PORT}:5672 -p ${CLUSTER_PORT}:44001 " 
if [ $MANAGEMENT = 1 ]; then 
  PORTS+="-p ${HOST_MANAGEMENT_PORT}:15672 "
fi
if [ $SSL = 1 ]; then
  PORTS+="-p ${SSL_AMQP_PORT}:5671 "
fi

RESTART=""
if [ $AUTO_RESTART = 1 ]; then 
    RESTART="--restart=\"always\" "
fi

sudo mkdir -p  ${HOST_VOL_DIR_ROOT} ; sudo mkdir -p ${HOST_VOL_ETC} ; sudo mkdir -p ${HOST_VOL_LOGS}
# To allow mounting of the Drive
sudo chcon -Rt svirt_sandbox_file_t ${HOST_VOL_DIR_ROOT}  

echo " docker run -it -d $ETC_VOLS $LOG_VOLS $NAME $HOSTNAME $OPTIONS $RESTART ${DOCKER_IMAGE}:${RABBIT_VERSION} "

exit 0
