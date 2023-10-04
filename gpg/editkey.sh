#! /usr/bin/env bash
set -exu
(( ! $# ))

for k in `siggy` ; do
gpg --edit-key $k
done

