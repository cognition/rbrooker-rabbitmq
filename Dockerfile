FROM ubuntu
MAINTAINER Ramon Brooker <rbrooker@aetherealmind.com>

ENV DEBIAN_FRONTEND noninteractive
# for setting
LABEL rabbit_version.major="3.6" \
      rabbit_version.minor="3.6.2-1" 
ARG ERLANG_COOKIE
ENV ERLANG_COOKIE=${ERLANG_COOKIE:-BAI0VA7ROHXEOQUASH6AIRAGHE9NOH0EOQUAECIE}

ENV R_VERISON_MINOR=3.6.2-1 

# to allow updates to be installed
RUN echo exit 101 > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

# Pull in all Nessary Files
ADD rabbitmq-release-signing-key.asc /
ADD testca /
ADD server /
ADD initial_setup.sh /initial_setup.sh
ADD set-time.sh  /set-time.sh
ADD run.sh /run.sh



# Install RabbitMQ and Updates
RUN cat rabbitmq-release-signing-key.asc | apt-key add - ; \
    echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list; \
    apt-get update ; \
    apt-get -y upgrade ; \
    apt-get install -y rabbitmq-server=$R_VERISON_MINOR ; \
# clean extra-files 
    apt-get autoremove -y ; \
    apt-get clean && rm -rf /var/lib/apt/lists/*  ;

RUN echo $ERLANG_COOKIE > /var/lib/rabbitmq/.erlang.cookie; \
    chmod 400 /var/lib/rabbitmq/.erlang.cookie ;   \
    chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/ 

RUN  /set-time.sh;  /initial_setup.sh


VOLUME ["/var/lib/rabbitmq","/etc/rabbitmq","/var/log/rabbitmq","/certs"]

EXPOSE 5672 15672 44001 

CMD ["/run.sh"]


