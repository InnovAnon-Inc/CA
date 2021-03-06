#! /usr/bin/env bash
set -exu

#
# usage:
#   $0 <bits> <type> <dir> <key name> <hostname> <cakey>
# defaults:
#   $0 16384 rsa /etc/ssh ssh_host_${TYPE}_key

BITS=${1:-16384}
TYPE=${2:-rsa}
DIR=${3:-/etc/ssh}
KEY=${4:-ssh_host_${TYPE}_key}
HOST=$5
CAKEY=${6:-/root/$HOST/private/$HOST.key}


ssh-keygen -b $BITS -t $TYPE -N '' -f $DIR/$KEY
ssh-keygen -s $CAKEY -I $HOST -h -n $HOST $KEY.pub

#ssh-keygen -b 16384 -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key
#ssh-keygen \
#  -s /root/host0.innovanon.com/private/host0.innovanon.com.key \
#  -I host0.innovanon.com \
#  -h \
#  -n host0.innovanon.com \
#  /etc/ssh/ssh_host_rsa_key.pub

