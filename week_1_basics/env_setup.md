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
    * Region and Zone: europe-west1 and europe-west1-b
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

* Installing Anaconda in VM
  ```bash
  wget https://repo.anaconda.com/archive/Anaconda3-2023.07-2-Linux-x86_64.sh

  # run this command to install anaconda
  bash Anaconda3-2023.07-2-Linux-x86_64.sh
  # this as anaconda installed
  less .bashrc
  source .bashrc
  # show prefix (base)
  ```
  
  
* Installing Docker
  ```bash
  # apt-get and apt are the same thing
  sudo apt-get update
  sudo apt-get install docker.io
  ```
  * Establish run docker without sudo at: https://github.com/sindresorhus/guides/blob/main/docker-without-sudo.md
    ```bash
    # 1. Add the docker group if it doesn't already exist
    sudo groupadd docker
    
    # 2. Add the connected user $USER to the docker group
    # Optionally change the username to match your preferred user.
    sudo gpasswd -a $USER docker

    3. # IMPORTANT: Log out and log back in so that your group membership is re-evaluated.
    ```

* Creating SSH config file
  ```
  ## config file create in ~/.ssh/config
  Host de-zoomcamp
    HostName 34.79.122.36
    User dtlam2601
    IdentityFile C:/Users/DTLam/.ssh/id_rsa
  ```
  ```bash
  # this connect to VM
  cd
  ssh de-zoomcamp
  ```

* Accessing the remote machine with VS Code and SSH remote
  * Usage file: ~/.ssh/config
  * VS Code: install an extension "Remote SSH" by Microsoft
  * How to connect: Ctrl + Shift + P > Remote SSH: Connect to host.. > de-zoomcamp > Choose platform.

* Installing docker-compose
  ```bash
  mkdir bin
  cd bin
  wget https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-linux-x86_64 -O docker-compose
  ls
  # docker-compose is a file (white text), it is a executable file (green text), but system doesn't know this.
  # to let our system know, run this command, change mode plus x 
  chmod +x docker-compose
  ```
  ```bash
  # open to export path for ${HOME}/bin
  nano .bashrc
  
  # add this line to the end of the file
  export PATH="${HOME}/bin:${PATH}"
  # then Ctrl + o to save, press Enter to Confirm, Ctrl + x to Exit

  # logout and login, or refresh the change
  source .bashrc

  # run docker-compose
  cd ./data-engineering-zoomcamp/week_1_basics_n_setup/2_docker_sql
  # -d for run in detached mode
  docker-compose up -d
  ```
  
* Installing pgcli
  ```bash
  pip install pgcli
  # or
  conda install -c conda-forge pgcli
  pip install -U mycli
  ```

* Port-forwarding with VS code: connecting to pgAdmin and Jupyter from the local computer
  * Remote-SSH with VS code
  * Ports > Add Port: 5432 (Postgres), 8080 (pgAdmin), 8888 (jupyter notebook upload-data)

* Installing Terraform
  ```bash
  cd
  cd bin
  wget https://releases.hashicorp.com/terraform/1.5.5/terraform_1.5.5_linux_amd64.zip
  unzip terraform_1.5.5_linux_amd64.zip
  ```
* Using sftp (Google credentials) for putting the credentials to the remote machine
  * sftp: Secure File Transfer Protocol
  ```bash
  # cd to path contains files need to transfer
  # then sftp to connect to machine, de-zoomcamp is a host
  sftp de-zoomcamp
  # cd to path need transfer file to.
  # then put file_name
  put file_name
  ```
  * config gcloud (VM instance)
    ```bash
    # Export environment
    set GOOGLE_APPLICATION_CREDENTIALS=C:\Users\DTLam\.gc\dtc-de-396509.json
    # Activated service account credentials for "VM instance" to Service account GCP ([dtc-de-user@dtc-de-396509.iam.gserviceaccount.com])
    # then you can interactive with terraform
    gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
    ```

  * Run Terraform commands
    ```bash
    terraform init
    terraform plan
    terraform apply
    terraform destroy
    ```
* Shutting down and removing the instance
