#! /usr/bin/env bash
set -exu

[[ "${MKCA+x}" ]] || MKCA=`dirname $(readlink -f $0)`
export MKCA

[[ "${CA+x}" ]] || CA=ca.innovanon.com

[[ "${CADIR+x}" ]] || CADIR=/root

cd $CADIR

[[ -d $CA ]] ||
mkdir -m 0750 $CA

cd $CA

[[ -e openssl.cnf ]] ||
cp -v $MKCA/openssl.cnf .

mkdir certs crl newcerts
mkdir -m 0700 private
touch index.txt
echo 1000 > serial

$MKCA/openssl.sh $CA root 16384

