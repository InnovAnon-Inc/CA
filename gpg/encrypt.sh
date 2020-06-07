#! /usr/bin/env bash
set -euxo pipefail
(( $# ))

gpg --recipient "$1" --encrypt --armor |
awk '{printf("%s\\n", $0)}' |
xclip -selection c
#cat -e |
#sed 's/\$/\\n/g' |
#xclip -selection c

