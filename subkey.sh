#! /bin/bash
set -exu

if [ $# -eq 2 ] ; then
  KEY="$1"
  SUBKEY="$2"
else
  if [ ! -z "${KEY+x}" ] ; then
    echo specify master key in env
    exit 1
  fi
  if [ ! -z "${SUBKEY+x}" ] ; then
    echo specify sub    key in env
    exit 1
  fi
fi
#KEY=38BBDB7C15E81F38AAF6B7E614F31DFAC260053E
#SUBKEY=53F31F9711F06089

sudo -u cis -i rm -rf .gnupg
sudo -u momobiblebender -i gpg --export-secret-subkeys ${SUBKEY}\! | \
sudo -u cis -i gpg --import

sudo -u cis -i gpg --edit-key $KEY
sudo -u cis -i gpg --export             $KEY > pub.key
sudo -u cis -i gpg --export-secret-keys $KEY > priv.key
#sudo -u cis -i gpg --delete-secret-key $KEY
sudo -u cis -i gpg --delete-key        $KEY
sudo -u cis -i rm -rf .gnupg
sudo -u cis -i gpg --import < priv.key
sudo -u cis -i gpg --import < pub.key

rm -f pub.key
sudo -u cis -i gpg --armor --export-secret-subkeys ${SUBKEY}\! > priv.key

echo verifying functionality
sudo -u cis -i gpg --sign   key.sh
sudo -u cis -i gpg --verify key.sh.gpg

