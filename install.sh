#!/bin/sh

n=6;
driver="virtualbox";

echo "Check if docker-machine is installed";

for ((i=1; i<=$n; i++)); do
	echo "Creating node $i";
	docker-machine create --driver $driver node-$i --swarm --swarm-master --swarm-discovery=token://$token;
	docker-machine create --driver $driver node-$i --swarm --swarm-addr=tcp://$ip:2375 --swarm-discovery=token://$token;
done

$SHELL