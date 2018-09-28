#!/usr/bin/env bash

ansible -i hosts all -a "kubeadm reset -f"
ansible -i hosts etcds -a "systemctl stop etcd"
ansible -i hosts etcds -a "rm -rf /etc/ssl/etcd/*"
ansible -i hosts etcds -a "rm -rf /var/lib/etcd/default.etcd/*"
