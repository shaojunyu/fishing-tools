#!/bin/bash
#SBATCH --job-name=rstudio_server   # Job name
#SBATCH --partition=genomics
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=128G
#SBATCH --account=b1042
#SBATCH --time=48:00:00

module load singularity
cd ~

# clean up the previous sessions data if any
# rm -rf .local/share/rstudio/sessions/*

    # --bind /usr/share/fonts/:/usr/share/fonts/ \
    # --bind /usr/share/X11/fonts:/usr/share/X11/fonts \
singularity exec \
    --bind /tmp:/tmp \
    --bind RStudio_tmp/var/lib:/var/lib/rstudio-server \
    --bind RStudio_tmp/var/run/:/var/run/rstudio-server \
    --bind /projects \
    fishing-tools/NU_Quest/quest_dev.sif \
    rserver \
    --www-port 8801 \
    --auth-none 1 \
    --server-user $(whoami) \
    --rsession-which-r /opt/R/4.4.1/bin/R
