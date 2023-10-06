#! /usr/bin/env bash
set -euxo nounset -o pipefail

if (( ! UID )) &&
   (( ! ${TEAMHACK_DOCKER:-0} )) ; then
echo de-escalate privileges 1>&2
exit 1
fi

. ./lib/common.env
. ./lib/check.env
. ./lib/cmds.env

CMD="$(basename "$0")"

case "$CMD" in
init_ca|root_ca|nuke)
if (( $# )) ; then
echo usage: $0 1>&2
exit 1
fi
"$CMD"
;;

intermediate_ca|site|revoke)
if (( $# != 2 )) ; then
cat 1>&2 << EOF
usage: $0 <ca_name> <site_name>
EOF
exit 1
fi
"$CMD" "$@"
;;

*) cat 1>&2 << EOF
\`$0\' should not be called directly
init_ca
root_ca
intermediate_ca <ca_name>
site            <ca_name> <site_name>
revoke          root_ca   <ca_name>
revoke          <ca_name> <site_name>
EOF
exit 1
;;
esac

