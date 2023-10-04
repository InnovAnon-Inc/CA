#! /usr/bin/env bash
set -exu
DIR="`dirname "$(readlink -f "$0")"`"

S=${1:-10}
##S=${1:-12}
N=${2:-12}
##N=${2:-14}
#eval pows=( {$S..$N} )
#prefix=( "${pows[@]/#/2 ^ }" )
#suffix=( "${prefix[@]/%/; }" )
#for bits in `echo ${suffix[@]} | bc` ; do
#  nice -n +20 -- \
#  $DIR/ssh-moduli.sh $bits
#done

declare -a segnums
for ((i = S; i <= N; ++i)); do
I="$((2 ** i))"
$DIR/ssh-moduli.sh "$I"
segnums+=( "$I" )
done

#segstr="${segnums[@]}"
#comstr=${segstr// /,}
#eval parts=( "/etc/ssh/moduli-{$comstr}" )
parts="`parts /etc/ssh/moduli- "${segnums[@]}"`"

trap "mv -v /etc/ssh/moduli.bkf /etc/ssh/moduli" 0
mv -v /etc/ssh/moduli{,.bkf}

cat $parts |
sudo tee /etc/ssh/moduli > /dev/null

#trap "rm -v /etc/ssh/moduli.bkf" 0

