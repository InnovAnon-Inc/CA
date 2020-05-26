#! /bin/bash
set -exu

# $0 HOST OP

[[ $# -eq 3 ]]
OP=$2
BITS=$3

HOST=$1
KEY=private/$HOST.key
CSR=$HOST.csr
CRT=certs/$HOST.crt

trap 'mv -v /etc/ssl/openssl.cnf.bkf /etc/ssl/openssl.cnf' 0
mv -v /etc/ssl/openssl.cnf{,.bkf}
cp -v {,/etc/ssl/}openssl.cnf

( trap "rm -f $CSR" 0

[[ ! -f $KEY ]]
[[ ! -f $CRT ]]

openssl genpkey -out $KEY -algorithm RSA -pkeyopt rsa_keygen_bits:$BITS
chmod -v 0400 $KEY
openssl req     -key $KEY -new -out $CSR
if   [[ x$OP = xroot ]] ; then
	openssl ca -in $CSR -out $CRT -selfsign -extensions v3_ca
elif [[ x$OP = xsign ]] ; then
	openssl ca -in $CSR -out $CRT           -extensions v3_ca
else exit 2
fi
chmod -v 0444 $CRT )

echo SUCCESS :\)

