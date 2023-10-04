#! /usr/bin/env bash
set -exu

DIR="`dirname "$(readlink -f "$0")"`"

if (( ! $# )) ; then install=( siggy.sh sendkey.sh editkey.sh subkey.sh )
else                     install="$@"
fi

for k in "${install[@]}" ; do
sudo ln -fsv "$DIR/$k" "/usr/local/bin/${k%.sh}"
done

