#!/bin/sh

. /lib/dracut-lib.sh

_img="/local/conda/images/bambini-python.squashfs"
_mountpoint="/local/conda/envs/bambini-python"

[ -r "$_img" ] || die "Missing Conda squashfs image: $_img"

umount "$_mountpoint" \
    || die "Could not unmount $_img on $_mountpoint"

modprobe -r loop 2>/dev/null || :
modprobe -r squashfs 2>/dev/null || :
info "Unmounted $_img on $_mountpoint"
