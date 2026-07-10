#!/bin/bash
./configure --prefix="$PREFIX" --with-confdir="$PREFIX"/etc/
make
make install
cat <<EOT >$PREFIX/etc/lvm/lvm.conf
# bambini installer LVM configuration
#
# This file is intended to be used by setting:
#
#   export LVM_SYSTEM_DIR=/local/conda/envs/bambini-python/etc/lvm

config {
    checks = 1
    abort_on_errors = 0
}

devices {
    # Keep default device discovery.
    #
    # If needed, restrict this later to installer target disks only, for example:
    #
    # filter = [ "a|^/dev/vda$|", "a|^/dev/vda[0-9]+$|", "r|.*|" ]
    #
    # For now, do not restrict, because the installer role may need to discover
    # existing VGs before wiping/repartitioning.
}

global {
    # Use normal local file locking, not read-only/sysinit locking.
    #
    # This avoids:
    #   locking_type (4) is deprecated, using --sysinit --readonly
    #   Operation prohibited while --readonly is set.
    locking_type = 1

    # Do not use lvmlockd / clustered locking in the installer environment.
    use_lvmlockd = 0

    # Avoid relying on a host-specific system ID setup.
    system_id_source = "none"
}

activation {
    # Installer/initramfs environments often do not have a fully running udev
    # setup. Disable udev synchronization/rules for predictable behavior.
    udev_sync = 0
    udev_rules = 0

    # Do not auto-activate volumes unless explicitly requested.
    auto_activation_volume_list = []
}

backup {
    # Inside an ephemeral installer this is usually noise.
    backup = 0
    archive = 0
}
EOT

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
