#! /usr/bin/env bash
set -exu
DIR="`dirname "$(readlink -f "$0")"`"

S=${1:-9}
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

for ((i = S; i <= N; ++i)); do
$DIR/ssh-moduli.sh "$((2**i))"
done

