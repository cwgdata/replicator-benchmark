# Replicator Benchmark Toolset

Set of tools, ansible scripts, terraform scripts to build a benchmarking evnrionment for Confluent Replicator including 2 clusters that you can configure the location on.

Current Limitation is that it is setup for non SSL configurations.

## Prereqs

1) Python
2) jq (brew install jq)
3) yq (pip install yq)
4) Ansible (brew install ansible)
5) Terraform (brew install terraform)

## Steps

### Setup

1) `git clone https://github.com/cwgdata/replicator-benchmark`
2) `cd cluster1/terraform`
3) `terraform init`
4) copy your aws pem file to current directory
5) Edit terraform.tfvars to your liking
6) `terraform apply`
7) `terraform output -json | ./create_ansible_inventory.py -p > hosts.yml`
8) `terraform output -json | ./register_host_keys.py`
9) `cp hosts.yml ../ansible`
10) `cd ../ansible`
11) `ansible-playbook -i hosts.yml all.yml`
12) `cd ../../cluster2/terraform`
13) repeat steps 3-11

### Test Config

1) `cd ../../scripts`
2) `export KAFKA_HOME=<PATH TO YOUR CONFLUENT DOWNLOAD>`
3) `./create_topics.sh <topic_prefix> <topic start #> <topic end #> <Number of Partitions> <Replication Factor>`




