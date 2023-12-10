Dracut module for bare metal install using Ansible
==================================

This module is used for the ansible-OSinstall_initramfs ansible role and contains currently only a list of binaries to include in the initramfs.

Building the initramfs
----------------------

The functioning initramfs was built using:

```
BINARIES=$(cat binaries)
PYTHON_INCLUDES=$(python -c 'import sys; print("\n-i ".join("{} {}".format(k,k) for k in sys.path if k not in ["/home/geert/.local/lib/python3.11/site-packages"]))')
VARIOUS_INCLUDES=$(sed 's/\(.*\)/-i \1 \1/' includes)

sudo dracut -NM -I "$BINARIES" $PYTHON_INCLUDES $VARIOUS_INCLUDES -a "sshd network lvm systemd-resolved" /home/geert/work/ansible-initrd/initramfs-try-$(uname -r).img $(uname -r) --force
```
_NOTE: The `PYTHON_INCLUDES` command should be viewed initially without the `not in ["/home/geert/.local/lib/python3.11/site-packages"]` part and it should be modified accordingly_

