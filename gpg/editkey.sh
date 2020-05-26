#! /usr/bin/env bash
set -exu
[[ $# -eq 0 ]]

DIR="`dirname "$(readlink -f "$0")"`"
for k in `$DIR/siggy.sh` ; do
gpg --edit-key $k
done

