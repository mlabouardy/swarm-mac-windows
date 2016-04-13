#!/bin/sh

# Set Cluster nodes number
if [ $?CLUSTER_NODES != 1 ]; then 
    CLUSTER_NODES=6;
fi

# Set docker-machine create driver
if [ $?CLUSTER_DRIVER != 1 ]; then 
    CLUSTER_DRIVER="virtualbox";
fi

# Check if docker-machine is installed
if ! type docker-machine >/dev/null; then
    "Docker-machine is required.  Aborting."
    exit 1;
fi

# Create nodes cluster
for ((i=1; i<=$CLUSTER_NODES; i++)); do
	echo "Creating node $i";
	docker-machine create --driver $CLUSTER_DRIVER node-$i --swarm --swarm-master --swarm-discovery=token://$token;
	docker-machine create --driver $CLUSTER_DRIVER node-$i --swarm --swarm-addr=tcp://$ip:2375 --swarm-discovery=token://$token;
done

$SHELL