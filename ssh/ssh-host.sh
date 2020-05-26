#! /usr/bin/env bash
set -exu
BITS=${1:-16384}
shift

TYPE=${1:rsa}
shift
echo $BITS $TYPE

exit 2

ssh-keygen -b 16384 -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key
ssh-keygen \
  -s /root/host0.innovanon.com/private/host0.innovanon.com.key \
  -I host0.innovanon.com \
  -h \
  -n host0.innovanon.com \
  /etc/ssh/ssh_host_rsa_key.pub

