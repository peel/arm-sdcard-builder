FROM pritunl/archlinux
MAINTAINER plimanowski+dev@protonmail.com

RUN mkdir /app
WORKDIR /app

RUN curl -o /app/distro.tar.gz -L http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
RUN pacman -Syu --noconfirm dosfstools parted make &&\
    pacman -Sc --noconfirm

ADD Makefile /app/

ENTRYPOINT ["make"]
CMD ["copy"]
