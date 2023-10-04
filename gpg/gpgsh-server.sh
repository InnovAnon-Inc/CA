#! /usr/bin/env bash
set -euo pipefail

netkitty ./gpgsh.sh
exit 0


T="$(mktemp -d)"
trap "rm -fr $T" 0
T="$T/f"
mkfifo "$T"

GPG_FLAGS="${GPG_FLAGS:---compress-level=9 --bzip2-compress-level=9}"
GPG_FLAGS="${GPG_FLAGS} --batch --no-greeting --no-tty --quiet"

#cat "$T" |
gpg $GPG_FLAGS --decrypt --allow-multiple-messages - < "$T" 2> /dev/null |
/bin/bash -il 2>&1 |
while read -r line ; do
  gpg $GPG_FLAGS --encrypt --recipient InnovAnon-Inc@protonmail.com - <<< "$line"
done |
nc -kl 127.0.0.1 1234 > "$T"

