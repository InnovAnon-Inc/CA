#! /usr/bin/env bash
set -exu

BITS=${1:-16384}

cd /etc/ssh

DIR=`mktemp -d`
trap "rm -rf $DIR" 0
( cd $DIR

ssh-keygen -G moduli-$BITS.candidates -b $BITS
#ssh-keygen -T moduli-$BITS -f moduli-$BITS.candidates

for k in 2 3 5 ; do
ssh-keygen -T moduli-$BITS-$k -f moduli-$BITS.candidates -a $k
done

)

cat moduli-$BITS-{2,3,5} > moduli-$BITS

