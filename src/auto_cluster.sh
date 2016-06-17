#!/bin/bash
# 

    OIFS="$IFS"
    IFS=','
    read -a NODES <<< "${CLUSTER_NODE_NAMES}"
    IFS="$OIFS"
    i=0
    disc='nil'
    ram='nil'
    for node in "${NODES[@]}"
      do
        if [ $(($i % 2)) -eq 0 ]; then
          if [ $disc = 'nil' ]; then 
            disc=$node 
          else
            disc="$disc,$node"
        fi
       else
          if [ $ram = 'nil' ]; then
            ram=$node
          else
            ram="$ram,$node"
          fi
        fi
        ((++i))
      done
cluster_nodes="{cluster_node, {[$disc], disc},{[$ram],ram}},"

echo $cluster_nodes
sed -e "s/%%SUB_CLUSTER_NODE_DETAILS_HERE/${cluster_nodes}/" /rabbitmq.config.0 > /etc/rabbitmq/rabbitmq.config

exit $?
