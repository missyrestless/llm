#!/bin/bash
#
if [[ $EUID -eq 0 ]]
then
  SUDO=
else
  SUDO=sudo
fi

SCRIPT_PATH="$(
  cd "$(dirname "$0")"
  pwd -P
)"
have_real=$(type -p realpath)
[ "${have_real}" ] && SCRIPT_PATH="$(realpath $SCRIPT_PATH)"
cd "${SCRIPT_PATH}"

export PATH="${HOME}/.local/bin:${PATH}"

# Install nvm node version manager, node, and npm
nvm_default_install_dir() {
  [ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm"
}

nvm_install_dir() {
  if [ -n "$NVM_DIR" ]; then
    printf %s "${NVM_DIR}"
  else
    nvm_default_install_dir
  fi
}

dir_nvm=$(nvm_install_dir)
if [ -d "${dir_nvm}/.git" ]; then
  export NVM_DIR="${dir_nvm}"
else
  if [ -d "${HOME}/.config/nvm/.git" ]; then
    if [ -d "${HOME}/.nvm/.git" ]; then
      export NVM_DIR="${HOME}/.nvm"
    else
      export NVM_DIR="${HOME}/.config/nvm"
    fi
  else
    export NVM_DIR="${HOME}/.nvm"
  fi
fi
HERE=$(pwd)
if [ -d "${NVM_DIR}" ]; then
  printf "\n\tVerifying latest version of nvm ..."
  cd "$NVM_DIR"
  git fetch --tags origin > /dev/null 2>&1
  git checkout \
    `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` \
      > /dev/null 2>&1
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  cd "${HERE}"
  printf " done"
else
  printf "\n\tInstalling nvm node version manager ..."
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" > /dev/null 2>&1
  cd "$NVM_DIR"
  git checkout \
    `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` \
    > /dev/null 2>&1
  if [ -x install.sh ]; then
    ./install.sh > /dev/null 2>&1
  else
    [ -f install.sh ] && {
      chmod 755 install.sh
      ./install.sh > /dev/null 2>&1
    }
  fi
  cd "${HERE}"
  printf " done"
fi
printf "\n\tVerifying latest version of node with nvm ..."
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install node --reinstall-packages-from=node > /dev/null 2>&1
nvm install node > /dev/null 2>&1
printf " done"

printf "\n\tVerifying latest version of npm with nvm ..."
nvm install-latest-npm > /dev/null 2>&1
printf " done\n"
