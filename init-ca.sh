#! /bin/bash
set -exu

DIR=`dirname "$(readlink -f "$0")"`"

[[ ! -z ${CA+x} ]] ||
CA=./demoCA/

[[ ! -z ${BITS+x} ]] ||
BITS=16384

[[ -d $CA ]] ||
mkdir -vm 0750 $CA

[[ -e $CA/openssl.cnf ]] ||
cp -v openssl.cnf $CA

cd $CA

mkdir -vm 0644 certs crl newcerts
mkdir -vm 0700 private
touch index.txt
[[ ! -e serial ]] ||
echo 1000 > serial

$DIR/openssl.sh $CA root $BITS

