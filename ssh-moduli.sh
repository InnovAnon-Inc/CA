#! /bin/bash
set -exu

if   [[ $# -eq 1     ]] ; then BITS="$1"
elif [[ -z ${BITS+x} ]] ; then BITS=16384 ; fi

cd /etc/ssh
ssh-keygen -G moduli-$BITS.candidates -b $BITS
ssh-keygen -T moduli-$BITS -f moduli-$BITS.candidates

