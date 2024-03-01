# Setup environment
* Install docker > https://docs.docker.com/engine/install/
* Install minikube > https://minikube.sigs.k8s.io/docs/start/
* minikube start --driver=docker
* minikube addons enable registry
* minikube docker-env (follow the instructions to point your shell to minikube's docker-daemon)
* docker build --tag localhost:5000/symfony-demo .
* docker push localhost:5000/symfony-demo
* kubectl apply -f pods
* kubectl apply -f nodes
* minikube tunnel
* https://localhost/


# Monitoring
* minikube addons enable metrics-server
* minikube dashboard


# Things to improve.
* Use alpine linux. (got some libraries issues) 
* Remove secrets from manifest. (they should be stored in a secret manager and injected when necessary)
* Database should use volumes to store the data.
