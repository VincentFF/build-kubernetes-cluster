#!/usr/bin/env bash

cwd=$(cd "`dirname $0`" || exit 1 && pwd)
cfssl="$cwd/../../../certs/scripts/cfssl"
cfssljson="$cwd/../../../certs/scripts/cfssljson"

chmod +x $cfssl $cfssljson

$cfssl gencert -initca $cwd/certs/ca-csr.json | $cfssljson -bare $cwd/certs/ca
$cfssl gencert -ca=$cwd/certs/ca.pem -ca-key=$cwd/certs/ca-key.pem -config=$cwd/certs/ca-config.json -profile=kubernetes $cwd/certs/domin-server.json| $cfssljson -bare $cwd/certs/domain
mv $cwd/certs/domain.pem $cwd/certs/domain.crt
mv $cwd/certs/domain-key.pem $cwd/certs/domain.key
