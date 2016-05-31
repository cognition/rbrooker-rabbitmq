RabbitMQ 
=====================

Base docker image to run a RabbitMQ server version 3.6.2-1

Usage
-----
```
docker run -d -it \
    -v /opt/rabbitmq/rabbit/etc:/etc/rabbitmq  \
    -v /opt/rabbitmq/rabbit/var:/var/lib/rabbitmq \ 
    -v /opt/rabbitmq/rabbit/log:/var/log/rabbitmq \
    -v /opt/rabbitmq/certs/<yourServerKey>:/server \
    -v /opt/rabbitmq/certs/<yourCAcert>:/testca \
    --hostname=rabbit  \
    --name=rabbit  \
    -p 5672:5672 -p 15672:15672 -p 5671:5671 \
    -e RABBITMQ_PASS=admin   \
    -e RABBITMQ_USE_LONGNAME=true \ 
    -e HOSTNAME=rabbit.bunny.hop \ 
    -e RABBITMQ_PASS=admin 
    -e CLUSTERED=0 rbrooker/rabbitmq:2
    -e SHOVEL=1, -e FED=1, MASTER=1
```

I used the SSL Cert creation from 
http://www.rabbitmq.com/ssl.html
Please remeber to mount to your own volumes with your own keys, or substitue them in and build your own from the source: 
example: 

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




