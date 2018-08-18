cwd=$(cd `dirname $0`; pwd)
# if [[ ! -d  ~/.kube ]]; then
#     #statements
#     mkdir  ~/.kube
# fi
# cp ${cwd}/../../masters/files/admin.conf ~/.kube/config
export KUBECONFIG=${cwd}/../../masters/files/admin.conf

cd ${cwd}/../files/

kubectl create -f dashboard/.
kubectl create -f heapster/heapster-rbac.yaml heapster/heapster.yaml heapster/influxdb.yaml
kubectl create -f logrotate/.
kubectl create -f sa/.
