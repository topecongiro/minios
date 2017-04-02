#!/bin/sh

./setup.sh
make

mkdir -p isodir/boot/grub
cp minios.bin isodir/boot
cp grub.cfg isodir/boot/grub
grub-mkrescue -o minios.iso isodir

qemu-system-i386 -cdrom minios.iso
