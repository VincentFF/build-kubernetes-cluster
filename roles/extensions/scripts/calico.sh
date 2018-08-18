#!/usr/bin/env bash
cwd=$(cd `dirname $0`; pwd)
if [[ ! -d  ~/.kube ]]; then
    #statements
    mkdir  ~/.kube
fi
cp ${cwd}/../../masters/files/admin.conf ~/.kube/config
export KUBECONFIG=${cwd}/../../masters/files/admin.conf
kubectl create -f  ${cwd}/../files/calico/.
