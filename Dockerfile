FROM pritunl/archlinux

RUN mkdir /app
ADD Makefile /app/
WORKDIR /app

RUN pacman -Syu --noconfirm dosfstools parted make &&\
    pacman -Sc --noconfirm

RUN dd if=/dev/zero of=sdcard.img bs=1M count=1850
RUN curl -o distro.tar.gz -L http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz

ENTRYPOINT make
CMD mac
