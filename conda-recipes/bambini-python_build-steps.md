# Steps to build bambini-python.tar.gz from scratch

```sh
install conda
conda install conda-build conda-pack
conda build e2fsprogs/ dosfstools/ libiconv/ libnvme/ lvm2/ pygobject/ sgml-common/ util-linux/ cruptsetup/ volume_key/ libxml2/ docbook-xml/ docbook-xsl-nons/ inih/ itstool/ gtk-doc/ zstd/ kmod/ parted/ pygobject/ pyparted/ libbytesize/ libblockdev/ blivet/
conda env create -f ./bambini-python_environment.yml -p ~/miniforge3/envs/bambini-python/
conda pack -n bambini-python -o /usr/lib/dracut/modules.d/94bambini/bambini-python.tar.gz
python -<<EOT
import blivet
b=blivet.Blivet()
b.reset()
print(b.devices)
EOT
```
