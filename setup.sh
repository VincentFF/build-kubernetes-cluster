#!/usr/bin/env bash
cwd=$(dirname $0)
cd $cwd || exit 1

ansible=$(which ansible-playbook)
if [ "no$ansible" = "no" ]; then
    #statements
    echo "No ansible installed. Install ansible on local hosts..."
    yum install epel-release ansible -y
fi

echo "add ssh config to ~/.ssh/config"
if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
fi
if [ ! -f ~/.ssh/config ]; then
    #statements
    touch ~/.ssh/config
fi

hosts=$(egrep "^Host[[:space:]]+\*" ~/.ssh/config)
forward=$(egrep "^[[:space:]]+ForwardAgent[[:space:]]+yes" ~/.ssh/config)
checking=$(egrep "^[[:space:]]+StrictHostKeyChecking[[:space:]]+no" ~/.ssh/config)

if [ "no$hosts" = "no" ] && [ "no$forward" = "no" ] && [ "no$checking" = "no" ]; then
cat << EOF >> ~/.ssh/config
Host *
    ForwardAgent yes
    ServerAliveInterval 120
    ServerAliveCountMax 3
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF
fi


ansible-playbook -i hosts site.yml
