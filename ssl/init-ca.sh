#! /usr/bin/env bash
set -exu

DIR=`dirname "$(readlink -f "$0")"`"

[[ "${CA+x}" ]] ||
CA=./demoCA/

[[ "${BITS+x}" ]] ||
BITS=16384

[[ -d $CA ]] ||
mkdir -vm 0750 $CA

[[ -e $CA/openssl.cnf ]] ||
cp -v openssl.cnf $CA

cd $CA

mkdir -vm 0750 certs crl newcerts
mkdir -vm 0700 private
[[ -e index.txt ]] ||
touch index.txt
[[ -e serial ]] ||
echo 1000 > serial

$DIR/openssl.sh $CA root $BITS

