#!/bin/bash
useradd -m ansible
echo ansible:ansible | chpasswd
sed -i '/#PubkeyAuthentication yes/c\PubkeyAuthentication yes' /etc/ssh/sshd_config
sed -i '/PasswordAuthentication no/c\PasswordAuthentication yes' /etc/ssh/sshd_config
usermod -aG wheel ansible
systemctl restart sshd