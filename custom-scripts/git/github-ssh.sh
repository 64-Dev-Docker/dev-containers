# Syntax: ./github-ssh.sh [username]

USERNAME=${1:-"automatic"}

# If in automatic mode, determine if a user already exists, if not use vscode
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in ${POSSIBLE_USERS[@]}; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
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


# My logic
SSH_AGENT="$(cat \
<<EOF

# configuring the ssh-agent to use with github
if [ -z "\$SSH_AUTH_SOCK" ]; then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="\`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'\`"
   if [ "\$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> \$HOME/.ssh/ssh-agent
   fi
   eval \`cat \$HOME/.ssh/ssh-agent\`
fi
EOF
)"

# cp -r /tmp/library-scripts/ssh ${USER_RC_PATH}/.ssh/

eval "$(ssh-agent -s)"
echo "${SSH_AGENT}" >> ${USER_RC_PATH}/.bashrc