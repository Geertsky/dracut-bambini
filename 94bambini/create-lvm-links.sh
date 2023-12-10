#!/usr/bin/sh
LVMLINKS="lvchange lvconvert lvcreate lvdisplay lvextend lvmconfig lvmdevices lvmdiskscan lvmsadc lvmsar lvreduce lvremove lvrename lvresize lvs lvscan pvchange pvck pvcreate pvdisplay pvmove pvremove pvresize pvs pvscan vgcfgbackup vgcfgrestore vgchange vgck vgconvert vgcreate vgdisplay vgexport vgextend vgimport vgimportclone vgimportdevices vgmerge vgmknodes vgreduce vgremove vgrename vgs vgscan vgsplit"
cd /usr/sbin
for L in $LVMLINKS; do
  ln -s lvm "$L"
done
