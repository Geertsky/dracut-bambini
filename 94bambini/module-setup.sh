#!/bin/bash

# 2023, Geert Geurts <geert@verweggistan.eu>
# SPDX-License-Identifier: BSD

# called by dracut
check() {
  cd "${moddir}"
  #using a text files to keep things dynamic for now...
  require_binaries $(cat binaries) || return 1
  #Build requirements pyenv
  #require_binaries dnf gmake make c89 c99 cc gcc gcc-ar gcc-nm gcc-ranlib gcov gcov-dump gcov-tool lto-dump x86_64-redhat-linux-gcc x86_64-redhat-linux-gcc-13 patch bunzip2 bzcat bzcmp bzdiff bzegrep bzfgrep bzgrep bzip2 bzip2recover bzless bzmore sqlite3 || return 1
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

  #add permanent ssh-keygen
  mkdir -p "${initdir}${systemdsystemconfdir}/sshd.service.d/"
  inst "${moddir}/wants.conf" "${systemdsystemconfdir}/sshd.service.d/wants.conf"
  inst "${moddir}/after.conf" "${systemdsystemconfdir}/sshd.service.d/after.conf"
  inst "${moddir}/sshd-keygen@.service" "${systemdsystemunitdir}/sshd-keygen@.service"
  inst "${moddir}/sshd-keygen.target" "${systemdsystemunitdir}/sshd-keygen.target"
  mkdir -p "${initdir}${systemdsystemconfdir}/sshd-keygen@.service.d/"
  inst "${moddir}/execstartpre.conf" "${systemdsystemconfdir}/sshd-keygen@.service.d/execstartpre.conf"
  inst "${moddir}/conditionfilenotempty.conf" "${systemdsystemconfdir}/sshd-keygen@.service.d/conditionfilenotempty.conf"
  for F in "${systemdsystemconfdir}/sshd.service.d/wants.conf" "${systemdsystemconfdir}/sshd.service.d/after.conf" "${systemdsystemunitdir}/sshd-keygen@.service" "${systemdsystemunitdir}/sshd-keygen.target" "${systemdsystemconfdir}/sshd-keygen@.service.d/execstartpre.conf" "${systemdsystemconfdir}/sshd-keygen@.service.d/conditionfilenotempty.conf"; do
    chown root:root "${initdir}/${F}"
  done
  for key in ecdsa ed25519 rsa; do
    $SYSTEMCTL -q --root "${initdir}" enable sshd-keygen@${key}.service
  done

  #check if internal-sftp is enabled otherwise enable it here
  if ! grep -q internal-sftp "${initdir}"/etc/ssh/sshd_config; then
    mv "${initdir}/etc/ssh/sshd_config" "${initdir}/etc/ssh/sshd_config.bak"
    awk '!found && /^AcceptEnv/ { print "Subsystem sftp                  internal-sftp"; found=1 } 1' "${initdir}/etc/ssh/sshd_config.bak" >"${initdir}/etc/ssh/sshd_config"
  fi

  #Build and install python
  #tar --keep-directory-symlink --skip-old-files -zxf "${moddir}"/python.tgz -C "${initdir}"
  tar --keep-directory-symlink --skip-old-files -xf "${moddir}"/python-blivet3.tar -C "${initdir}"

  #install libblockdev
  inst "$(ldconfig -p | awk '$1 ~ /^libblockdev/{print $NF}')"

  #install libbytesize
  inst "$(ldconfig -p | awk '$1 ~ /^libbytesize/{print $NF}')"

  inst_hook cmdline 40 "${moddir}/create-lvm-links.sh"
  inst_hook pre-mount 50 "${moddir}/wait-for-ansible-finished.sh"
}
