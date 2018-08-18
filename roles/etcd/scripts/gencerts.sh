#!/usr/bin/env bash

dir=$(cd `dirname $0` && pwd)
files="${dir}/../files"
cd $dir
# gen certs
./cfssl gencert -initca ${files}/ca-csr.json | ./cfssljson -bare ${files}/ca
./cfssl gencert -ca=${files}/ca.pem -ca-key=${files}/ca-key.pem -config=${files}/ca-config.json -profile=client ${files}/client.json | ./cfssljson -bare ${files}/client
./cfssl gencert -ca=${files}/ca.pem -ca-key=${files}/ca-key.pem -config=${files}/ca-config.json -profile=server ${files}/server.json| ./cfssljson -bare ${files}/server
./cfssl gencert -ca=${files}/ca.pem -ca-key=${files}/ca-key.pem -config=${files}/ca-config.json -profile=peer ${files}/peer.json| ./cfssljson -bare ${files}/peer

cp ${files}/ca.pem ${dir}/../../masters/files/etcd/ca.crt
cp ${files}/client.pem ${dir}/../../masters/files/apiserver-etcd-client.crt
cp ${files}/client-key.pem ${dir}/../../masters/files/apiserver-etcd-client.key
