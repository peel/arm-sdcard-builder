ID := $(shell losetup -f)
TARGET_DIR := "/backup"

### REMOTE RUN
default: build

build:
		dd if=/dev/zero of=sdcard.img bs=1M count=1850
		losetup ${ID} sdcard.img
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
		umount boot root
		losetup -d ${ID}

copy: default
		cp sdcard.img ${TARGET_DIR}/

tar: default
		tar -cvzf ${TARGET_DIR}/sdcard.img.tgz /app/sdcard.img
