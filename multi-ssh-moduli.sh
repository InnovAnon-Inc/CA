#! /bin/bash
set -exo nounset
cd "`dirname "$(readlink -f "$0")"`"

# TODO start at 13
for k in {10..14} ; do
  K=`echo "2 ^ $k" | bc`
  #BITS=$K                     \
  #sudo --preserve-env=BITS -- \
  #nice -n +20              -- \
  ./ssh-moduli.sh $K
done

