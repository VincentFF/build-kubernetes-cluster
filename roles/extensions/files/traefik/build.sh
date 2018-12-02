#kubectl create secret tls ptssl --cert=ssl.crt --key=ssl.key -n kube-system
#kubectl create configmap traefik-config --from-file=traefik.toml -n kube-system
kubectl apply -f traefik-rbac.yaml
kubectl apply -f traefik-ds.yaml
kubectl apply -f ui.yaml
