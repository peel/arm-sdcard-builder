ID := $(shell losetup -f)

### AUTOMATED RUN
default: setup build image

build:
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

mac:
		docker-machine ssh default "docker run --privileged -v $(pwd):/backup peelsky/rpi-arch-tar-to-img:20160306 && tar cvf /backup/sdcard.tar.gz /app/sdcard.img"


