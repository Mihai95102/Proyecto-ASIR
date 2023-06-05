#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes del sistema
apt-get update

# Instalamos el NFS Server
apt-get install nfs-kernel-server -y

# Eliminamos los directorios por si existen
rm -rf /var/nfs/plesk-1/vhosts
rm -rf /var/nfs/plesk-2/vhosts

# Creamos un directorio donde Plesk almacenará los archivos de los sitios web
mkdir -p /var/nfs/plesk-1/vhosts
mkdir -p /var/nfs/plesk-2/vhosts

# Actualizamos el archivo /etc/exports
cp conf/exports /etc/exports

# Reiniciamos el servicio NFS
systemctl restart nfs-kernel-server
