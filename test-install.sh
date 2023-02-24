#!/bin/sh

# TODO: should I create a totally new install path, so I can wipe it
# away???
brew uninstall gap-system/gap/gap
export HOMEBREW_NO_INSTALL_FROM_API=1
brew install --debug --force --verbose \
     --formula gap-system/gap/gap "$@" || exit 1
# --keep-tmp
# --dry-run
# --interactive
# --HEAD
# --build-from-source

./test-packages.sh
