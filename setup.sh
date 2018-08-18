#!/usr/bin/env bash
cwd=$(dirname $0)
cd $cwd || exit

ansible=$(which ansible-playbook)
if [[ "no$ansible" == "no" ]]; then
    #statements
    yum install ansible -y
fi
ansible-playbook -i hosts site.yml
