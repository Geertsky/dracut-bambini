#!/bin/bash
conda build purge
set -euo pipefail

recipes=(
  libiconv
  coreutils
  util-linux
  e2fsprogs
  dosfstools
  lvm2
  parted
  pyparted
)

for recipe in "${recipes[@]}"; do
  echo
  echo "============================================================"
  echo "Building: ${recipe}"
  echo "============================================================"

  conda build "${recipe}/" \
    -c conda-forge \
    --override-channels \
    --use-local
done
