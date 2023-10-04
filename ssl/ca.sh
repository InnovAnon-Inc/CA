#! /usr/bin/env bash
set -euxo nounset
(( $# == 2 ))
(( $UID ))
#  0 Personal certificates, e-mail validation
#  1 Personal certificates, individual validation
#  2 Personal certificates, organization validation
#  3 Web server certificates, domain validation
#  4 Web server certificates, individual validation
#  5 Web server certificates, organization validation
#  6 Web server certificates, Extended Validation
#  7 Code signing certificates, individual validation
#  8 Code signing certificates, organization validation
#  9 Code signing certificates, Extended Validation
# 10 Time stamping certificates
# 11 Time stamping certificates, Extended Validation

OP="$1"
FRIENDLYNAME="$2"
SUBJECTDN='/C=IT/O=InnovAnon, Inc.'

# Perform the following replacements:
# Variable          | Value
# ------------------|-----------------------------------------------------------------------
#  `CAFILE`         | The `.cnf` file containing the configuration for the CA you are using
#  `PVKPATH`        | The path to the private key file you are generating
#  `REQPATH`        | The path to the certificate request file you are generating
#  `CERPATH`        | The path to the certificate file you are generating
#  `PKCS12PATH`     | The path to the .p12 file you are generating
#  `CANAME`         | The CA name, see step 2
#  `SUBJECTDN`      | The DN of the subject you are issuing the certificate to, e.g. `/C=IT/O=Sample Organization/CN=Sample Subject`. See the policy sections in each `.cnf` file for the DN fields you will need to include for each certificate type
#  `FRIENDLYNAME`   | The "friendly name" for the certificate subject (usually, the CN field of the DN)
#  `FRIENDLYCANAME` | The "friendly name" for the CA certificate subject (usually, the CN field of the DN)

CADIR=configs
ROOTCAFILE=$CADIR/openssl_root_ca.cnf
FRIENDLYCANAME="$FRIENDLYNAME"
SUBJECTDN="$SUBJECTDN/CN=$FRIENDLYNAME"

BITS=16384
DAYS=3650
SHA=sha512

# 1. Open the configuration files and edit them where the comments ask you to do
#    so.

# 2. Generate the root CA by running the following commands:
[[ -d root ]] ||
mkdir -pv root{,/newcerts}
grep -q '^01' root/crlserial ||
echo 01 > root/crlserial
grep -q '^01' root/serial ||
echo 01 > root/serial
touch     root/index{,.attr}
if [[ ! -f root/rootca.cer ]] ; then
ROOTCASERIAL=$(cat /dev/urandom | tr -dc 'A-F0-9' | fold -w 16 | head -n 1)
openssl req -nodes                      \
  -config $CADIR/openssl_root_ca.cnf    \
  -x509                                 \
  -newkey rsa:$BITS                     \
  -$SHA                                 \
  -keyout root/rootca.pvk               \
  -out    root/rootca.cer               \
  -days $DAYS                           \
  -set_serial 0x$ROOTCASERIAL           \
  -extensions root_ca_extensions
fi
[[ -f root/rootca_der.cer ]] ||
openssl x509                            \
  -in root/rootca.cer                   \
  -out root/rootca_der.cer              \
  -outform DER

# 3. Generate the intermediate CAs you need by editing the `distinguished_name`
#    setting in `openssl_root_ca.cnf` and running the following commands:

#CATYPE=?
# Replace `CANAME` and `CAEXTENSIONS` as follows:
# | For the following CA type...                       | use this `CANAME`...                | and these `CAEXTENSIONS`
# |----------------------------------------------------|-------------------------------------|-------------------------------------------------------------
# | Personal certificates, e-mail validation           | `personal-emailvalidated`           | `personal-emailvalidated_ca_certificate_extensions`
# | Personal certificates, individual validation       | `personal-individualvalidated`      | `personal-individualvalidated_ca_certificate_extensions`
# | Personal certificates, organization validation     | `personal-organizationvalidated`    | `personal-organizationvalidated_ca_certificate_extensions`
# | Web server certificates, domain validation         | `webserver-domainvalidated`         | `webserver-domainvalidated_ca_certificate_extensions`
# | Web server certificates, individual validation     | `webserver-individualvalidated`     | `webserver-individualvalidated_ca_certificate_extensions`
# | Web server certificates, organization validation   | `webserver-organizationvalidated`   | `webserver-organizationvalidated_ca_certificate_extensions`
# | Web server certificates, Extended Validation       | `webserver-extendedvalidation`      | `webserver-extendedvalidation_ca_certificate_extensions`
# | Code signing certificates, individual validation   | `codesigning-individualvalidated`   | `codesigning_ca_certificate_extensions`
# | Code signing certificates, organization validation | `codesigning-organizationvalidated` | `codesigning_ca_certificate_extensions`
# | Code signing certificates, Extended Validation     | `codesigning-extendedvalidation`    | `codesigning-extendedvalidation_ca_certificate_extensions`
# | Time stamping certificates                         | `timestamping`                      | `timestamping_ca_certificate_extensions`
# | Time stamping certificates, Extended Validation    | `timestamping-extendedvalidation`   | `timestamping_ca_certificate_extensions`

case $CATYPE in
 0) CANAME=personal-emailvalidated
    CAEXTENSIONS=${CANAME}_ca_certificate_extensions
    CAFILE=$CADIR/openssl_personal_cas.cnf
    ;;
 1) CANAME=personal-individualvalidated
    CAEXTENSIONS=${CANAME}_ca_certificate_extensions
    CAFILE=$CADIR/openssl_personal_cas.cnf
    ;;
 2) CANAME=personal-organizationvalidated
    CAEXTENSIONS=${CANAME}_ca_certificate_extensions
    CAFILE=$CADIR/openssl_personal_cas.cnf
    ;;
 3) CANAME=webserver-domainvalidated
    CAEXTENSIONS=${CANAME}_ca_certificate_extensions
    CAFILE=$CADIR/openssl_webserver_cas.cnf
    ;;
 4) CANAME=webserver-individualvalidated
    CAEXTENSIONS=${CANAME}_ca_certificate_extensions
    CAFILE=$CADIR/openssl_webserver_cas.cnf
    ;;
 5) CANAME=webserver-organizationvalidated
    CAEXTENSIONS=${CANAME}_ca_certificate_extensions
    CAFILE=$CADIR/openssl_webserver_cas.cnf
    ;;
 6) CANAME=webserver-extendedvalidated
    CAEXTENSIONS=${CANAME}_ca_certificate_extensions
    CAFILE=$CADIR/openssl_webserver_cas.cnf
    ;;
 7) CANAME=codesigning-individualvalidated
    CAEXTENSIONS=codesigning_ca_certificate_extensions
    CAFILE="$CADIR/openssl_codesigning_cas.cnf"
    ;;
 8) CANAME=codesigning-organizationvalidated
    CAEXTENSIONS=codesigning_ca_certificate_extensions
    CAFILE="$CADIR/openssl_codesigning_cas.cnf"
    ;;
 9) CANAME=codesigning-extendedvalidation
    CAEXTENSIONS=${CANAME}_ca_certificate_extensions
    CAFILE="$CADIR/openssl_codesigning_cas.cnf"
    ;;
