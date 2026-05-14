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

  # add permanent ssh-keygen
  inst /usr/bin/ssh-keygen
  inst /usr/libexec/openssh/sshd-keygen
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

  # Add mount hook and install bambini-python.squashfs
  mkdir -p "${initdir}/local/conda/images"
  mkdir -p "${initdir}/local/conda/envs/bambini-python"
  inst "${moddir}/bambini-python.squashfs" "/local/conda/images/bambini-python.squashfs"
  inst_hook pre-mount 01 "$moddir/mount-conda-squashfs.sh"


  # check if internal-sftp is enabled otherwise enable it here
  if ! grep -q internal-sftp "${initdir}"/etc/ssh/sshd_config; then
    mv "${initdir}/etc/ssh/sshd_config" "${initdir}/etc/ssh/sshd_config.bak"
    awk '!found && /^AcceptEnv/ { print "Subsystem sftp                  internal-sftp"; found=1 } 1' "${initdir}/etc/ssh/sshd_config.bak" >"${initdir}/etc/ssh/sshd_config"
  fi

  PTMP="$(mktemp -d)"
  tar -xf "${moddir}/bambini-python.tar.gz" -C "$PTMP" "bin/python3*"
  PYTHON=$(find ${PTMP} -type f -exec file {} \;|tr -d ":"|awk '{if ($2=="ELF") print $1}')
  inst "${PYTHON}" "/bin/python"
  rm -Rf "${PTMP}"

  inst_hook cmdline 40 "${moddir}/create-lvm-links.sh"
}
