# The bambini-python conda environment
The idea is to make the python environment compatible to the python environment used in the RHEL installer named Ananconda[^Anaconda]. The RHEL installer Ananconda uses the `blivet` python module for the partitioning. The ansible `linux_system_roles` collection `storage` role also makes use of the python `blivet` module. Unfortunatly this role does not support creation of boot partitions. For this a seperate `bambini` collection plugin needs to be written.
For this reason the conda python environment build using the steps below has been named `bambini-parted` instead of `bambini-python` to denote the capabilities of that conda environment.


The below steps describe the steps to build a conda environment to be included in the initramfs using the `dracut-bambini` module. This conda python environment can be used with the `ansible parted module`.


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

The recipes for the conda modules are stored in the directory `conda-recipes` of the `dracut-bambini` project. We can build these conda modules seperatly using `conda build <recipename>`. This however is only needed for customizing the conda modules. Both the `bambini-parted` conda python environment as well as the conda modules have been uploaded to the `geertsky` anaconda channel.

Because of that, to build the conda bambini-parted python environment we can issue a:

```
conda env create geertsky/bambini-parted
```

## Packing the environment for dracut-bambini

Once we have build the conda environment, we can pack it by issueing the following command in the dracut modules directory of `bambini`

```
cd /lib/dracut/modules.d/*bambini/
conda pack bambini-parted
ln -s bambini-parted.tar.gz bambini-python.tar.gz
```
[^Anaconda]: The name of the RHEL installer `Ananconda`, and the python package management service `Anaconda` are two distinct things that share the same name. In the bambini project both are used, something to keep in mind.
