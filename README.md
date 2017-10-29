## Purpose
The purpose of this project is to provide some kind of a framework for testing docker clusters.
For now only the Docker Swarm and Kubernetes are considered.

## Prerequisites
- Terraform 0.9
- AWS account
- MongoDB with remote access (could be created for free e.g. in [mLab](https://mlab.com/))

## Warning
You can be charged for the used resources on AWS.

## Architecture
Terraform creates all the infrastucture in AWS.

### Test components
- Cluster - Docker Swarm or Kubernetes with no public access
- Bastion server - A server in the cluster subnet with public ip and ssh access
- Supervisor - runs on bastion server, schedules and finishes the tests
- Local agent - runs on cluster node, gathers the results and uploads them to MongoDB

## Tests
### Cluster size
Each step is performed with 3 manager nodes

Steps:
- 3 worker nodes
- 5 worker nodes
- 10 worker nodes
- 20 worker nodes

### Starting containers
Steps:
- 10 containers per worker node
- 25 containers per worker node
- 50 containers per worker node
- 100 containers per worker node
