CAFILE=

openssl req -config CAFILE -new -newkey rsa:4096 -sha256 -keyout PVKPATH.pvk -out REQPATH.req
    cat /dev/urandom | tr -dc 'A-F0-9' | fold -w 16 | head -n 1 >CANAME/serial
    # Note: manually check that the serial is not already assigned to another certificate in CANAME/index
    openssl ca -config CAFILE -name CANAME_ca -in REQPATH.req -out CERPATH.cer -subj 'SUBJECTDN'
    # Optionally export the newly generated certificate to a PKCS12 file:
    openssl pkcs12 -export -out PKCS12PATH.p12 -in CERPATH.cer -inkey PVKPATH.pvk -name "FRIENDLYNAME" -certfile CANAME/CANAMEca.cer -caname "FRIENDLYCANAME"
openssl_webserver_cas.cnf
