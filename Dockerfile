FROM rbrooker/rabbitmq
MAINTAINER Ramon Brooker <rbrooker@aetherealmind.com>

ENV DEBIAN_FRONTEND noninteractive
ADD src/ /
RUN  /set-time.sh


VOLUME ["/etc/rabbitmq","/var/log/rabbitmq","/server","/var/lib/rabbitmq","/logs","/custom_config"]

EXPOSE 5671 5672 15672 44001-44010

CMD ["/run.sh"]


