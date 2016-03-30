IMAGE_NAME := "peelsky/arm-sdcard-builder"
ID := $(shell losetup -f)
PWD := $(shell pwd)

ARCHIVE=
TARGET_DIR := /backup
PLATFORM := rpi-3
DISTRO_TAR_URL := http://archlinuxarm.org/os/ArchLinuxARM-$(PLATFORM)-latest.tar.gz

default: prebuild $(PLATFORM) postbuild

prebuild:
		dd if=/dev/zero of=sdcard.img bs=1M count=1850
		losetup ${ID} sdcard.img

postbuild:
		losetup -d ${ID}
		umount root

odroid:
		parted ${ID} mktable gpt && parted -a optimal ${ID} mkpart primary ext4 8MiB 100%
		mkfs.ext4 ${ID}p1
		mkdir root
		mount ${ID}p1 root
		tar -xvf distro.tar.gz -C root
		cd root/boot && sh sd_fusing.sh ${ID}

odroid-c1: odroid

odroid-c2: odroid

rpi-2:
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

rpi-3: rpi-2

copy: default
		cp sdcard.img ${TARGET_DIR}/

tar: default
		tar -cvzf ${TARGET_DIR}/sdcard.img.tgz /app/sdcard.img

mac: download
		docker-machine ssh default -- "losetup -a | cut -c1-10 | xargs -i losetup -d {}" || true
		docker-machine ssh default -- "losetup -f" || true
		docker run --privileged -e PLATFORM=${PLATFORM} -v ${PWD}/Makefile:/app/Makefile -v ${PWD}:/backup -v ${PWD}/distro.tar.gz:/app/distro.tar.gz ${IMAGE_NAME} -e copy

linux: download default

download:
ifeq ($(wildcard $(PWD)/distro.tar.gz),)
	curl -o distro.tar.gz -L ${DISTRO_TAR_URL}
endif
