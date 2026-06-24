#!/bin/bash
#
VER="13.3.0"
REL="610.43.02"
URL="https://developer.download.nvidia.com/compute/cuda"

SCRIPT_PATH="$(
  cd "$(dirname "$0")"
  pwd -P
)"
have_real=$(type -p realpath)
[ "${have_real}" ] && SCRIPT_PATH="$(realpath $SCRIPT_PATH)"

TOP=$(dirname "${SCRIPT_PATH}")
[ -d "${TOP}"/tmp ] || mkdir "${TOP}"/tmp
cd "${TOP}"/tmp

wget -q ${URL}/${VER}/local_installers/cuda_${VER}_${REL}_linux.run
sudo sh cuda_${VER}_${REL}_linux.run

echo "/usr/local/cuda-13.3/lib64" > /tmp/cuda$$
if [ -f /etc/ld.so.conf.d/cuda-13-3.conf ]; then
  cat /etc/ld.so.conf.d/cuda-13-3.conf /tmp/cuda$$ > /tmp/cuda-13$$
else
  cp /tmp/cuda$$ /tmp/cuda-13$$
fi

sudo cp /tmp/cuda-13$$ /etc/ld.so.conf.d/cuda-13-3.conf
sudo ldconfig
rm -f /tmp/cuda$$ /tmp/cuda-13$$
