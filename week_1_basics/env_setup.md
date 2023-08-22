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
    ```bash
    ssh-keygen -t rsa -C dtlam2601 -b 2048
    ```
  * GCP > Metadata > Add ssh-key

* Creating a virtual machine on GCP: https://console.cloud.google.com/compute/instances?project=dtc-de-396509
  1. Compute Engine > VM instances > Enable
  2. Create with config:
    * Name: de-zoomcamp
    * Region and Zone: europe-east1 and europe-east1-b
    * Boot-disk:
      * Type: Ubuntu
      * Image: Ubuntu 20.04 LTS
      * Balanced disk
      * Size: 30GB

  * Connecting to the VM with SSH
    ```bash
    # ssh ~/.ssh/ssh_filename username_gen_ssh_key@external_ip_vm
    ssh ~/.ssh/id_rsa dtlam2601@34.22.154.55
    ```
    * View manage: htop

* Installing Anaconda
  ```bash
  wget https://repo.anaconda.com/archive/Anaconda3-2023.07-2-Linux-x86_64.sh
  ```
* Installing Docker

* Creating SSH config file
  ```
  Host de-zoomcamp
    HostName 34.79.122.36
    User dtlam2601
    IdentityFile C:/Users/DTLam2601/.ssh/id_rsa
  ```
