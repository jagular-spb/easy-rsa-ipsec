#!/bin/env bash

if [[ -z "$@" ]]; then
echo -e "Copy p12, ovpn-temaple, sustitue key in ovpn file, archive it\nexample: @0 users.txt ~retro/ovpn"
exit
fi


res="${2}/res/"
inp="${2}/inp/"
curr="$(pwd)"

mkdir -p "${res}"
mkdir -p "${inp}"

while read p; do
 name="${p%%,*}"
  cp  "pki/private/${name}.p12" "${2}/inp/"
done < $1


cd "${inp}"

for f in *.p12; do
  nm=${f%%.*}
  echo "Processing ${nm}"
  mkdir -p "${nm}"
  mv "${f}" "${nm}"
  cp "${curr}/client_navigat.ovpn"  "${nm}/"
  sed -i.bak "s/pkcs12.*/pkcs12 \"${f}\"/" "${nm}/client_navigat.ovpn"
  rm -f "${nm}/client_navigat.ovpn.bak"
  chmod -x "${nm}/client_navigat.ovpn"

  cp "${curr}/client_install0.exe"  "${nm}/"

  /usr/local/bin/rar a -ep1 -ap"base\usr\config" "${nm}\client_install0.exe" "${nm}\client_*.ovpn"
  /usr/local/bin/rar a -ep1 -ap"base\usr\config" "${nm}\client_install0.exe" "${nm}\*.p12"

  mv "${nm}/client_install0.exe" "${res}/cli_${nm}_install.exe"
  rm -rf "${nm}"
 
done

#find . -type f -name "*bak" -delete

cd "${2}"
#tar -cjvf res.tar.bz2 res
