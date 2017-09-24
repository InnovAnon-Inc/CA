#! /bin/sh
set -exo nounset

BITS=16384

cd /etc/ssh
ssh-keygen -G moduli-$BITS.candidates -b $BITS
ssh-keygen -T moduli-$BITS -f moduli-$BITS.candidates
