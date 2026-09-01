# Dracut module for bare-metal-install using Ansible
This [dracut](https://dracut.wiki.kernel.org/index.php/Main_Page) module is created for the [ansible](https://docs.ansible.com/) bare-metal-install collection [tuxifier](https://github.com/Geertsky/tuxifier).

It features the following:
* It depends on the [dracut-sshd](https://github.com/gsauthof/dracut-sshd) module.
* It includes a `python` [conda](https://conda-forge.org/docs/) environment with [parted](https://www.gnu.org/software/parted/) and some other basic tools in the initial ramdisk. By packaging a conda environment. (See: [tuxifier-python](https://github.com/Geertsky/tuxifier-python))
* It pauses the boot process just before the root filesystem gets mounted _(dracut `pre-mount` hook)_

This combination makes it possible to use [ansible](https://docs.ansible.com/) to:
* partition (a) disk(s)
* install an OS
* poweroff the machine<br>
or<br>
* continue the boot to the freshly installed OS and continue your ansible playbook from there.

## Installing the dracut-tuxifier module

* Clone this repository and copy or link the `dracut-tuxifier/94tuxifier` directory to the `/usr/lib/dracut/modules.d/` directory.

* Download the pre-packaged [tuxifier-python.squashfs](https://verweggistan.eu/tuxifier-python.squashfs) <br>
and place it in `/usr/lib/dracut/modules.d/94tuxifier/`

**Or** <br>

* build and modify the `tuxifier-python.squashfs` as described here: [tuxifier-python](https://github.com/Geertsky/tuxifier-python) <br>
and place it in `/usr/lib/dracut/modules.d/94tuxifier/`
## Building the initramfs

The initramfs image can be built using the following command:

```
sudo dracut -NM -a "tuxifier network" ansible-tuxifier-initramfs-$(uname -r).img $(uname -r)
```

## Booting the ansible-tuxifier-initramfs
The initramfs file together with it's kernel need to be fed to the server by any way possible. For instance: PXE, virt-manager Direct kernel boot, customized grub.

### Required boot arguments

| kernel argument | description                                                                                                                                                                    |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`rd.neednet=1`   |The initial ramdisk execution requires network accessibility.                                                                                                                    |
|`root=LABEL=root`|The `root` argument should be set to the device that contains the root filesystem after the install is finished.                                        |
|`enforcing=0`    |`selinux` should be disabled during the install.                                                                                                                               |

