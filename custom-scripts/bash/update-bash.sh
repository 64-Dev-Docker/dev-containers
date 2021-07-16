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

# we want the 'powerline' theme
sed -i 's/OSH_THEME=.*/OSH_THEME="powerline"/g' ${USER_RC_PATH}/.bashrc

# we want VI on the shell cli
echo '# setting VI mode on the terminal 2021-01-30::wjs' >>${USER_RC_PATH}/.bashrc
echo 'set -o vi' >>${USER_RC_PATH}/.bashrc

# set the s/mime git commit signing
# echo 'export GPPG_TTY=$(tty)'>>${USER_RC_PATH}/.zshrc

# we want git to use vi
# git config --global core.editor "vi"
