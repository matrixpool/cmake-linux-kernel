#!/bin/bash

#${1} QSG_PRODUCT
#${2} rootfs directory
#${3} image dist directory
#${4} QSG_VERSION

PRODUCT=${1}
ROOTFS_PATH=${2}
DIST_PATH=${3}
VERSION=${4}

IMG_NAME=${PRODUCT}-${VERSION}
IMG=${DIST_PATH}/${IMG_NAME}.img
VMDK=${DIST_PATH}/${IMG_NAME}.vmdk
SIZE=128

rm -rf ${IMG} ${VMDK}

# create empty image file
dd if=/dev/zero bs=1M count=$SIZE of=$IMG

# create partition disk
parted $IMG --script -- mklabel msdos
parted $IMG --script -- mkpart primary 1MiB 33MiB
parted $IMG --script -- mkpart primary ext4 33MiB 100%
parted $IMG --script -- set 1 bios_grub on

# relate loop device
LOOP_DEV=$(losetup -fP --show $IMG)

# format 
mkfs.ext4 ${LOOP_DEV}p1
mkfs.ext4 ${LOOP_DEV}p2

# mount disk
mkdir -p /mnt/boot /mnt/rootfs
mount ${LOOP_DEV}p1 /mnt/boot
mount ${LOOP_DEV}p2 /mnt/rootfs

# install grub
grub2-install --target=i386-pc --boot-directory=/mnt/boot/boot \
    --modules="normal part_msdos ext2" --recheck --force ${LOOP_DEV}

# copy bzImage
mkdir -p /mnt/boot/boot/grub
cp ${ROOTFS_PATH}/boot/bzImage /mnt/boot/boot/bzImage

# generate grub.cfg
PTUUID=$(blkid -s PTUUID -o value ${IMG}) 
cat <<EOF > /mnt/boot/boot/grub/grub.cfg

serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1 --rtscts=off
terminal_input console serial; terminal_output console serial

set default="0"
set timeout="5"
set root='(hd0,msdos1)'

menuentry "VPN" {
	linux /boot/bzImage root=PARTUUID=${PTUUID}-02 rw rootwait  console=tty0 console=ttyS0,115200n8 noinitrd
}
EOF

# install rootfs
cp -rf ${ROOTFS_PATH}/* /mnt/rootfs
rm -rf /mnt/rootfs/boot
sync

qemu-img convert -O vmdk ${IMG} ${VMDK}

# umount and delete tmp files
umount /mnt/boot
umount /mnt/rootfs
losetup -d ${LOOP_DEV}
sync
rm -rf /mnt/*

echo "Bootable image created successfully: $IMG"

