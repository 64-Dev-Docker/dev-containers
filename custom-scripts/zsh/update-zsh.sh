#! /bin/bash
# Syntax: ./github-ssh.sh [username]

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

# ensure oh-my-zsh is installed
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ZSH_CUSTOM=$USER_RC_PATH/.oh-my-zsh/custom

# we want the 'powerlevel10k' theme
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

cp /tmp/library-scripts/.p10k.zsh $USER_RC_PATH/
cp /tmp/library-scripts/.zshrc $USER_RC_PATH/
# sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ${USER_RC_PATH}/.zshrc
# sed -i 's/#ENABLE_CORRECTION="true"/ENABLE_CORRECTION="true"/g' ${USER_RC_PATH}/.zshrc
# sed -i 's/plugins=\(git\)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ${USER_RC_PATH}/.zshrc


# # we want VI on the shell cli
# echo '# setting VI mode on the terminal 2021-01-30::wjs' >>${USER_RC_PATH}/.zshrc
# echo 'set -o vi' >>${USER_RC_PATH}/.zshrc

# sourced from:
# https://medium.com/@shivam1/make-your-terminal-beautiful-and-fast-with-zsh-shell-and-powerlevel10k-6484461c6efb