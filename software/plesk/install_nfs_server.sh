#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes del sistema
apt-get update

# Instalamos el NFS Server
apt-get install nfs-kernel-server -y

# Actualizamos los archivos de configuración del servidor NFS
cp conf/nfs.conf /etc/nfs.conf
cp conf/nfs-kernel-server /etc/default/nfs-kernel-server

# Reiniciamos el servicio nfs-mountd.service
systemctl restart nfs-mountd.service

# Creamos un directorio donde Plesk almacenará los archivos de los sitios web
mkdir -p /var/nfs/plesk-1/vhosts

# Actualizamos el archivo /etc/exports
cp conf/exports /etc/exports

# Reiniciamos el servicio NFS
systemctl restart nfs-kernel-server