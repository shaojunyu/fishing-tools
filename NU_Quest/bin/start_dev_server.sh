#!/bin/bash

# check hostname, only  allow quser32
# if [ "$(hostname)" != "quser32" ]; then
#     echo "This script must be run on quser32"
#     exit 1
# fi

module load singularity

# check if the container (quest_dev) is already running
# singularity instance list "quest_dev"
if singularity instance list "quest_dev" | grep -q "quest_dev"; then
    echo "Container quest_dev is already running"
    exit 1
fi


singularity instance start \
    --bind ~/fishing-tools/NU_Quest/etc/ssh/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key \
    --bind ~/fishing-tools/NU_Quest/etc/ssh/ssh_host_rsa_key.pub:/etc/ssh/ssh_host_rsa_key.pub \
    --bind /projects,/hpc,/scratch \
    --hostname dev-server-$(hostname) ~/fishing-tools/NU_Quest/quest_dev_debian.sif quest_dev
