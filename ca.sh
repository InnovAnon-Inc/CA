#! /bin/bash
set -exo nounset

[[ ! -z ${MKCA+x} ]] || MKCA=`dirname $(readlink -f $0)`
export MKCA

[[ ! -z ${CA+x} ]] || CA=ca.innovanon.com

[[ ! -z ${CADIR+x} ]] || CADIR=/root

cd $CADIR

[[ -d $CA ]] || \
mkdir -m 0750 $CA

cd $CA

mkdir certs crl newcerts
mkdir -m 0700 private
touch index.txt
echo 1000 > serial

$MKCA/openssl.sh $CA root
