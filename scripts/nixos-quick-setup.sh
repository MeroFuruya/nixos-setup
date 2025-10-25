#!/bin/sh

sudo parted /dev/sda -- mklabel gpt &&\
sudo parted /dev/sda -- mkpart root ext4 512MB -8GB &&\
sudo parted /dev/sda -- mkpart swap linux-swap -8GB 100% &&\
sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB &&\
sudo parted /dev/sda -- set 3 esp on &&\
sudo mkfs.ext4 -L nixos /dev/sda1 &&\
sudo mkswap -L swap /dev/sda2 &&\
sudo mkfs.fat -F 32 -n boot /dev/sda3 &&\
sudo mount /dev/disk/by-label/nixos /mnt &&\
sudo mkdir -p /mnt/boot &&\
sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot &&\
sudo swapon /dev/sda2 &&\
sudo nixos-generate-config --root /mnt