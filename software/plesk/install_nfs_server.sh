#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes del sistema
apt-get update

# Instalamos el NFS Server
apt-get install nfs-kernel-server -y

# Activamos la opción manage-gids en nfs.conf
sed -i "s/manage-gids=n/manage-gids=y/" /etc/nfs.conf

# Activamos la opción manage-gids en nfs-kernel-server
sed -i "s/RPCMOUNTDOPTS="--manage-gids"/RPCMOUNTDOPTS="--manage-gids"/" /etc/default/nfs-kernel-server

# Creamos la ruta NFS
mkdir /var/nfs/plesk/vhosts

# Actualizamos el archivo /etc/exports
cp conf/exports /etc/exports

# Reiniciamos el servicio NFS
systemctl restart nfs-kernel-server