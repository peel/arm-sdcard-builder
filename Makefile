DISTRO_DOWNLOAD_URL:="http://archlinuxarm.org/os/"
DISTRO_FILE_NAME := "ArchLinuxARM-rpi-2-latest.tar.gz"
ID := $(shell losetup -f)

### AUTOMATED RUN
default: download setup image

download:
		curl ${DISTRO_DOWNLOAD_URL}${DISTRO_FILE_NAME} -o distro.tar.gz

setup:
		rm sdcard.img || true
		dd if=/dev/zero of=sdcard.img bs=1M count=1850
		parted sdcard.img mktable msdos && parted -a optim sdcard.img mkpart primary fat32 1MiB 100MiB && parted sdcard.img set 1 boot && parted -a optimal sdcard.img mkpart primary ext4 100MiB 100%
		sleep 20
		losetup -f sdcard.img
		sleep 20 
		mkfs.vfat ${ID}p1
		sleep 5
		mkdir boot
		mount ${ID}p1 boot
		mkfs.ext4 ${ID}p2
		sleep 5
		mkdir root
		mount ${ID}p2 root
		tar -xzvf distro.tar.gz -C root
		sync
		mv root/boot/* boot
		umount boot root
		losetup -d ${ID}p2
		losetup -d ${ID}p1
		losetup -d ${ID}

image:
		cp sdcard.img /tmp/img/
