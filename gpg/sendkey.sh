#! /usr/bin/env bash
set -exu
(( ! $# ))

gpg --send-keys `siggy`

