#!/bin/bash

VER="1.26.4"
DLF="go${VER}.linux-amd64.tar.gz"
ARC="${HOME}/Downloads/${DLF}"

[ -f "${ARC}" ] || {
  ARC="${HOME}/transfers/${DLF}"
  [ -f "${ARC}" ] || {
    echo "Downloading GO version ${VER} distribution archive"
    curl --silent --location --output /tmp/${DLF} https://go.dev/dl/${DLF}
    ARC="/tmp/${DLF}"
    [ -f "${ARC}" ] || {
      echo "ERROR: cannot locate GO version ${VER} download archive"
      exit 1
    }
  }
}

sudo rm -rf /usr/local/go
echo "Extracting GO distribution archive ${ARC}"
sudo tar -C /usr/local -xzf ${ARC}
rm -f ${ARC}

# go version go1.26.4 linux/amd64
go version
gover=$(go version | awk '{ print $3 }' | sed -e "s/go//")
if [ "${gover}" == "${VER}" ]; then
  echo "GO version OK"
else
  echo "GO version NOT OK"
fi
