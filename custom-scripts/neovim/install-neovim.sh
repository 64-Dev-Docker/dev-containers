#! /bin/bash
# Syntax: ./install-neovim.sh [username]

USERNAME=${1:-"automatic"}

# If in automatic mode, determine if a user already exists, if not use vscode
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in ${POSSIBLE_USERS[@]}; do
        if id -u ${CURRENT_USER} >/dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=vscode
    fi
elif [ "${USERNAME}" = "none" ]; then
    USERNAME=root
    USER_UID=0
    USER_GID=0
fi

# ** Shell customization section **
if [ "${USERNAME}" = "root" ]; then
    USER_RC_PATH="/root"
else
    USER_RC_PATH="/home/${USERNAME}"
fi

# install pre-reqs
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y install \
    ninja-build \
    gettext \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    cmake \
    g++ \
    pkg-config \
    unzip

# install neovim
cd /tmp/library-scripts/
git clone https://github.com/neovim/neovim.git

cd ./neovim
make CMAKE_BUILD_TYPE=Release
make install
cd ..

# install dein - neovim package manager
mkdir -p ${USER_RC_PATH}/.cache/dein
chown -R ${USERNAME} ${USER_RC_PATH}/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh

# For example, we just use `~/.cache/dein` as installation directory
sh ./installer.sh ${USER_RC_PATH}/.cache/dein
# copy the vim configuration
mkdir -p ${USER_RC_PATH}/.config/nvim
cp ./init.vim ${USER_RC_PATH}/.config/nvim/

chown -R ${USERNAME}:${USERNAME} ${USER_RC_PATH}/
