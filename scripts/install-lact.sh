#!/bin/bash
#
if [[ $EUID -eq 0 ]]
then
  SUDO=
else
  SUDO=sudo
fi

info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }

# Use a Github API token if one is set
[ "${GITHUB_TOKEN}" ] || {
  [ "${GH_API_TOKEN}" ] && export GITHUB_TOKEN="${GH_API_TOKEN}"
  [ "${GITHUB_TOKEN}" ] || {
    [ "${GH_TOKEN}" ] && export GITHUB_TOKEN="${GH_TOKEN}"
  }
}
if [ "${GITHUB_TOKEN}" ]; then
  AUTH_HEADER="-H \"Authorization: Bearer ${GITHUB_TOKEN}\""
else
  AUTH_HEADER=
fi

echo " ----------------- "
echo "| Installing LACT |"
echo " ----------------- "
DL_URL=
OWNER="ilya-zlobintsev"
PROJECT="LACT"
API_URL="https://api.github.com/repos/${OWNER}/${PROJECT}/releases/latest"
have_curl=$(type -p curl)
have_jq=$(type -p jq)
have_wget=$(type -p wget)
[ "${have_curl}" ] && [ "${have_jq}" ] && {
  DL_URL=$(curl --silent --location-trusted -L ${AUTH_HEADER} "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "amd64\.ubuntu-2604\.deb$" | grep -v headless)
}
[ "${DL_URL}" ] && {
  [ "${have_wget}" ] && {
    ${SUDO} apt install -q -y libgtk-4-dev
    info "Downloading LACT release asset"
    TEMP_ASS="$(mktemp --suffix=.deb)"
    wget --quiet -O "${TEMP_ASS}" "${DL_URL}" > /dev/null 2>&1
    chmod 644 "${TEMP_ASS}"
    ${SUDO} apt install -q -y "${TEMP_ASS}"
    rm -f "${TEMP_ASS}"
  }
}
