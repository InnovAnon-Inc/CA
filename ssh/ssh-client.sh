#! /usr/bin/env bash
set -exu

ssh-keygen -b 16384 -t rsa -N ''
ssh-keygen -s /root/host0.innovanon.com/private/host0.innovanon.com.key -I host0.innovanon.com -n default $HOME/.ssh/id_rsa.pub
