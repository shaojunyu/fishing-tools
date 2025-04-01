## install some tools

## install git
```bash
cd /home/bme4234/fishing-tools/NU_Quest/tools
export GIT_VERSION=2.43.5
# https://www.kernel.org/pub/software/scm/git/git-2.39.2.tar.gz
wget https://www.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.gz
tar -xvf git-${GIT_VERSION}.tar.gz
cd git-${GIT_VERSION}
./configure --prefix=/home/bme4234/.local
make -j 4
make install
```

## install zsh
```bash
cd /home/bme4234/fishing-tools/NU_Quest/tools
# same version as on the dev container
export ZSH_VERSION=5.9
# https://sourceforge.net/projects/zsh/files/zsh
wget https://sourceforge.net/projects/zsh/files/zsh/${ZSH_VERSION}/zsh-${ZSH_VERSION}.tar.xz

tar -xvf zsh-${ZSH_VERSION}.tar.xz
cd zsh-${ZSH_VERSION}
./configure --prefix=/home/bme4234/.local
make -j 4
make install
```
### zsh plugins
- powerlevel10k
- zsh-autosuggestions
- zsh-syntax-highlighting


## install fish
```bash
cd /home/bme4234/fishing-tools/NU_Quest/tools
export FISH_VERSION=3.7.1
wget https://github.com/fish-shell/fish-shell/releases/download/3.7.1/fish-3.7.1.tar.xz
tar -xvf fish-3.7.1.tar.xz
cd fish-3.7.1

module load cmake/3.26.3-gcc-10.4.0
module load gcc/10.4.0-gcc-4.8.5
cmake .
make -j 10

cp fish /home/bme4234/.local/bin/fish
```

## install JAGS
> Install JAGS from R package `infercnv`
- https://github.com/broadinstitute/inferCNV/wiki/Installing-infercnv

```bash
wget "https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/Source/JAGS-4.3.2.tar.gz/download" -O JAGS-4.3.2.tar.gz
tar -xvf JAGS-4.3.2.tar.gz
cd JAGS-4.3.2
./configure --prefix=/home/bme4234/.local
make -j 10
make install
export PKG_CONFIG_PATH=/home/bme4234/.local/lib/pkgconfig:$PKG_CONFIG_PATH
pkg-config --cflags --libs jags

```

## htop
```bash
wget https://github.com/htop-dev/htop/releases/download/3.3.0/htop-3.3.0.tar.xz
tar -xvf htop-3.3.0.tar.xz
cd htop-3.3.0
./configure --prefix=/home/bme4234/.local
make -j 10
make install
```

## btop
```bash
wget wget https://github.com/aristocratos/btop/archive/refs/tags/v1.4.0.tar.gz
tar -xvf v1.4.0.tar.gz
cd btop-1.4.0
module load gcc/12.3.0-gcc
make GPU_SUPPORT=false
make install PREFIX=/home/bme4234/.local
```

## nvtop
```bash
export NVTOP_VERSION=3.2.0
wget -O nvtop-${NVTOP_VERSION}.tar.gz https://github.com/Syllo/nvtop/archive/refs/tags/${NVTOP_VERSION}.tar.gz
tar -xvf nvtop-${NVTOP_VERSION}.tar.gz
cd nvtop-${NVTOP_VERSION}
mkdir build
cd build
cmake .. -DAMDGPU_SUPPORT=OFF -DINTEL_SUPPORT=OFF -DV3D_SUPPORT=OFF -DMSM_SUPPORT=OFF -DPANFROST_SUPPORT=OFF -DPANTHOR_SUPPORT=OFF
make -j 4
cp src/nvtop ~/.local/bin
```