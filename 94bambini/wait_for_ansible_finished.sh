#!/usr/bin/sh
type info >/dev/null 2>&1 || . /lib/dracut-lib.sh
info "Waiting for Ansible to create me a roofs..."
while [ ! -f "/tmp/ansible-finished" ]; do
  sleep 5
done
