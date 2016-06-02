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
RUN echo exit 1 > /usr/sbin/policy-rc.d; 
RUN chmod +x /usr/sbin/policy-rc.d

# Install Updates, and other needed prgms
RUN apt-get update ; apt-get -y install logrotate wget apt-utils; apt-get -y upgrade


# Install RabbitMQ
#RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb; 
#RUN dpkg -i erlang-solutions_1.0_all.deb
RUN wget -O-  https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add -
RUN wget -O-  https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add - 
RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list
RUN echo 'deb https://packages.erlang-solutions.com/ubuntu xenial contrib' tee /etc/apt/sources.list.d/erlang.list
RUN apt-get update; apt-get install -y rabbitmq-server=$R_VERISON_MINOR 

# clean extra-files 
RUN  apt-get autoremove -y ; apt-get clean && rm -rf /var/lib/apt/lists/*


RUN echo $ERLANG_COOKIE > /var/lib/rabbitmq/.erlang.cookie;
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie 
RUN chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/ 



ADD testca/ /testca
ADD server/ /server
ADD initial_setup.sh /initial_setup.sh
ADD set-time.sh  /set-time.sh
ADD run.sh /run.sh

RUN  /set-time.sh


VOLUME ["/etc/rabbitmq","/var/log/rabbitmq","/server"]

EXPOSE 5672 15672 44001 5671

CMD ["/run.sh"]

