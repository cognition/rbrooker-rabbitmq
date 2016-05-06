FROM rbrooker/xenial
MAINTAINER Ramon Brooker <rbrooker@aetherealmind.com>

ENV DEBIAN_FRONTEND noninteractive
# for setting
LABEL rabbit_version.major="3.6" \
      rabbit_version.minor="3.6.1-1" \ 
      build.time="$(date -u +%Y-%m-%d_%Hh%M_UTC)"


ENV R_VERISON_MINOR=3.6.1-1 

# to allow updates to be installed
RUN echo exit 101 > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d


# Install RabbitMQ and Updates
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F7B8CEA6056E8E56 && \
    echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list \
    apt-get update && apt-get -y upgrade ; \
    apt-get install -y rabbitmq-server=$R_VERISON_MINOR  pwgen; \
# clean extra-files 
    apt-get autoremove -y ; \
    apt-get clean && rm -rf /var/lib/apt/lists/*


RUN echo $(pwgen 40 1 | tr [a-z] [A-Z]) > /var/lib/rabbitmq/.erlang.cookie; \
    cat /var/lib/rabbitmq/.erlang.cookie \
    chmod 400 /var/lib/rabbitmq/.erlang.cookie   \
    chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/ 

#RUN rabbitmq-server start &

# ensure they are enabled
RUN rabbitmq-plugins list


# Add scripts
ADD *.sh  /

RUN chmod 755 /*.sh \
    ./set-time.sh \
    ./setup.sh



# add a time stamp
#COPY set-time.sh /
#RUN chmod +x /set-time.sh ; /set-time.sh



VOLUME ["/var/lib/rabbitmq","/etc/rabbitmq","/var/log/rabbitmq"]

EXPOSE 5672 15672 44001 

CMD ["/run.sh"]


