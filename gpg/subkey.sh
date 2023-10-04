#! /usr/bin/env bash
set -exu

# expected output:
#
# sudo -u momobiblebender -i gpg --export-secret-subkeys ${SUBKEY}\! > tmp-1.key
# sudo -u cis             -i gpg --export-secret-subkeys ${SUBKEY}\! > tmp-2.key
# ls -l tmp-1.key tmp-2.key
#
# -rw-r--r-- 1 momobiblebender momobiblebender  3528 May 21 14:52 tmp-2.key
# -rw-r--r-- 1 momobiblebender momobiblebender 45836 May 21 14:52 tmp-1.key
#
#
# gpg --list-secret-keys 
#
#/home/momobiblebender/.gnupg/pubring.kbx
#----------------------------------------
#sec   rsa4096 2020-05-17 [C]
#      38BBDB7C15E81F38AAF6B7E614F31DFAC260053E
#uid           [ultimate] Innovations Anonymous (Free Code for a Free World!) <InnovAnon-Inc@tutanota.com>
#uid           [ultimate] Innovations Anonymous (Free Code for a Free World!) <InnovAnon-Inc@protonmail.com>
#uid           [ultimate] [jpeg image of size 41687]
#uid           [ultimate] Innovations Anonymous (Free Code for a Free World!) <InnovAnon-Inc@gmx.com>
#ssb   rsa4096 2020-05-17 [S]
#ssb   rsa4096 2020-05-17 [E]
#ssb   rsa4096 2020-05-17 [A]
#ssb   brainpoolP512r1 2020-05-21 [S]
#

if (( $# == 2 )) ; then
  KEY="$1"
  SUBKEY="$2"
else
  if [[ -z "${KEY+x}" ]] ; then
    KEY=38BBDB7C15E81F38AAF6B7E614F31DFAC260053E
    #echo specify master key in env
    #exit 1
  fi
  if [[ -z "${SUBKEY+x}" ]] ; then
    SUBKEY=53F31F9711F06089
    #echo specify sub    key in env
    #exit 1
  fi
fi

U="`whoami`"

sudo -u cis -i rm -rf .gnupg
sudo -u "$U" -i gpg --export-secret-subkeys ${SUBKEY}\! | \
sudo -u cis -i gpg --import

trap 'rm -f pub.key priv.key' 0
sudo -u cis -i gpg --edit-key $KEY
sudo -u cis -i gpg --export             $KEY > pub.key
sudo -u cis -i gpg --export-secret-keys $KEY > priv.key
#sudo -u cis -i gpg --delete-secret-key $KEY
sudo -u cis -i gpg --delete-key        $KEY
sudo -u cis -i rm -rf .gnupg
sudo -u cis -i gpg --import < priv.key
sudo -u cis -i gpg --import < pub.key

#rm -f pub.key
#sudo -u cis -i gpg --armor --export-secret-subkeys ${SUBKEY}\! > priv.key
#
#echo verifying functionality
#sudo -u cis -i gpg --sign   key.sh
#sudo -u cis -i gpg --verify key.sh.gpg

sudo -u cis -i gpg --armor --export-secret-subkeys ${SUBKEY}\! |
cat -e |
sed 's/\$/\\n/g' |
xclip -selection c
echo secret subkey copied to clipboard: paste it into circleci env vars as GPG_KEY

#sudo -u cis -i gpg --armor --export-secret-subkeys ${SUBKEY}\! |
#cat -e |
#tr \$ '\\\n' |
#xclip -selection c
#echo secret subkey copied to clipboard: paste it into circleci env vars as GPG_KEY

