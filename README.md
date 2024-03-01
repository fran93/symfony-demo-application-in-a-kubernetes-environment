# Setup environment
* Install docker > https://docs.docker.com/engine/install/
* Install minikube > https://minikube.sigs.k8s.io/docs/start/
* minikube start --driver=docker
* minikube addons enable registry
* minikube docker-env # follow the instructions to point your shell to minikube's docker-daemon otherwise the push won't work
* docker build --tag localhost:5000/symfony-demo .
* docker push localhost:5000/symfony-demo
* kubectl apply -f pods
* kubectl apply -f nodes
* minikube tunnel 

# Check demo
* https://localhost/

# Monitoring
* minikube addons enable metrics-server
* minikube dashboard

# Execute migration
* The following command is useful to check the tables before initiating the migration. 
  * kubectl exec database-pod -- psql -d demo_database -U postgres -c "SELECT * FROM pg_catalog.pg_tables WHERE schemaname='public'"
* kubectl apply -f pods_migration # This command set the flag migration to ON which trigger some changes in the entrypoint.
* A new table symfony_demo_employee should appear.

# Things to improve.
* Remove secrets from manifest. (they should be stored in a secret manager and injected when necessary)
* Database should use volumes to store the data.
* Use a non-root user in the Dockerfile for security reasons.
* Healthcheck doesn't complain if the website isn't available. For example if the database is down.

# Issues found.
* Alpine linux: Got some libraries issues creating the symphony demo project.
* php bin/console doctrine:migrations:diff --no-interaction (wasn't generating SQL)
