FROM pritunl/archlinux

ENV DISTRO_DOWNLOAD_URL="http://archlinuxarm.org/os/" DISTRO_FILE_NAME="ArchLinuxARM-rpi-2-latest.tar.gz"

RUN mkdir /app
ADD Makefile fdisk.sh /app/
WORKDIR /app

RUN pacman -Syu --noconfirm dosfstools parted make &&\
    pacman -Sc --noconfirm

VOLUME /tmp/img

CMD make DISTRO_DOWNLOAD_URL=${DISTRO_DOWNLOAD_URL} DISTRO_FILE_NAME=${DISTRO_FILE_NAME}
