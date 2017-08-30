#! /bin/sh
set -exo nounset

test ! -z ${MKCA+x} || MKCA=`dirname $(readlink -f $0)`
export MKCA

test ! -z ${CA+x} || CA=ca.innovanon.com

test ! -z ${CADIR+x} || CADIR=/root

cd $CADIR

test -d $CA || \
mkdir -m 0750 $CA

cd $CA

mkdir certs crl newcerts
mkdir -m 0700 private
touch index.txt
echo 1000 > serial

$MKCA/openssl.sh $CA root
