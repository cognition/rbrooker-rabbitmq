RabbitMQ 
=====================

Base docker image to run a RabbitMQ server version 3.5.3


Usage
-----
```
docker run -d -it \
    -v /opt/rabbitmq/rabbit/etc:/etc/rabbitmq  \
    -v /opt/rabbitmq/rabbit/var:/var/lib/rabbitmq \ 
    --hostname=rabbit  \
    --name=rabbit  \
    -p 5672:5672 -p 8080:15672 \
    -e RABBITMQ_PASS=admin   \
    -e RABBITMQ_USE_LONGNAME=true \ 
    -e HOSTNAME=rabbit.bunny.hop \ 
    -e RABBITMQ_PASS=admin 
    -e CLUSTERED=0 rbrooker/rabbitmq:2
```

Usage with a Cluster 
---------------------
see install.sh in the github repo
https://github.com/cognition/rbrooker-rabbitmq


Special Situation
------------------
Where rebuilding reusing previously mounted volumes
mostly done for updates, and run time flag changes)
add the flag `` -e REBUILD=1 `` 



Notes 
-----

Currently I am not able to get more than two rabbitmq nodes active in a cluster. 
I am working on this and hopefully be updating soon. 

Maintained by  
-------------

Ramon Brooker <rbrooker@aetherealmind.com>




