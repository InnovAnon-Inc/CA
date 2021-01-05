#! /usr/bin/env bash
set -euxo pipefail
(( ! $#   ))
(( ! $UID ))
cd "`dirname "$(readlink -f "$0")"`"

lock () {
  (( $# ))
  sudo chattr -i       "$@"
  sudo chmod  -w       "$@"
  sudo chown root:root "$@"
  sudo chattr +i       "$@"
}
create-lock () {
  (( $# > 1 ))
  local F="$1"
  shift
  if [[ ! -e "$F" ]] ; then
    "$@"
  fi
  lock "$F"
}
chain () {
  (( $# > 1 ))
  local F="$1"
  shift
  cat "$@" > "$F"
}
create-lock-chain () {
  (( $# ))
  create-lock "$1" \
  chain       "$@"
}

for k in "$ROOTCACERPATH" "$CACERPATH" ; do # create CA chain
  create-lock "$k".pem \
  openssl x509 -in "$k".cer -out "$k".pem -outform PEM
done
create-lock-chain "$CACERPATH".chain.pem "$CACERPATH".pem "$ROOTCACERPATH".pem
openssl verify -CAfile "$ROOTCACERPATH".pem "$CACERPATH".chain.pem

if [[ ! -e "$PVKPATH".pvk ]] ; then # create private key
  openssl req -config "$CAFILE" -new \
    -newkey rsa:16384 -sha512 \
    -keyout "$PVKPATH".pvk -out "$REQPATH".req \
    -nodes

  set +o pipefail
  SERIAL=
  while [[ -z "$SERIAL" ]] || (( `grep -c "$SERIAL" "$CANAME/serial"` )) ; do
    cat /dev/urandom | tr -dc 'A-F0-9' | fold -w 16 | head -n 1 | tee "$CANAME"/serial
    SERIAL=`cat "$CANAME"/serial`
  done
  set -o pipefail
fi
#lock "$REQPATH".req "$PVKPATH".pvk
lock "$PVKPATH".pvk

create-lock "$PVKPATH".pvk.pem \
openssl rsa -in "$PVKPATH".pvk -out "$PVKPATH".pvk.pem

create-lock-chain "$PVKPATH".pvk.chain.pem "$PVKPATH".pvk.pem "$CACERPATH".pem "$ROOTCACERPATH".pem
openssl verify -CAfile "$CACERPATH".chain.pem "$PVKPATH".pvk.chain.pem

create-lock "$CERPATH".cer \
openssl ca -config "$CAFILE" -name "$CANAME"_ca \
    -in "$REQPATH".req -out "$CERPATH".cer \
    -subj "$SUBJECTDN"

create-lock "$CERPATH".pem \
openssl x509 -in "$CERPATH".cer -out "$CERPATH".pem -outform PEM

create-lock-chain "$CERPATH".chain.pem "$CERPATH".pem "$CACERPATH".pem "$ROOTCACERPATH".pem
openssl verify -CAfile "$CACERPATH".chain.pem "$CERPATH".chain.pem

# Optionally export the newly generated certificate to a PKCS12 file:
create-lock "$PKCS12PATH".p12 \
openssl pkcs12 -export -nodes \
    -out "$PKCS12PATH".p12 -in "$CERPATH".cer -inkey "$PVKPATH".pvk \
    -name "$FRIENDLYNAME" \
    -certfile "$CACERPATH".cer -caname "$FRIENDLYCANAME"

