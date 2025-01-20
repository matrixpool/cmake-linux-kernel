#!/bin/bash

#${1} CROSS_COMPILE
#${2} rootfs directory
#${3} version

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

#define unnecessary files in /usr/lib
need_files=()

# CROSS_COMPILER=${1}gcc
# ROOTFS_PATHS=${2}
# PROJECT_PATH=${3}
# VERSION=${4}
# KERNEL=${6}
# PRODUCT=${7}
# KERNEL_VERSION=${8}
# DIST_PATH=${ROOTFS_PATHS}/../../dist

# mkdir -p ${DIST_PATH}

# #set release or debug version
# if [ "${5}" = "OFF" ]; then
#     RELEASE="debug"
# else
#     RELEASE="release"
# fi

# sysroot_paths=$(get_base_root_dir "${CROSS_COMPILER}")
# sysroot_paths=${sysroot_paths}"x86_64-buildroot-linux-gnu/sysroot"

# #copy sysroot files
# echo "copy sysroot files to ${ROOTFS_PATHS}"
# cp -rf ${sysroot_paths}/* ${ROOTFS_PATHS}

# #reinstall /etc/shadow and /etc/profile
# if [ "${RELEASE}" = "release" ]; then
#     cp ${PROJECT_PATH}/config/base/etc/profile.release  ${ROOTFS_PATHS}/etc/profile
#     cp ${PROJECT_PATH}/config/base/etc/shadow.release  ${ROOTFS_PATHS}/etc/shadow
# else
#     cp ${PROJECT_PATH}/config/base/etc/profile.debug  ${ROOTFS_PATHS}/etc/profile
#     cp ${PROJECT_PATH}/config/base/etc/shadow.debug  ${ROOTFS_PATHS}/etc/shadow
# fi

# if [ ! -z "${KERNEL}" -a -d "${KERNEL}" ]; then
#     echo "copy ${KERNEL}/arch/x86/boot/Image to dist directory"
#     mkdir -p ${DIST_PATH}/Image/ && cp ${KERNEL}/arch/x86/boot/bzImage ${DIST_PATH}/Image/
#     echo "copy kernel modules to dist directory"
#     mkdir -p ${ROOTFS_PATHS}/lib/modules/${KERNEL_VERSION}
#     find ${KERNEL} -name "*.ko" | xargs -I {} cp {} ${ROOTFS_PATHS}/lib/modules/${KERNEL_VERSION}/
# fi

# #delete unnecessary files
# rm -rf ${ROOTFS_PATHS}/usr/include
# find ${ROOTFS_PATHS} -name *.a | xargs rm -rf 
# find ${ROOTFS_PATHS} -name *.o | xargs rm -rf
# find ${ROOTFS_PATHS} -name *.spec | xargs rm -rf

# #create file directories
# sh ${PROJECT_PATH}/scripts/mkdir_image.sh ${ROOTFS_PATHS} ${RELEASE}

# #make default sys back files
# bash ${script_dir}/mk_sysback.sh ${ROOTFS_PATHS}/etc/sysback.json ${ROOTFS_PATHS}

# #create image files
# echo "create rootfs file to ${ROOTFS_PATHS}"
# echo "please waiting..."
# rm -rf ${ROOTFS_PATHS}/../rootfs.tgz
# cd ${ROOTFS_PATHS}

# ln -s sbin/init init
# ln -s bin/busybox linuxrc
# tar -cvzf rootfs.tgz *
# sync

# #mv rootfs.tgz to dist directory
# echo "copy rootfs.tgz to dist directory"
# mv ${ROOTFS_PATHS}/rootfs.tgz ${DIST_PATH}

# #copy grub.cfg
# cp ${PROJECT_PATH}/config/x86_64/grub ${DIST_PATH} -rf

# #copy install shell
# cp ${script_dir}/install_system_x86_64.sh ${DIST_PATH}/install_system.sh

# #generate zip file
# cd ${DIST_PATH}
# rm -rf x86_64-*.tar.gz 
# sync
# tar cvzf x86_64-${RELEASE}-${VERSION}-${PRODUCT}-`date +%Y-%m-%d`.tar.gz install_system.sh rootfs.tgz Image/bzImage grub/grub.cfg.sda

# #delete needless files
# rm -rf grub Image
# find ${DIST_PATH}/ -type f -not -name "*.tar.gz" -exec rm {} \;
# sync

