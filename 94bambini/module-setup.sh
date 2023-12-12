#!/bin/bash

# 2023, Geert Geurts <geert@verweggistan.eu>
# SPDX-License-Identifier: BSD

# called by dracut
check() {
  cd "$moddir"
  #using a text files to keep things dynamic for now...
  require_binaries $(cat binaries) || return 1
  # 0 enables by default, 255 only on request
  return 255
}

# called by dracut
depends() {
  echo sshd
}

# called by dracut
install() {
  cd "$moddir"
  #using a text files to keep things dynamic for now...
  inst_multiple $(cat binaries)
  inst_multiple $(cat includes)
  mv "$initdir/etc/ssh/sshd_config" "$initdir/etc/ssh/sshd_config.bak"
  awk '!found && /^AcceptEnv/ { print "Subsystem sftp                  internal-sftp"; found=1 } 1' "$initdir/etc/ssh/sshd_config.bak" >"$initdir/etc/ssh/sshd_config"
  #  for P in $(python print-python-includes.py | sort -u); do
  #    if [ -n "$PREVIOUS" ] && [ -n "$(echo $P | grep $PREVIOUS)" ]; then
  #      continue
  #    else
  #      for D in $(find $P -maxdepth 3 -type d); do
  #        inst_multiple $(find $D -type f) >/dev/null
  #      done
  #    fi
  #    PREVIOUS=$P
  #  done

  inst_hook cmdline 40 "$moddir/create-lvm-links.sh"
  inst_hook pre-mount 50 "$moddir/wait-for-ansible-finished.sh"
}
