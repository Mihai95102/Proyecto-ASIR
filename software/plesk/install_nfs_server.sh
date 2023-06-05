#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes del sistema
apt-get update

# Instalamos el NFS Server
apt-get install nfs-kernel-server -y

# Eliminamos los directorios por si existen
rm -rf /var/nfs/plesk-ha/vhosts
rm -rf /var/nfs/plesk-ha/plesk_files

# Creamos un directorio donde Plesk almacenará los archivos de los sitios web
mkdir -p /var/nfs/plesk-ha/vhosts
mkdir -p /var/nfs/plesk-ha/plesk_files

# Actualizamos el archivo /etc/exports
cp conf/exports /etc/exports

# Reiniciamos el servicio NFS
systemctl restart nfs-kernel-server
