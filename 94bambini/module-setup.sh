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
  if ! grep -q internal-sftp ${initdir}/etc/ssh/sshd_config; then
    mv "${initdir}/etc/ssh/sshd_config" "${initdir}/etc/ssh/sshd_config.bak"
    awk '!found && /^AcceptEnv/ { print "Subsystem sftp                  internal-sftp"; found=1 } 1' "${initdir}/etc/ssh/sshd_config.bak" >"${initdir}/etc/ssh/sshd_config"
  fi
  #copy directories recursivly taken from /usr/bin/dracut
  include_src=($(python print-python-includes.py))
  #include_src=("/tmp/dracut-bambini/versions/3.11.6" "/tmp/dnf")
  for ((i = 0; i < ${#include_src[@]}; i++)); do
    src="${include_src[$i]}"
    # for pyenv python: target="${src:${#src}}/"
    target="$src"
    if [[ "${src}" && "${target}" ]]; then
      if [[ -f "${src}" ]]; then
        inst "${src}" "${target}"
      elif [[ -d "${src}" ]]; then
        ddebug "Including directory: ${src}"
        destdir="${initdir}/${target}"
        mkdir -p "${destdir}"
        # check for preexisting symlinks, so we can cope with the
        # symlinks to $prefix
        # Objectname is a file or a directory
        reset_dotglob="$(shopt -p dotglob)"
        shopt -q -s dotglob
        for objectname in "${src}"/*; do
          [[ -e "${objectname}" || -L "${objectname}" ]] || continue
          if [[ -d "${objectname}" ]] && [[ ! -L "${objectname}" ]]; then
            # objectname is a directory, let's compute the final directory name
            object_destdir="${destdir}/${objectname#$src/}"
            if ! [[ -e "${object_destdir}" ]]; then
              # shellcheck disable=SC2174
              mkdir -m 0755 -p "${object_destdir}"
              chmod --reference="${objectname}" "${object_destdir}"
            fi
            $DRACUT_CP -t "${object_destdir}" "${dracutsysrootdir}${objectname}"/.
          else
            $DRACUT_CP -t "${destdir}" "${dracutsysrootdir}${objectname}"
          fi
        done
        eval "${reset_dotglob}"
      elif [[ -e "${src}" ]]; then
        derror "${src} is neither a directory nor a regular file"
      else
        derror "${src} doesn't exist"
      fi
    fi
  done

  inst_hook cmdline 40 "${moddir}/create-lvm-links.sh"
  inst_hook pre-mount 50 "${moddir}/wait-for-ansible-finished.sh"
}
