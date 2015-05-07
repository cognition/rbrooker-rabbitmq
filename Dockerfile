FROM ubuntu:trusty
MAINTAINER Ramon Brooker <rbrooker@aetherealmind.com>

ENV DEBIAN_FRONTEND noninteractive
# for setting
ENV R_VERSION_MAJOR=3.2
ENV R_VERISON_MINOR=3.2.4-1





# Install RabbitMQ
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F7B8CEA6056E8E56 && \
echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list 
RUN apt-get update &&  apt-get install -y rabbitmq-server=$R_VERISON_MINOR  pwgen 
RUN rabbitmq-plugins enable rabbitmq_management
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


RUN echo "ERLANGCOOKIE0000rbrooker" > /var/lib/rabbitmq/.erlang.cookie
RUN chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie

RUN rabbitmq-server start &
# ensure they are enabled
RUN rabbitmq-plugins list


# Add scripts
ADD run.sh /run.sh
ADD set_rabbitmq_password.sh /set_rabbitmq_password.sh 
RUN chmod 755 ./*.sh


VOLUME ["/var/lib/rabbitmq","/etc/rabbitmq","/var/log/rabbitmq"]

EXPOSE 5672 15672 4369 25672 
CMD ["/run.sh"]
