Dracut module for Bare Metal Install using Ansible
==================================

This dracut module is used for the ansible Bare Metal Install role [ansible-bambini](Bare Metal Install).

Installing the dracut-bambini module
------------------------------------

Copy or link the `94bambini` directory to `/usr/lib/dracut/modules.d/` directory

Building the initramfs
----------------------

The initramfs image can be built using the following command:

```
sudo dracut -NM $(python /usr/lib/dracut/modules.d/94bambini/print-python-includes.py) -a "bambini network lvm systemd-resolved" ansible-bambini-initramfs-$(uname -r).img $(uname -r) 
```
_NOTE: The output of the `print-python-includes.py` should be reviewed. Currently, only/all the paths starting with `/home` are excluded. This might be too restrictive or possibly not restrictive enough. The `exclude` array should be modified accordingly_

Booting the ansible-bambini-initramfs
-------------------------------------
The initramfs file together with it's kernel need to be fed to the server by any way possible. For instance: PXE, qemu/kvm Direct kernel boot, customized grub. 
