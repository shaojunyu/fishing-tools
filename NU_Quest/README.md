## Setup the dev environment on Northwestern Quest HPC

### Notes
- Jun 2024  
The NU Quest HPC uses Red Hat Enterprise Linux Server 7.9 (Maipo) (Kernel: Linux 3.10.0-1160.95.1.el7.x86_64), whose kernel is too old to run VSCode server. Therefore, we need to use the container to run the dev environment and dev container is based on Rocky Linux 9.3.

## Generate SSH keys for the container
```bash
mkdir -p etc/ssh
cd etc/ssh
ssh-keygen -t rsa -f ssh_host_rsa_key -N '' -b 4096
```

## build the singularity container
```bash
module load singularity

# build the container
singularity build quest_dev.sif dev_container.def

# run the container
# stop the container first
singularity instance list
singularity instance stop quest_dev

singularity instance start \
    # --bind etc/ssh/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key \
    # --bind etc/ssh/ssh_host_rsa_key.pub:/etc/ssh/ssh_host_rsa_key.pub \
    quest_dev.sif quest_dev

singularity instance start quest_dev.sif quest_dev
# remove record from .ssh/known_hosts [127.0.0.1]:14145
ssh-keygen -R '[127.0.0.1]:14145'

# kill all node processes
pkill -u $USER node
```