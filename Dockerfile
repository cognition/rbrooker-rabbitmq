FROM rbrooker/rabbitmq
MAINTAINER Ramon Brooker <rbrooker@aetherealmind.com>

ENV DEBIAN_FRONTEND noninteractive
ADD src/ /
RUN  /set-time.sh

ENV NODE_TYPE="disc" MASTER_NAME='nil'

CMD ["/run.sh"]


