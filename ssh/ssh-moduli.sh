#! /usr/bin/env bash
set -exu

BITS=${1:-16384}

DIR=`mktemp -d`
trap "rm -rf $DIR" 0
cd $DIR

while : ; do
  ( while : ; do
    ssh-keygen -G moduli-$BITS.candidates -b $BITS
    #ssh-keygen -T moduli-$BITS -f moduli-$BITS.candidates

    for k in 2 3 5 ; do
    ssh-keygen -T moduli-$BITS-$k -f moduli-$BITS.candidates -a $k
    done

    break
  done )

  "`dirname "$(readlink -f "$0")"`"/../../repo/comms.sh moduli-$BITS-{2,3,5} > moduli-$BITS

  [[ `stat --format=%s moduli-$BITS` -eq 0 ]] ||
  break
done

sudo cp -v {,/etc/ssh/}moduli-$BITS

