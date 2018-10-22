#!/usr/bin/env bash
cwd=$(cd "`dirname $0`" || exit 1; pwd)
if [ ! -d  ~/.kube ]; then
    #statements
    mkdir  ~/.kube
fi
cp ${cwd}/../../masters/files/admin.conf ~/.kube/config
export KUBECONFIG=${cwd}/../../masters/files/admin.conf

cd ${cwd}/../files/ || exit 1

kubectl apply -f flannel/.
kubectl apply -f dashboard/.
kubectl apply -f heapster/heapster-rbac.yaml
kubectl apply -f heapster/heapster.yaml
kubectl apply -f heapster/influxdb.yaml
# kubectl apply -f logrotate/.
kubectl apply -f sa/.

admin_token=$(kubectl describe sa admin| grep Tokens| awk '{print $NF}')
admin_secret=$(kubectl describe secret ${admin_token}| grep token: |awk '{print $NF}')
sed -i "s/token:.*$/token: ${admin_secret}/g" ../../../admin-token.conf

viewer_token=$(kubectl describe sa viewer| grep Tokens| awk '{print $NF}')
viewer_secret=$(kubectl describe secret ${viewer_token}| grep token: |awk '{print $NF}')
sed -i "s/token:.*$/token: ${viewer_secret}/g" ../../../viewer-token.conf
