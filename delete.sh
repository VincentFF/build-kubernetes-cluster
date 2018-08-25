#!/usr/bin/env bash

ansible -i hosts -a "kubeadm reset -f"
ansible -i masters -a "systemctl stop etcd"
ansible -i masters -a "rm -f /etc/ssl/etcd/*"
ansible -i masters -a "rm -rf /var/lib/etcd/default.etcd/*"
