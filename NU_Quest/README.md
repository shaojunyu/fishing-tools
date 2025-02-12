## Setup the dev environment on Northwestern Quest HPC

### Notes
- Jun 2024  
The NU Quest HPC uses Red Hat Enterprise Linux Server 7.9 (Maipo) (Kernel: Linux 3.10.0-1160.95.1.el7.x86_64), whose kernel is too old to run VSCode server. Therefore, we need to use the container to run the dev environment and dev container is based on Rocky Linux 8.9.

## Generate SSH keys for the container
```bash
mkdir -p etc/ssh
# cd etc/ssh
ssh-keygen -t rsa -f etc/ssh/ssh_host_rsa_key -N '' -b 4096
```

## build the singularity container
```bash
module load singularity

# build the container
singularity build --remote quest_dev.sif dev_container.def && ssh-keygen -R '[127.0.0.1]:14145'

# run the container
# stop the container first
singularity instance list

singularity instance stop quest_dev

# singularity instance start \
#     --bind etc/ssh/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key \
#     --bind etc/ssh/ssh_host_rsa_key.pub:/etc/ssh/ssh_host_rsa_key.pub \
#     quest_dev.sif quest_dev

singularity run \
    --bind etc/ssh/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key \
    --bind etc/ssh/ssh_host_rsa_key.pub:/etc/ssh/ssh_host_rsa_key.pub \
    quest_dev.sif

singularity instance start \
    --bind /projects,/hpc,/scratch \
    --hostname dev-container quest_dev.sif quest_dev

# remove record from .ssh/known_hosts [127.0.0.1]:14145
ssh-keygen -R '[127.0.0.1]:14145'

# kill all node processes
pkill -u $USER node
```

## Run RStudio Server
```bash

mkdir -p RStudio_tmp/var/lib
mkdir -p RStudio_tmp/var/run

module load singularity
cd ~
singularity run --app rserver \
    --bind RStudio_tmp/var/lib:/var/lib/rstudio-server \
    --bind RStudio_tmp/var/run/:/var/run/rstudio-server \
    # --bind /tmp:/tmp \
    # --bind /usr/share/fonts/:/usr/share/fonts/ \
    # --bind /usr/share/X11/fonts:/usr/share/X11/fonts \
    # --bind /projects, /hpc \
    fishing-tools/NU_Quest/quest_dev.sif \
    --www-port 9901 \
    --auth-none 1 \
    --server-user $(whoami)

singularity run \
    --bind RStudio_tmp/var/lib:/var/lib/rstudio-server \
    --bind RStudio_tmp/var/run/:/var/run/rstudio-server \
    fishing-tools/NU_Quest/quest_dev.sif \
    --www-port 8801 \
    --auth-none 1 \
    --server-user $(whoami) \
    --rsession-which-r /opt/R/4.4.1/bin/R

singularity exec \
    --bind /tmp:/tmp \
    --bind /usr/share/fonts/:/usr/share/fonts/ \
    --bind /usr/share/X11/fonts:/usr/share/X11/fonts \
    --bind RStudio_tmp/var/lib:/var/lib/rstudio-server \
    --bind RStudio_tmp/var/run/:/var/run/rstudio-server \
    --bind /projects \
    fishing-tools/NU_Quest/quest_dev.sif \
    rserver \
    --www-port 8801 \
    --auth-none 1 \
    --server-user $(whoami) \
    --rsession-which-r /opt/R/4.4.1/bin/R

```


## Run RStudio on Lab GPU node
```bash
mkdir -p /tmp/RStudio_syu_tmp/var/lib
mkdir -p /tmp/RStudio_syu_tmp/var/run

singularity exec \
    --bind /tmp:/tmp \
    --bind /tmp/RStudio_syu_tmp/var/lib:/var/lib/rstudio-server \
    --bind /tmp/RStudio_syu_tmp/var/run/:/var/run/rstudio-server \
    --bind /data \
    ~/workspace/fishing-tools/NU_Quest/quest_dev_debian.sif \
    rserver \
    --www-port 8787 \
    --auth-none 1 \
    --server-user $(whoami)
```