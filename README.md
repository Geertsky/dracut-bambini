# Dracut module for bare-metal-install using Ansible

This [dracut](https://dracut.wiki.kernel.org/index.php/Main_Page) module is created for the ansible bare-metal-install role [ansible-bambini](https://github.com/Geertsky/ansible-bambini).
It does the following:
* include `python` in the initial ramdisk. A conda environment capable of partitioning a disk has been created. See issue: [#6](https://github.com/Geertsky/dracut-bambini/issues/6) for further information.
* pause the boot process just before the root filesystem gets mounted(`pre-mount` hook) 
* depends on the [dracut-sshd](https://github.com/gsauthof/dracut-sshd) module.

This combination makes it possible to partition a disk and install a minimal OS on the root filesystem just before it gets mounted.

## Installing the dracut-bambini module

Clone this repository and copy or link the `94bambini` directory to the `/usr/lib/dracut/modules.d/` directory.

## Building the initramfs
### Prerequisites

* a packed conda environment in `/usr/lib/dracut/modules.d/bambini-python.tar.gz`

_The steps for building and packing the conda python environment are described at [documentation/CONDA.md](documentation/CONDA.md)_

### initramfs build command

The initramfs image can be built using the following command:

```
sudo dracut -NM -a "bambini network lvm systemd-resolved" ansible-bambini-initramfs-$(uname -r).img $(uname -r) 
```

## Booting the ansible-bambini-initramfs
The initramfs file together with it's kernel need to be fed to the server by any way possible. For instance: PXE, qemu/kvm Direct kernel boot, customized grub.

### Required boot arguments

| kernel argument | description                                                                                                                                                                    |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`rd.neednet=1`   |The initial ramdisk execution requires network accessibility                                                                                                                    |
|`root=LABEL=root`|The dracut-bambini module labels the root filesystem partition with `root`. This is required for the boot process to continue. It can be modified after booting is finished.    |
|`enforcing=0`    |`selinux` should be disabled for the boot to finish. When this is not acceptable, see [bambini issue:#15](https://github.com/Geertsky/bambini/issues/15)         |

