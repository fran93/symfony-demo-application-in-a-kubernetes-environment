# Setup environment
* Install docker > https://docs.docker.com/engine/install/
* Install minikube > https://minikube.sigs.k8s.io/docs/start/
* minikube start --driver=docker
* minikube addons enable registry
* Follow the instructions to point your shell to minikube's docker-daemon otherwise the push won't work
  * minikube docker-env
* The following command creates a docker image based on Frankenphp (recommended by symfony), and install the demo app using composer
  * docker build --tag localhost:5000/symfony-demo .
* docker push localhost:5000/symfony-demo
* The following manifest files create a database pod and a replica set of 2 pods of our Dockerfile.
  * kubectl apply -f pods
* The following manifest files expose the database internally, and our demo app externally.
  * kubectl apply -f nodes
* minikube tunnel 

# Check demo
* https://localhost/

# Monitoring
* minikube dashboard
* Useful command to check the work balance and if the scaling strategy is working.
  * kubectl get hpa

# Execute migration
* The following command is useful to check the tables before initiating the migration and once is completed.
  * kubectl exec database-pod -- psql -d demo_database -U postgres -c "SELECT * FROM pg_catalog.pg_tables WHERE schemaname='public'"
* The following command set the flag migration to ON which trigger some changes in the entrypoint and initiates a RollingUpdate deploy. 
2 pods combined with a RollingUpdate strategy should prevent downtimes during the deployment of the migration.
  * kubectl apply -f pods_migration
* A new table symfony_demo_employee should appear.

# Execute scaling strategy
* The following command allows kubernetes to know the percentage of CPU used by our pods.
  * minikube addons enable metrics-server
* The following manifest file creates a horizontal scale strategy based on CPU.
  * kubectl apply -f autoscaler
* The following command should execute a siege docker, that's going to create thousands of GET petitions, to force the app to scale.
  * kubectl apply -f jobs

# Scaling strategy explained
* I decided to use a Horizontal Pod Autoscaler for the replica set of the demo app for the following reasons:
  * The database load isn't affected, reading operations are very cheap. (At least for the demo app and Siege).
  * The most CPU intensive part of our app is the Php server. The more request you get the more CPU it requires.
  * 1 single request isn't heavy enough to justify a Vertical Scaling.
  * The requests can be distributed between different pods to share the workload.

# Things that could be improved for security or performance reasons.
* Remove secrets from manifest. (They should be stored in a secret manager and injected when necessary)
* Database should use volumes to store the data. (I think is out of scope of this demo)
* Use a non-root user in the Dockerfile with only the required permissions.
* Healthcheck doesn't complain if the website isn't available. For example if the database is down.
* Creating the symfony project in local once, and then copy only the necessary files, should be more optimal. 
But for the demo is cleaner to do it inside the docker.

# Issues found.
* Alpine linux: Got some libraries issues creating the symphony demo project (sass).
* php bin/console doctrine:migrations:diff (wasn't generating SQL)
