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
  #requested sftp inclusion https://github.com/gsauthof/dracut-sshd/pull/74
  mv "$initdir/etc/ssh/sshd_config" "$initdir/etc/ssh/sshd_config.bak"
  awk '!found && /^AcceptEnv/ { print "Subsystem sftp                  internal-sftp"; found=1 } 1' "$initdir/etc/ssh/sshd_config.bak" >"$initdir/etc/ssh/sshd_config"
  include_src=($(python print-python-includes.py))
  for ((i = 0; i < ${#include_src[@]}; i++)); do
    src="${include_src[$i]}"
    target="$src"
    if [[ $src && $target ]]; then
      if [[ -f $src ]]; then
        inst "$src" "$target"
      elif [[ -d $src ]]; then
        ddebug "Including directory: $src"
        destdir="${initdir}/${target}"
        mkdir -p "$destdir"
        # check for preexisting symlinks, so we can cope with the
        # symlinks to $prefix
        # Objectname is a file or a directory
        reset_dotglob="$(shopt -p dotglob)"
        shopt -q -s dotglob
        for objectname in "$src"/*; do
          [[ -e $objectname || -L $objectname ]] || continue
          if [[ -d $objectname ]] && [[ ! -L $objectname ]]; then
            # objectname is a directory, let's compute the final directory name
            object_destdir=${destdir}/${objectname#$src/}
            if ! [[ -e $object_destdir ]]; then
              # shellcheck disable=SC2174
              mkdir -m 0755 -p "$object_destdir"
              chmod --reference="$objectname" "$object_destdir"
            fi
            $DRACUT_CP -t "$object_destdir" "$dracutsysrootdir$objectname"/.
          else
            $DRACUT_CP -t "$destdir" "$dracutsysrootdir$objectname"
          fi
        done
        eval "$reset_dotglob"
      elif [[ -e $src ]]; then
        derror "$src is neither a directory nor a regular file"
      else
        derror "$src doesn't exist"
      fi
    fi
  done

  inst_hook cmdline 40 "$moddir/create-lvm-links.sh"
  inst_hook pre-mount 50 "$moddir/wait-for-ansible-finished.sh"
}
