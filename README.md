Dracut module for use with Ansible
==================================

This module is used for the ansible-OSinstall_initramfs ansible role and contains currently only a list of binaries to include in the initramfs.

Building the initramfs
----------------------

The functioning initramfs was built using:

```
F=$(cat binaries)
sudo dracut -NM -I "$T" -i /usr/lib/python3.11/ /usr/lib/python3.11/ -a "sshd network lvm systemd-resolved" /home/geert/work/ansible-initrd/initramfs-try-$(uname -r).img $(uname -r)
```