10) CANAME=timestamping
    CAEXTENSIONS=timestamping_ca_certificate_extensions
    CAFILE=$CADIR/openssl_timestamping_cas.cnf
    ;;
11) CANAME=timestamping-extendedvalidation
    CAEXTENSIONS=timestamping_ca_certificate_extensions
    CAFILE=$CADIR/openssl_timestamping_cas.cnf
    ;;
 *) exit 2 ;;
esac

[[ -d $CANAME ]] ||
mkdir -p ${CANAME}{,/newcerts}
[[ -f $CANAME/crlserial ]] ||
echo 01 >${CANAME}/crlserial
[[ -f $CANAME/serial ]] ||
echo 01 >${CANAME}/serial
touch    ${CANAME}/index{,.attr}
[[ -f $CANAME/${CANAME}ca.req ]] ||
openssl req -nodes                      \
  -config $CADIR/openssl_root_ca.cnf    \
  -new                                  \
  -newkey rsa:$BITS                     \
  -$SHA                                 \
  -keyout ${CANAME}/${CANAME}ca.pvk     \
  -out    ${CANAME}/${CANAME}ca.req
if [[ ! -f $CANAME/${CANAME}ca.cer ]] ; then
cat /dev/urandom | tr -dc 'A-F0-9' | fold -w 16 | head -n 1 >root/serial
# Note: manually check that the serial is not already assigned to another certificate in root/index
# grep -F $(< root/serial) root/index
openssl ca                              \
  -config $CADIR/openssl_root_ca.cnf    \
  -in     ${CANAME}/${CANAME}ca.req     \
  -out    ${CANAME}/${CANAME}ca.cer     \
  -policy root_ca_dn_policy             \
  -extensions ${CAEXTENSIONS}
fi
[[ -f $CANAME/${CANAME}ca_der.cer ]] ||
openssl x509                            \
  -in     ${CANAME}/${CANAME}ca.cer     \
  -out    ${CANAME}/${CANAME}ca_der.cer \
  -outform DER

# 3. Generate the certificates you need by running the following commands:
[[ -f $REQPATH.req ]] ||
openssl req -nodes                      \
  -config   ${CAFILE}                   \
  -new                                  \
  -newkey   rsa:$BITS                   \
  -$SHA                                 \
  -keyout   ${PVKPATH}.pvk              \
  -out      ${REQPATH}.req
if [[ ! -f $CERPATH.cer ]] ; then
cat /dev/urandom | tr -dc 'A-F0-9' | fold -w 16 | head -n 1 >${CANAME}/serial
# Note: manually check that the serial is not already assigned to another certificate in CANAME/index
# grep -F $(< ${CANAME}/serial) ${CANAME}/index
openssl ca                              \
  -config   ${CAFILE}                   \
  -name     ${CANAME}_ca                \
  -in       ${REQPATH}.req              \
  -out      ${CERPATH}.cer              \
  -subj     "${SUBJECTDN}"
fi
# Optionally export the newly generated certificate to a PKCS12 file:
[[ -f $PKCS12PATH.p12 ]] ||
openssl pkcs12                          \
  -export                               \
  -out      ${PKCS12PATH}.p12           \
  -in       ${CERPATH}.cer              \
  -inkey    ${PVKPATH}.pvk              \
  -name     "${FRIENDLYNAME}"           \
  -certfile ${CANAME}/${CANAME}ca.cer   \
  -caname   "${FRIENDLYCANAME}"

