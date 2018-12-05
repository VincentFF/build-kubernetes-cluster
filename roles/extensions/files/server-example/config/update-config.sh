cwd=$(cd `dirname $0` || exit 1; pwd)
project=$(cat ${cwd}/../vars/project)
version=$(cat ${cwd}/../vars/version)-$(date '+%Y-%m-%d-%H:%M')
backup=/backup/ptonline/${project}

# backup config
if [ ! -d ${backup} ]; then
  mkdir -p ${backup} || exit 1
fi
cp -r ${cwd}  ${backup}/config-${version}

# update config
kubectl create configmap impush-potato --from-file=potato.yaml --dry-run -o yaml | kubectl  --kubeconfig /root/.kube/config -n default replace -f -
kubectl create configmap impush-message --from-file=message.yml --dry-run -o yaml | kubectl --kubeconfig /root/.kube/config -n default replace -f -
kubectl create configmap impush-infoserver --from-file=infoserver.yml --dry-run -o yaml | kubectl --kubeconfig /root/.kube/config -n default replace -f -
