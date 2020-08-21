#!/bin/sh
#Voting app in docker swarm.
#Current structure is: Network for frontend and network for backend.
#The current swarm is working with 4 nodes, 1 leader, 1 manager and 2 workers but you can set it up in any way you want
#Frontend and backend creation.
docker network create -d overlay backend
docker network create -d overlay frontend

docker service create --name vote -p 80:80 --network frontend --replicas 2 bretfisher/examplevotingapp_vote

docker service create --name redis --network frontend --replicas 1 redis:3.2

docker service create --name worker --network frontend --network backend --replicas 1 bretfisher/examplevotingapp_worker:java

docker service create --name db --network backend --replicas 1 -e POSTGRES_HOST_AUTH_METHOD=trust --mount type=volume,source=db-data,target=/var/lib/postgresql/data postgres:9.4

docker service create --name result -p 5001:80 --network backend --replicas 1 bretfisher/examplevotingapp_result
