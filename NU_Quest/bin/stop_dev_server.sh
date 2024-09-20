#!/bin/bash
# check hostname, only  allow quser32
# if [ "$(hostname)" != "quser32" ]; then
#     echo "This script must be run on quser32"
#     exit 1
# fi

module load singularity
singularity instance stop quest_dev