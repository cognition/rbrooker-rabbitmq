#!/bin/bash

echo "make a volume for certificates" 
docker volume create --name my-cert-volume
docker run -v my-cert-volume:/server --name cert-container ubuntu /bin/true 
docker cp certs/* cert-container:/server/ 

docker volume inspect my-cert-volume | grep Mountpoint
echo "verify they are all there" 
sudo ls -R /var/lib/docker/volumes/my-cert-volume/_data/

# Note:
# ' --name ' is for the name of the Docker container
# ' --hostname ' is for the container ( if not set the container id is used ) 
# --env-file= all parts prefixed with -e can be put in a separt file 
#             see test-deployment-env-file


docker run -d -it \
  -v /opt/rabbitmq/rabbit/etc:/etc/rabbitmq \
  -v /opt/rabbitmq/rabbit/log:/var/log/rabbitmq \
  --volumes-from cert-container:ro \
  --hostname=buggs.bunny \
  --name=rabbit \
  -p 5672:5672 -p 15672:15672 -p 5671:5671 \
  -e RABBITMQ_PASS=admin \
  -e RABBITMQ_USER=admin \
  -e CLUSTERED=0 \
  -e SSL=1 \
  -e SHOVEL=0 \
  -e FED=1 \
  -e MASTER=1 \
  rbrooker/rabbitmq
