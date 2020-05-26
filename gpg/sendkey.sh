#! /usr/bin/env bash
set -exu
(( $# == 0 ))

gpg --send-keys `siggy`

