#! /bin/bash
set -exu
[[ $# -eq 0 ]]

DIR="`dirname "$(readlink -f "$0")"`"
gpg --send-keys `$DIR/siggy.sh`

