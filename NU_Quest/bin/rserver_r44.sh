#!/bin/bash
#SBATCH --job-name=rstudio_server   # Job name
#SBATCH --partition=genomics
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=128G
#SBATCH --account=b1042
#SBATCH --time=48:00:00

echo "Starting RStudio Server on $(hostname) at $(date)"
time1=$(date +%Y%m%d%H%M%S)
module load singularity
time2=$(date +%Y%m%d%H%M%S)
echo "Time to load singularity: $((time2-time1)) seconds"
cd ~

# clean up the previous sessions data if any
rm -rf .local/share/rstudio/sessions/*

# stop rserver and rsession if they are running
# check if rsession with current user is running
rsession_pid=$(pgrep -u $(whoami) -x rsession) || true
rserver_pid=$(pgrep -u $(whoami) -x rserver) || true
# echo "rsession_pid: $rsession_pid"
# echo "rserver_pid: $rserver_pid"
if [ -n "$rsession_pid" ]; then
    echo "Killing previous rsession with pid: $rsession_pid"
    pkill -9 -x rsession
fi
if [ -n "$rserver_pid" ]; then
    echo "Killing rserver with pid: $rserver_pid"
    # kill -9 $rserver_pid
    pkill -9 -x rserver
fi

# --bind /usr/share/fonts/:/usr/share/fonts/ \
# --bind /usr/share/X11/fonts:/usr/share/X11/fonts \
# --bind RStudio_tmp/var/lib:/var/lib/rstudio-server \
# --bind RStudio_tmp/var/run/:/var/run/rstudio-server \

mkdir -p /tmp/RStudio_syu_tmp/var/lib
mkdir -p /tmp/RStudio_syu_tmp/var/run
mkdir -p /tmp/RStudio_syu_tmp/local

# clean up the previous sessions data if any
rm -rf /tmp/RStudio_syu_tmp/var/lib/*
rm -rf /tmp/RStudio_syu_tmp/var/run/*
rm -rf /tmp/RStudio_syu_tmp/local/rstudio/sessions/*

# export XDG_DATA_HOME=/tmp/RStudio_syu_tmp/local

singularity exec \
    --bind /tmp:/tmp \
    --bind /tmp/RStudio_syu_tmp/var/lib:/var/lib/rstudio-server \
    --bind /tmp/RStudio_syu_tmp/var/run/:/var/run/rstudio-server \
    --bind /tmp/RStudio_syu_tmp/local:/tmp/RStudio_syu_tmp/local \
    --bind /projects \
    --bind fishing-tools/NU_Quest/etc/rstudio/rsession.conf:/etc/rstudio/rsession_overrides.conf \
    --bind fishing-tools/NU_Quest/etc/rstudio/logging.conf:/etc/rstudio/logging.conf \
    --bind fishing-tools/NU_Quest/etc/rstudio/fonts/MesloLGS_NF_Regular.ttf:/etc/rstudio/fonts/MesloLGS_NF_Regular.ttf \
    fishing-tools/NU_Quest/quest_dev_debian.sif \
    rserver \
    --www-port 8801 \
    --auth-none 1 \
    --server-user $(whoami) \
    --rsession-config-file /etc/rstudio/rsession_overrides.conf
    # --rsession-which-r /opt/R/4.4.1/bin/R \
    