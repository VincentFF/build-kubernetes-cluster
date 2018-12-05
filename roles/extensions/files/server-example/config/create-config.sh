kubectl --kubeconfig /root/.kube/config -n default create configmap impush-potato --from-file=potato.yaml 
kubectl --kubeconfig /root/.kube/config -n default create configmap impush-message --from-file=message.yml 
kubectl --kubeconfig /root/.kube/config -n default create configmap impush-infoserver --from-file=infoserver.yml 
