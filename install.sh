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
	printf "\n********** Creating node $i\n\n";
	docker-machine create --driver $CLUSTER_DRIVER node-$i
	#docker-machine create --driver $CLUSTER_DRIVER node-$i --swarm --swarm-master --swarm-discovery=token://$token;
	#docker-machine create --driver $CLUSTER_DRIVER node-$i --swarm --swarm-addr=tcp://$ip:2375 --swarm-discovery=token://$token;
done

# List created nodes and their IP address
printf "\n********** List of nodes:\n\n";
printf "%10s %20s\n"  "Machine" "IP";
for ((i=1; i<=$CLUSTER_NODES; i++)); do
	url=$(docker-machine url node-$i);
	printf "%10s %30s\n"  "node-"$i $url;
done

$SHELL