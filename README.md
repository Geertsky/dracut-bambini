# Dracut module for bare-metal-install using Ansible

This [dracut](https://dracut.wiki.kernel.org/index.php/Main_Page) module is created for the ansible bare-metal-install role [ansible-bambini](https://github.com/Geertsky/ansible-bambini).
It does the following:
* include `python` in the initial ramdisk. By packaging a conda environment. 
* pause the boot process just before the root filesystem gets mounted(`pre-mount` hook) 
* depends on the [dracut-sshd](https://github.com/gsauthof/dracut-sshd) module.

This combination makes it possible to partition a disk and install an OS on the root filesystem just before it gets mounted.

## Installing the dracut-bambini module

Clone this repository and copy or link the `94bambini` directory to the `/usr/lib/dracut/modules.d/` directory.

## Building the initramfs
### Prerequisites
#### conda python
___(Work In Progress)___

The python inside the initial ramdisk is a [conda](https://docs.conda.io/en/latest/) environment. 
The requirements for this conda environment:
* named: `bambini-python`
* packed and stored in `/usr/lib/dracut/modules.d/bambini-python.tar
* conda modules to include:
  * blivet
  * cryptsetup
  * parted
  * libblockdev
  * libbytesize
  * libkmod
  * libnvme
  * libndctl
The conda recipies are stored at [conda-recipes/](https://github.com/Geertsky/dracut-bambini/conda-recipes/) and hosted at [anaconda.org/geertsky](https://anaconda.org/geertsky/repo)


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
|`enforcing=0`    |`selinux` should be disabled for the boot to finish. When this is not acceptable, see [ansible-dracut issue:#15](https://github.com/Geertsky/ansible-bambini/issues/15)         |

