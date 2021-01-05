#! /usr/bin/env bash
set -euxo pipefail

gen_ca () {
    [[ "$CANAME" ]]
    [[ "$CAEXTENSIONS" ]]
    mkdir -p $CANAME{,/newcerts}
    echo 01 >$CANAME/crlserial
    echo 01 >$CANAME/serial
    touch $CANAME/index{,.attr}
    openssl req -config openssl_root_ca.cnf -new -newkey rsa:16384 -sha512 -keyout $CANAME/${CANAME}ca.pvk -out $CANAME/${CANAME}ca.req -nodes
    while : ; do
      set +o pipefail
      SERIAL=$(cat /dev/urandom | tr -dc 'A-F0-9' | fold -w 16 | head -n 1)
      set -o pipefail
      grep -q "$SERIAL" root/serial || break
    done
    echo "$SERIAL" >> root/serial
    # Note: manually check that the serial is not already assigned to another certificate in root/index
    openssl ca -config openssl_root_ca.cnf -in $CANAME/${CANAME}ca.req -out $CANAME/${CANAME}ca.cer -policy root_ca_dn_policy -extensions $CAEXTENSIONS
    openssl x509 -in $CANAME/${CANAME}ca.cer -out $CANAME/${CANAME}ca_der.cer -outform DER
}

for CANAME in \
personal-emailvalidated \
personal-individualvalidated \
personal-organizationvalidated \
webserver-domainvalidated \
webserver-individualvalidated \
webserver-organizationvalidated \
webserver-extendedvalidation \
codesigning-extendedvalidation \
timestamping
do
  CAEXTENSIONS=${CANAME}_ca_certificate_extensions
  gen_ca
done

CANAME=codesigning-individualvalidated             \
CAEXTENSIONS=codesigning_ca_certificate_extensions \
gen_ca

CANAME=codesigning-organizationvalidated           \
CAEXTENSIONS=codesigning_ca_certificate_extensions \
gen_ca

CANAME=timestamping-extendedvalidation              \
CAEXTENSIONS=timestamping_ca_certificate_extensions \
gen_ca

