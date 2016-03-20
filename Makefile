default: build

build:
		diskutil unmountDisk /dev/disk2s
		sudo chmod 0777 /dev/disk
		vagrant up

delete:
		vagrant destroy -f
		rm -f sd_card.vmdk
