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

  # glibc installation
  #   glibc core
  inst_libdir_file \
    'ld-linux*.so.*' \
    'ld-*.so.*' \
    'libc.so.*' \
    'libm.so.*' \
    'libresolv.so.*'
  # glibc compatible
  inst_libdir_file \
    'libdl.so.*' \
    'libpthread.so.*' \
    'librt.so.*' \
    'libutil.so.*' \
    'libanl.so.*' \
    'libBrokenLocale.so.*' \
    'libthread_db.so.*'
  # glibc runtime
  inst_libdir_file \
    'libnss_*.so.*' \
    'gconv/*.so' \
    'gconv/gconv-modules' \
    'gconv/gconv-modules.cache'

  # add root entry to shadow when not there (f44)
  if ! grep -qs '^root:' "$initdir/etc/shadow"; then
    dinfo "Add shadow entry for root"
    echo "root:*:::::::" >> "$initdir/etc/shadow"
  fi
  # Add mount hook and install bambini-python.squashfs
  mkdir -p "${initdir}/local/conda/images"
  mkdir -p "${initdir}/local/conda/envs/bambini-python"
  inst /etc/nsswitch.conf

  inst "${moddir}/bambini-python.squashfs" "/local/conda/images/bambini-python.squashfs"
  inst_hook pre-mount 01 "$moddir/mount-conda-squashfs.sh"

  # wait_for_ansible as last pre-mount task
  inst_hook pre-mount 99 "$moddir/wait_for_ansible_finished.sh"

  # check if internal-sftp is enabled otherwise enable it here
  if ! grep -q internal-sftp "${initdir}"/etc/ssh/sshd_config; then
    mv "${initdir}/etc/ssh/sshd_config" "${initdir}/etc/ssh/sshd_config.bak"
    awk '!found && /^AcceptEnv/ { print "Subsystem sftp                  internal-sftp"; found=1 } 1' "${initdir}/etc/ssh/sshd_config.bak" >"${initdir}/etc/ssh/sshd_config"
  fi

  # Install lvm links creation script
#  inst_hook cmdline 40 "${moddir}/create-lvm-links.sh"
}
