docker build -t adhupraba/multi-client:latest -t adhupraba/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t adhupraba/multi-server:latest -t adhupraba/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t adhupraba/multi-worker:latest -t adhupraba/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push adhupraba/multi-client:latest
docker push adhupraba/multi-server:latest
docker push adhupraba/multi-worker:latest

docker push adhupraba/multi-client:$SHA
docker push adhupraba/multi-server:$SHA
docker push adhupraba/multi-worker:$SHA

# apply the kubernetes config files with use of kubectl from gcloud in travis.yml
kubectl apply -f k8s/
# client=, server=, worker= -> these are the container names which were given in their deployments file respectiely
kubectl set image deployments/client-deployment client=adhupraba/multi-client:$SHA
kubectl set image deployments/server-deployment server=adhupraba/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=adhupraba/multi-worker:$SHA