#!/usr/bin/env bash

ansible -i hosts all -a "kubeadm reset -f"
ansible -i hosts masters -a "systemctl stop etcd"
ansible -i hosts masters -a "rm -rf /etc/ssl/etcd/*"
ansible -i hosts masters -a "rm -rf /var/lib/etcd/default.etcd/*"
