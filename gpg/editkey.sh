#! /usr/bin/env bash
set -exu
(( $# == 0 ))

for k in `siggy` ; do
gpg --edit-key $k
done

