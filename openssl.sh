#! /bin/sh
set -exo nounset

# $0 HOST OP

test $# -eq 2
OP=$2

HOST=$1
KEY=private/$HOST.key
CSR=$HOST.csr
CRT=certs/$HOST.crt

trap "rm -f $CSR" 0

test ! -f $KEY
test ! -f $CRT

openssl genpkey -out $KEY -algorithm RSA -pkeyopt rsa_keygen_bits:16384
openssl req -key $KEY -new -out $CSR
if x$OP == xroot ; then
	openssl ca -in $CSR -out $CRT -selfsign -extensions v3_ca
elif x$OP == xsign ; then
	openssl ca -in $CSR -out $CRT -extensions v3_ca
else exit 2
fi
