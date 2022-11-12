- Build Singularity image
```bash
sudo singularity build RStudio_RSPH.sif RStudio_RSPH.def
# sign the image
singularity sign RStudio_RSPH.sif
# push the image to the library
singularity push RStudio_RSPH.sif library:shaojun/r/rstudio:rsp
```


- Run R
```bash
# sudo singularity build R.sif R.def
singularity run --app R R.sif
```


- Run Rstudio Server
```bash
mkdir -p RStudio_tmp/var/lib
mkdir -p RStudio_tmp/var/run

singularity run \
    --bind RStudio_tmp/var/lib:/var/lib/rstudio-server \
    --bind RStudio_tmp/var/run/:/var/run/rstudio-server \
    --bind RStudio_tmp/:/tmp \
    --bind /usr/bin/R \
    RStudio.sif \
    --www-port 8888 --auth-none=1 \
    --server-user $(whoami)
```