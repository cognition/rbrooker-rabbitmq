FROM ubuntu:vivid
MAINTAINER Ramon Brooker <rbrooker@aetherealmind.com>

ENV DEBIAN_FRONTEND noninteractive
# for setting
ENV R_VERSION_MAJOR=3.5
ENV R_VERISON_MINOR=3.5.2-1

# to allow updates to be installed
RUN echo exit 101 > /usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d


# Install RabbitMQ and Updates
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F7B8CEA6056E8E56 && \
echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list 
RUN apt-get update && apt-get -y upgrade &&  apt-get install -y rabbitmq-server=$R_VERISON_MINOR  pwgen 
RUN rabbitmq-plugins enable rabbitmq_management
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


RUN echo "ILIKETOEATCOOKIESERLANGONESTOOOOOO" > /var/lib/rabbitmq/.erlang.cookie
RUN chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie

RUN rabbitmq-server start &
# ensure they are enabled
RUN rabbitmq-plugins list


# Add scripts
COPY run.sh /run.sh
COPY initial_setup.sh /initial_setup.sh 
RUN chmod 755 ./*.sh

# add a time stamp
COPY set-time.sh /
RUN chmod +x /set-time.sh
RUN /set-time.sh



VOLUME ["/var/lib/rabbitmq","/etc/rabbitmq","/var/log/rabbitmq"]

EXPOSE 5672 15672 4369 25672 
CMD ["/run.sh"]
