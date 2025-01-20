#!/bin/bash

#${1} CROSS_COMPILE
#${2} rootfs directory

rootfs_paths=${2}

script_dir=$(dirname "${0}")
. ${script_dir}/utils.sh

#get sysroot directory
sysroot_paths=$(get_base_root_dir "${1}")
sysroot_paths=${sysroot_paths}"x86_64-buildroot-linux-gnu/sysroot"

#copy sysroot files
echo "copy sysroot files to ${rootfs_paths}"
cp -rf ${sysroot_paths}/* ${rootfs_paths}

#delete unnecessary directories
rm -rf ${rootfs_paths}/usr/include
rm -rf ${rootfs_paths}/usr/share
mkdir -p ${rootfs_paths}/usr/share

#delete unnecessary files in /usr/lib
delete_file_by_exclude "${rootfs_paths}/usr/lib" "libresolv.so" "libstdc++.so*" "libz.so*" "libcrypt.so"
rm ${rootfs_paths}/usr/lib/libstdc++.so.6.0.30-gdb.py

#delete unnecessary files in /lib
rm ${rootfs_paths}/lib/libatomic.a 
rm ${rootfs_paths}/lib/libatomic.la
rm ${rootfs_paths}/lib/libc_malloc_debug.so.0
rm ${rootfs_paths}/lib/libmemusage.so
rm ${rootfs_paths}/lib/libnss_*
rm ${rootfs_paths}/lib/libpcprofile.so
rm ${rootfs_paths}/lib/libthread_db.so.1

