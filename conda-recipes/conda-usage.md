# The bambini-python conda environment
The idea is to make the python environment compatible to the python environment used in the RHEL installer named Anaconda[^Anaconda]. The RHEL installer Anaconda uses the `blivet` python module for the partitioning. The ansible `linux_system_roles` collection `storage` role also makes use of the python `blivet` module. But unfortunatly this role does not support creation of boot partitions. For this reason the conda environment is supplied with the parted binary, and a seperate `bambini` collection plugin has been written.


The below steps describe the steps to build a conda environment packed in a squashfs to be included in the initramfs using the `dracut-bambini` dracut module. This conda python environment can be used with the `ansible parted module`.


## Conda prerequisites
For building the bambini-python environment the `geertsky` anaconda channel needs to be added

```bash
conda config --add channels geertsky
```

To see the configured channels we can issue a `conda config --show-sources` which should return:

```
channel_priority: strict
channels:
  - geertsky
  - conda-forge
report_errors: False
```

To test if the channel works we can issue a `conda search parted` which should return:

```
Loading channels: done
# Name                       Version           Build  Channel
parted                           3.6      h9bf148f_0  geertsky
```

## Building the bambini-parted environment

The recipes for the conda modules are stored in the directory `conda-recipes` of the `dracut-bambini` project. We can build these conda modules separately using `conda build <recipename>`. This however is only needed for customizing the conda modules. Both the `bambini-parted` conda python environment as well as the conda modules have been uploaded to the `geertsky` anaconda channel.

Because of that, to build the conda bambini-parted python environment we can issue a:

```
conda env create -n bambini-python -f bambini-parted-environment.yml 
```

## Packing the environment for dracut-bambini
*For packing the conda environment, the conda-pack package needs to be installed in the conda base environment*

Once we have build the conda environment, we can pack it by issuing the following command in the dracut modules directory of `bambini`

```
cd /lib/dracut/modules.d/*bambini/
conda-pack -n bambini-python --format squashfs
```
