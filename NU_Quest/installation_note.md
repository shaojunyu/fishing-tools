## install git
```bash

```

## install zsh
```bash
cd /home/bme4234/fishing-tools/NU_Quest/tools
# same version as on the dev container
export ZSH_VERSION=5.5.1
wget https://master.dl.sourceforge.net/project/zsh/zsh/${ZSH_VERSION}/zsh-${ZSH_VERSION}.tar.gz
tar -xvf zsh-${ZSH_VERSION}.tar.gz
cd zsh-${ZSH_VERSION}
./configure --prefix=/home/bme4234/.local
make -j 10
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