RabbitMQ
=====================

I created this project because the other RabbitMQ Docker containers (at the time I started this) didn't have any fine grained control or the ability to add plugins, and adjust the configuration away from default. 

I have populated the variables with defaults values, some I left alone, whereas on others I have altered based on bias, and due to figuring out in my own experimentation, and reading several blogs/articles etc. on the subject. 

Please see the wiki for details and sample installations 


### RabbitMQ v 3.6.3-1 
* [RabbitMQ Project](http://www.rabbitmq.com/download.html)
* [Erlang Solutions](https://www.erlang-solutions.com/resources/download.html)

Optional
* SSL
* Shovel
* Federation


### Basic Usage
-----
```
docker run -d -it \
    --hostname=bunny.hop  \
    --name=rabbit  \
    -p 5672:5672 -p 15672:15672 -p 5671:5671 \ 
    -e SSL="false" \
    rbrooker/rabbitmq:latest

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
   --volumes-from cert-container:ro \
   --hostname=bunny.hop  \
   --name=rabbit  \
   -p 5672:5672 -p 15672:15672 -p 5671:5671 \ 
   -e SSL="true"\
  rbrooker/rabbitmq:latest
```
###  
See the [Wiki](https://github.com/cognition/rbrooker-rabbitmq/wiki) for more advanced details. 


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

pull the docker-compose.yml file, and run:  
```docker-compose up ```

See the [Wiki Clustering](https://github.com/cognition/rbrooker-rabbitmq/wiki/Clustering) 



Common Gatachas
---------------

``` SSL=0 ``` should be ```SSL="false" ```
``` SSL=1 ``` should be ```SSL="true" ```

Cert directory structure:     
/server/cacert.pem     
/server/cert.pem    
/server/key.pem   



Maintained by  
-------------

Ramon Brooker <rbrooker@aetherealmind.com>


[![GetBadges Game](https://cognition-rbrooker-rabbitmq.getbadges.io/shield/company/cognition-rbrooker-rabbitmq/user/5992)](https://cognition-rbrooker-rabbitmq.getbadges.io/?ref=shield-player)


 
