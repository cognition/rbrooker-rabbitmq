#!/bin/bash

# Written and Maintained by 
# Ramon Brooker rbrooker@aetherealmind.com 
# 2015 

DOCKER_IMAGE=rbrooker/rabbitmq

# ***************************  Variables you may want to Alter ***************************

NAME="rabbit"  
PASSWD="admin"
DOMAIN="bunny.hop"  # a local domain for clusting 
H_VOL_BASE=/opt/rabbitmq   # host directory path for mounting key guest directories 
H_AMQ_PORT=5672 # Host AMQ connection port
H_MAN_PORT=8080 #15672   # Host Management Console port

# --- KEEP AT 1 FOR NOW --- 
CLUSTER_SIZE=1
# --- ***************** ---






# Guest Directories
G_VOL_ETC=/etc/rabbitmq
G_VOL_LIB=/var/lib/rabbitmq

# Set Master 
MA=${NAME}
MA_LONG=$MA.${DOMAIN}


VOLS="-v ${H_VOL_BASE}/$MA/etc:${G_VOL_ETC} -v ${H_VOL_BASE}/$MA/var:${G_VOL_LIB}"
NAMES_HOSTS="--hostname=$MA --name=$MA  ${RESTART}"
MASTER_PARAMS="-p ${H_AMQ_PORT}:5672 -p ${H_MAN_PORT}:15672 -e RABBITMQ_PASS=${PASSWD} "
STND_PARAMS="-e RABBITMQ_USE_LONGNAME=true"
RESTART="--restart=\"always\""


echo " create master RabbitMQ Node -- $MA"

# master Node --> 
docker run -d -it $VOLS $NAMES_HOSTS $MASTER_PARAMS $STND_PARAMS -e HOSTNAME=$MA_LONG -e RABBITMQ_PASS="admin" -e CLUSTERED=0 $DOCKER_IMAGE
docker logs $MA
sleep 3
echo ""
echo "please wait....."
echo ""
docker restart $MA
echo "check logs"
docker logs $MA
sleep 4
if [ ! -f $H_VOL_BASE/$MA/var/.erlang.cookie ]; then
  echo "error with erlang.cookie for master node. Does not exist "
  exit 1
else
  echo ""
  for i in $(seq 1 $CLUSTER_SIZE); do
      sleep 2
      NODE=${NAME}$i
      VOLS="-v ${H_VOL_BASE}/${NODE}/etc:${G_VOL_ETC} -v ${H_VOL_BASE}/${NODE}/var:${G_VOL_LIB}"
      NAMES_HOSTS="--hostname=${NODE}  --name=${NODE}  ${RESTART}"
      _value=$(expr $i % 2)
      if [[ $_value -eq 0 ]]; then 
        NODE_TYPE_NAME="disc"
        NODE_TYPE=""
      else 
        NODE_TYPE_NAME="ram"
        NODE_TYPE="--ram"
      fi
      echo " create $i clustered node $NODE_TYPE_NAME"
      echo ""
      docker run -d -it $VOLS $NAMES_HOSTS  --link $MA:$MA_LONG $STND_PARAMS -e HOSTNAME=${NODE}.$DOMAIN -e CLUSTERED=1   $DOCKER_IMAGE
      echo ""
      echo ""
      sleep 3
      docker stop $NODE
      echo "copy over the erlang cookie"
      echo ""
      sudo  cp -f $H_VOL_BASE/$MA/var/.erlang.cookie  $H_VOL_BASE/$NODE/var/.erlang.cookie
      docker start $NODE
      sleep 2
      echo "stop app"
      echo ""
      docker exec -it $NODE rabbitmqctl stop_app 
      sleep 5
      echo "reset node for new cookie"
      docker exec -it $NODE rabbitmqctl reset
      echo ""
      echo "check on cluster status"
      docker exec -it $NODE rabbitmqctl cluster_status 
      echo ""
      echo "connect to $MA_LONG" 
      echo ""
      docker exec -it $NODE rabbitmqctl join_cluster $NODE_TYPE rabbit@$MA_LONG
      echo ""
      sleep 2 
      echo "connected "
      docker exec -it $NODE rabbitmqctl cluster_status
      echo "start app" 
      docker exec -it $NODE rabbitmqctl start_app
      docker restart $MA
      sleep 3
  done 
 # check on cluster status
  echo ""
  echo "Check Cluster Status"
  echo ""
  docker exec -it $MA rabbitmqctl cluster_status
fi
echo ""
echo "add RabbitMQ Admin Tools and Bash Completions to PATH"
if [[ ! -f /etc/bash_completion.d/rabbit.bash-completion ]]
then
  sudo cp rabbit.bash-completion /etc/bash_completion.d/
  source ~/.bashrc 
fi
if [[ ! -f /usr/bin/rabbitmqadmin ]]
then
  sudo cp rabbitmqadmin /usr/bin/
fi

echo "copying over the config file"
echo 
cat > ~/.rabbitmqadmin.config <<EOF
[${MA}]
hostname = 0.0.0.0
port = ${H_MAN_PORT} 
username = admin
password = ${PASSWD}
vhost = / 
EOF

echo ""
echo "testing cli tool"
rabbitmqadmin -c ~/.rabbitmqadmin.config -N ${MA} list exchanges 

echo ""
echo "Find the rabbit management console on port ${H_MAN_PORT}"
echo "  and password $PASSWD -- please change it. "


exit 0
