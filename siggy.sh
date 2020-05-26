#! /usr/bin/env bash
set -exu

gpg --quiet --list-keys   |
grep -A1 'pub[[:space:]]' |
awk '!(NR%2)'

