# CA
C(ertificate) A(uthority)
==========
Better than VeriSign!

----------
Don't forget to edit /etc/ssl/openssl.cnf...
BPs would probably be to use a different cnf for the CA

./ca.sh <name your CA>

cd /root/<name of your CA>

<original dir>/openssl.sh <hostname key,csr,crt to sign> sign
