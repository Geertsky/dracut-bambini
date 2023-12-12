Dracut module for Bare Metal Install using Ansible
==================================

This dracut module is used for the ansible Bare Metal Install role [ansible-bambini](https://github.com/Geertsky/ansible-bambini).

Installing the dracut-bambini module
------------------------------------

Copy or link the `94bambini` directory to `/usr/lib/dracut/modules.d/` directory

Building the initramfs
----------------------

The initramfs image can be built using the following command:

```
sudo dracut -NM -a "bambini network lvm systemd-resolved" ansible-bambini-initramfs-$(uname -r).img $(uname -r) 
```
_NOTE: When your python `sys.path` contains additional includes out of the scope of the default sys.path you'll have to exclude them by adding a regex to the excludes list in `/usr/lib/dracut/94bambini/print-python-includes.py`_

Booting the ansible-bambini-initramfs
-------------------------------------
The initramfs file together with it's kernel need to be fed to the server by any way possible. For instance: PXE, qemu/kvm Direct kernel boot, customized grub.
