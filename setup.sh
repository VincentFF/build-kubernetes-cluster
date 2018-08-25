#!/usr/bin/env bash
cwd=$(dirname $0)
cd $cwd || exit 1

ansible=$(which ansible-playbook)
if [[ "no$ansible" == "no" ]]; then
    #statements
    echo "No ansible installed. Install ansible on local hosts..."
    yum install epel-release ansible -y
fi
ansible-playbook -i hosts site.yml
