#!/bin/bash

# 2023, Geert Geurts <geert@verweggistan.eu>
# SPDX-License-Identifier: BSD

# called by dracut
check() {
  require_binaries dirname ssh-keygen /usr/libexec/openssh/sshd-keygen|| return 1

  [[ -r "${moddir}/bambini-python.squashfs" ]] || {
        derror "Missing ${moddir}/bambini-python.squashfs. See dracut-bambini/conda-recipes/bambini-python.yml"
        return 1
  }
  # 0 enables by default, 255 only on request
  return 255
}

# called by dracut
depends() {
  echo "sshd"
}

# called by dracut
install() {
  # dirname is needed for conda/bin/activate... Not required but useful for debugging
  inst /usr/bin/dirname
  inst chmod

  #check if internal-sftp is enabled otherwise enable it here
  if ! grep -q internal-sftp "${initdir}"/etc/ssh/sshd_config; then
    mv "${initdir}/etc/ssh/sshd_config" "${initdir}/etc/ssh/sshd_config.bak"
    awk '!found && /^AcceptEnv/ { print "Subsystem sftp                  internal-sftp"; found=1 } 1' "${initdir}/etc/ssh/sshd_config.bak" >"${initdir}/etc/ssh/sshd_config"
  fi

  # Install lvm links creation script
#  inst_hook cmdline 40 "${moddir}/create-lvm-links.sh"
}
