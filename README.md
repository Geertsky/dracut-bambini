Dracut module for use with Ansible
==================================

This module is used for the ansible-OSinstall_initramfs ansible role and contains currently only a list of binaries to include in the initramfs.

Building the initramfs
----------------------

The functioning initramfs was built using:

```
F=$(cat binaries)
PYTHON_INCLUDES=$(python -c 'import sys; print("\n-i ".join("{} {}".format(k,k) for k in sys.path if k not in ["/home/geert/.local/lib/python3.11/site-packages"]))')
sudo dracut -NM -I "$F" $PYTHON_INCLUDES -i /home/geert/git/geertsky/dracut-bambini/etc/ssh/sshd_config /etc/ssh/sshd_config -a "sshd network lvm systemd-resolved" /home/geert/work/ansible-initrd/initramfs-try-$(uname -r).img $(uname -r) --force
```
//NOTE: The `PYTHON_INCLUDES` should be viewed initially and the `not in ["/home/geert/.local/lib/python3.11/site-packages"]` modified accordingly //

