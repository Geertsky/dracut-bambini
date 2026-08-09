#!/bin/bash

# 2023, Geert Geurts <geert@verweggistan.eu>
# SPDX-License-Identifier: BSD

# called by dracut
check() {
  cd "${moddir}"
  #using a text files to keep things dynamic for now...
  require_binaries $(cat binaries) || return 1
  # 0 enables by default, 255 only on request
  return 255
}

# called by dracut
depends() {
  echo "sshd"
}

# called by dracut
install() {
  #Install binaries and additional includes
  cd "${moddir}"
  #using a text files to keep things dynamic for now...
  inst_multiple $(cat binaries)
  inst_multiple /usr/lib/rpm/rpmrc /usr/lib/rpm/macros /usr/lib/rpm/redhat/rpmrc

  #check if internal-sftp is enabled otherwise enable it here
  if ! grep -q internal-sftp "${initdir}"/etc/ssh/sshd_config; then
    mv "${initdir}/etc/ssh/sshd_config" "${initdir}/etc/ssh/sshd_config.bak"
    awk '!found && /^AcceptEnv/ { print "Subsystem sftp                  internal-sftp"; found=1 } 1' "${initdir}/etc/ssh/sshd_config.bak" >"${initdir}/etc/ssh/sshd_config"
  fi

  #install packed conda environment and python binary for glibc dep. resolution.
  inst "${moddir}/bambini-python.tar.gz" "/tmp/bambini-python.tar.gz"
  dd if="/dev/urandom" of="${initdir}/placeholder.img" bs=1M count=500 >/dev/null 2>&1
  PTMP="$(mktemp -d)"
  tar -xf "${moddir}/bambini-python.tar.gz" -C "$PTMP" "bin/python3*"
  PYTHON=$(find ${PTMP} -type f -exec file {} \;|tr -d ":"|awk '{if ($2=="ELF") print $1}')
  inst "${PYTHON}" "/bin/python"
  rm -Rf "${PTMP}"

  inst_hook cmdline 40 "${moddir}/create-lvm-links.sh"
}
