## Environment setup

### For the course you'll need:
* Python 3 (e.g. installed with Anaconda)
* Google Cloud SDK
* Docker with docker-compose
* Terraform


### Setting up the environment on cloud VM
* Generating SSH keys
* Creating a virtual machine on GCP
* Connecting to the VM with SSH
* Installing Anaconda
* Installing Docker
* Creating SSH config file
* Accessing the remote machine with VS Code and SSH remote
* Installing docker-compose
* Installing pgcli
* Port-forwarding with VS code: connecting to pgAdmin and Jupyter from the local computer
* Installing Terraform
* Using sftp for putting the credentials to the remote machine
* Shutting down and removing the instance


### Steps
#### Introduction
* Project on GCP
  https://console.cloud.google.com/home/dashboard?project=dtc-de-396509
* Generating SSH keys:
  * https://cloud.google.com/compute/docs/connect/create-ssh-keys
  * GCP > Metadata > Add ssh-key
* Creating a virtual machine on GCP: https://console.cloud.google.com/compute/instances?project=dtc-de-396509
  * Compute Engine > VM instances > Enable
  * Create with config:
    * Name: de-zoomcamp
    * Boot-disk:
      * Type: Ubuntu
      * Image: Ubuntu 20.04 LTS
      * Balanced disk
      * Size: 30GB
  
  
