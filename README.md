RabbitMQ      -- NOT FOR PRODUCTION  
=====================

RabbitMQ v 3.6.2-1 
* RabbitMQ Project
* Erlang Solutions 
Optional
* SSL
* Shovel
* Federation


Usage
-----
```
docker run -d -it \
    -v /opt/rabbitmq/rabbit/etc:/etc/rabbitmq  \
    -v /opt/rabbitmq/rabbit/log:/var/log/rabbitmq \
    --hostname=rabbit  \
    --name=rabbit  \
    -p 5672:5672 -p 15672:15672 -p 5671:5671 \ 
    -e HOSTNAME=rabbit.bunny.hop \ 
    -e RABBITMQ_PASS=admin \
    -e RABBITMQ_USER=admin \
    -e CLUSTERED=0 \
    -e SSL=1 \
    -e SHOVEL=1 \
    -e FED=1\
    -e MASTER=1 \
    rbrooker/rabbitmq:3.6.2-1 

```
### Notes about SSL 
I used the SSL Cert creation from http://www.rabbitmq.com/ssl.html

Please remember to mount to your own volumes with your own keys the ones I'm using are dummy self signed
I suggest make a docker volume to store your certificates
```
docker volume create --name my-cert-volume
docker run -v my-cert-volume:/server --name cert-container ubuntu /bin/true 
docker cp certs/* cert-container:/server/ 
docker volume inspect my-cert-volume | grep Mountpoint
# from the information found in the above -- most likely similar
sudo ls /var/lib/docker/volumes/my-cert-volume/_data/
```

## Start run/create an instance 
```
docker run -d -it \
   -v /opt/rabbitmq/rabbit/etc:/etc/rabbitmq  \
   -v /opt/rabbitmq/rabbit/log:/var/log/rabbitmq \
   --volumes-from cert-container:ro \
   --hostname=rabbit  \
   --name=rabbit  \
   -p 5672:5672 -p 15672:15672 -p 5671:5671 \ 
   -e HOSTNAME=rabbit.bunny.hop \ 
   -e RABBITMQ_PASS=admin \
   -e RABBITMQ_USER=admin \
   -e CLUSTERED=0 \
   -e SSL=1 \
   -e SHOVEL=1 \
   -e FED=1 \
   -e MASTER=1 \
  rbrooker/rabbitmq:3.6.2-1 
```
### Environment Variables 
I have open access to most environment variables; so they can be inserted at run. 
The full list of them can be found in ```tests/environemental_vars```   
as well as in the Wiki


### Note assumption for volume cert directory structure 
/server/cacert.pem 
/server/cert.pem
/server/key.pem





###  to Bake them in for your own local registry
```
git clone https://github.com/cognition/rbrooker-rabbitmq my-rabbitmq 
cd my-rabbitmq
git branch my-secrets-branch
git checkout my-secrets-branch
cp ../my-cacert.pem testca/cacert.pem
cp ../my-server-cert.pem server/cert.pem
cp ../my-server-key.pem server/key.pem 
docker build -t my-rabbitmq:0 -t my-rabbitmq . 

```


Usage with a Cluster 
---------------------
[TO UPDATE] -- not tested with changes -- see install.sh in the github repo 
https://github.com/cognition/rbrooker-rabbitmq



Notes 
-----

Currently I am not able to get more than two rabbitmq nodes active in a cluster. 
I am working on this and hopefully be updating soon. 

Maintained by  
-------------

Ramon Brooker <rbrooker@aetherealmind.com>


[![GetBadges Game](https://cognition-rbrooker-rabbitmq.getbadges.io/shield/company/cognition-rbrooker-rabbitmq/user/5992)](https://cognition-rbrooker-rabbitmq.getbadges.io/?ref=shield-player)

