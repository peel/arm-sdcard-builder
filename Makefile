ID := $(shell losetup -f)
TARGET_DIR := /backup
PLATFORM := rp3
DISTRO_TAR_URL := http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz

default: prebuild $(PLATFORM) postbuild

prebuild:
		dd if=/dev/zero of=sdcard.img bs=1M count=1850
		losetup ${ID} sdcard.img

postbuild:
		losetup -d ${ID}
		umount root

odroid:
		parted -a optimal ${ID} mkpart primary ext4 8MiB 100%
		mkfs.ext4 ${ID}p1
		mkdir root
		mount ${ID}p1 root
		tar -xvf distro.tar.gz -C root
		sh root/boot/fusing.sh ${ID}

oc1: odroid

oc2: odroid

rp2:
		parted ${ID} mktable msdos && parted -a optim ${ID} mkpart primary fat32 1MiB 100MiB && parted ${ID} set 1 boot on && parted -a optimal ${ID} mkpart primary ext4 100MiB 100%
		mkfs.vfat ${ID}p1
		mkdir boot
		mount ${ID}p1 boot
		mkfs.ext4 ${ID}p2
		mkdir root
		mount ${ID}p2 root
		tar -xvf distro.tar.gz -C root
		sync
		mv root/boot/* boot
		umount boot

rp3: rp2

copy: default
		cp sdcard.img ${TARGET_DIR}/

tar: default
		tar -cvzf ${TARGET_DIR}/sdcard.img.tgz /app/sdcard.img

linux: download default

download:
		curl -o distro.tar.gz -L ${DISTRO_TAR_URL}

