#! /usr/bin/env bash
set -euo pipefail

( cat <<- EOF
  #python -c 'import pty; pty.spawn("/bin/bash")'
  export TERM=$TERM
  export SHELL=$SHELL
  $(stty size | awk '{printf "stty rows %s cols %s\n", $1, $2}')
  #reset
  expect -c 'spawn bash; interact'
EOF
  #stty raw -echo ; echo ; echo
  cat ) |
./gpgsh-client.sh

