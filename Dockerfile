FROM pritunl/archlinux
MAINTAINER plimanowski+dev@protonmail.com

ENV PLATFORM=rpi-3 DISTRO_TAR_URL=http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz

RUN mkdir /app
WORKDIR /app

RUN pacman -Syu --noconfirm dosfstools parted make &&\
    pacman -Sc --noconfirm

ADD Makefile /app/

ENTRYPOINT ["make"]
CMD ["copy"]
