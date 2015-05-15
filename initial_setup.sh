#!/bin/bash

if [ -f /.setup_done ]; then
	echo "RabbitMQ password already set!"
	exit 0
fi

PASS=${RABBITMQ_PASS:-$(pwgen -s 12 1)}
USER=${RABBITMQ_USER:-"admin"}
_word=$( [ ${RABBITMQ_PASS} ] && echo "preset" || echo "random" )
echo "=> Securing RabbitMQ with a ${_word} password"
cat > /etc/rabbitmq/rabbitmq.config <<EOF
[{rabbit, [{default_user, <<"$USER">>},{default_pass, <<"$PASS">>},{tcp_listeners, [{"0.0.0.0", 5672}]},{vm_memory_high_watermark,0.5 },{vm_memory_high_watermark_paging_ratio,0.6 }, {disk_free_limit,500000000}]}].
EOF

echo "=> Done!"
touch /.setup_done

