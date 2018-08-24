#!/usr/bin/env bash

dir=$(cd `dirname $0` && pwd)
files="${dir}/../files"
cd $dir
chmod +x cfssl cfssljson

# generate etcd certs
./cfssl gencert -initca ${files}/etcd/ca-csr.json | ./cfssljson -bare ${files}/etcd/ca
./cfssl gencert -ca=${files}/etcd/ca.pem -ca-key=${files}/etcd/ca-key.pem -config=${files}/etcd/ca-config.json -profile=client ${files}/etcd/client.json | ./cfssljson -bare ${files}/etcd/client
./cfssl gencert -ca=${files}/etcd/ca.pem -ca-key=${files}/etcd/ca-key.pem -config=${files}/etcd/ca-config.json -profile=server ${files}/etcd/server.json| ./cfssljson -bare ${files}/etcd/server
./cfssl gencert -ca=${files}/etcd/ca.pem -ca-key=${files}/etcd/ca-key.pem -config=${files}/etcd/ca-config.json -profile=peer ${files}/etcd/peer.json| ./cfssljson -bare ${files}/etcd/peer

# generate kubernetes certs
./cfssl gencert -initca ${files}/kubernetes/ca-csr.json | ./cfssljson -bare ${files}/kubernetes/ca
./cfssl gencert -ca=${files}/kubernetes/ca.pem -ca-key=${files}/kubernetes/ca-key.pem -config=${files}/kubernetes/ca-config.json -profile=kubernetes ${files}/kubernetes/apiserver.json| ./cfssljson -bare ${files}/kubernetes/apiserver
./cfssl gencert -ca=${files}/kubernetes/ca.pem -ca-key=${files}/kubernetes/ca-key.pem -config=${files}/kubernetes/ca-config.json -profile=kubernetes ${files}/kubernetes/apiserver-kubelet-client.json| ./cfssljson -bare ${files}/kubernetes/apiserver-kubelet-client

# generate proxy certs
./cfssl gencert -initca ${files}/kubernetes/front-ca-csr.json | ./cfssljson -bare ${files}/kubernetes/front-proxy-ca
./cfssl gencert -ca=${files}/kubernetes/front-proxy-ca.pem -ca-key=${files}/kubernetes/front-proxy-ca-key.pem -config=${files}/kubernetes/ca-config.json -profile=kubernetes ${files}/kubernetes/front-proxy-client.json| ./cfssljson -bare ${files}/kubernetes/front-proxy-client



# copy etcd certs to etcd
cp ${files}/etcd/*.pem ${dir}/../../etcd/files/

# copy etcd certs to kubernetes
cp ${files}/etcd/ca.pem ${dir}/../../masters/files/etcd/ca.crt
cp ${files}/etcd/client.pem ${dir}/../../masters/files/apiserver-etcd-client.crt
cp ${files}/etcd/client-key.pem ${dir}/../../masters/files/apiserver-etcd-client.key

# copy kubernetes certs
cp ${files}/kubernetes/ca.pem ${dir}/../../masters/files/ca.crt
cp ${files}/kubernetes/ca-key.pem ${dir}/../../masters/files/ca.key
cp ${files}/kubernetes/front-proxy-ca.pem ${dir}/../../masters/files/front-proxy-ca.crt
cp ${files}/kubernetes/front-proxy-ca-key.pem ${dir}/../../masters/files/front-proxy-ca.key
cp ${files}/kubernetes/apiserver.pem ${dir}/../../masters/files/apiserver.crt
cp ${files}/kubernetes/apiserver-key.pem ${dir}/../../masters/files/apiserver.key
cp ${files}/kubernetes/apiserver-kubelet-client.pem ${dir}/../../masters/files/apiserver-kubelet-client.crt
cp ${files}/kubernetes/apiserver-kubelet-client-key.pem ${dir}/../../masters/files/apiserver-kubelet-client.key
cp ${files}/kubernetes/front-proxy-client.pem ${dir}/../../masters/files/front-proxy-client.crt
cp ${files}/kubernetes/front-proxy-client-key.pem ${dir}/../../masters/files/front-proxy-client.key
