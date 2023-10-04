#! /usr/bin/env bash
set -exu

BITS=${1:-16384}

A=${A:-0}

DIR=`mktemp -d`
trap "rm -rf $DIR" 0
cd $DIR

while : ; do
  while : ; do
    ssh-keygen -G moduli-$BITS.candidates -b $BITS
    #ssh-keygen -T moduli-$BITS -f moduli-$BITS.candidates

    if [[ "$A" ]] ; then
    for k in 2 3 5 ; do
      ssh-keygen -T moduli-$BITS-$k -f moduli-$BITS.candidates -a $k ||
      continue 3
    done
    else
    ssh-keygen -T moduli-$BITS -f moduli-$BITS.candidates ||
    continue 2
    fi
    break
  done

  if [[ "$A" ]] ; then
  comms moduli-$BITS-{2,3,5} > moduli-$BITS
  fi

  (( `stat --format=%s moduli-$BITS` == 0 )) ||
  break
done

sudo cp -v {,/etc/ssh/}moduli-$BITS

