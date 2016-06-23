#!/bin/bash -x 
# 
echo "autocluster"
echo $CLUSTER_NODE_NAMES


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
if [ $ram = 'nil' ]; then
      cluster_nodes="{cluster_node, {[$disc], disc}},"
elif [ $disc = 'nil' ] && ! [ $ram = 'nil'] 
then
      cluster_nodes="{cluster_node, {[$ram],ram}},"
else
      cluster_nodes="{cluster_node, {[$disc], disc},{[$ram],ram}},"
fi

echo $cluster_nodes
sed -i -e "s|%%SUB_CLUSTER_NODE_DETAILS_HERE|${cluster_nodes}|g" rabbitmq.config.0


echo "autocluster -- end"


exit $?
