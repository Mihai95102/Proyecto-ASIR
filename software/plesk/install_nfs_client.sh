#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Instalamos el cliente NFS
apt-get install nfs-common -y

# Movemos los vhosts existentes a una nueva carpeta
mv /var/www/vhosts /var/www/vhosts.original

# Creamos una nueva carpeta para vhosts
mkdir /var/www/vhosts

# Añadimos contenido al archivo /etc/fstab
cp conf/fstab /etc/fstab

# Montamos /var/www/vhosts
mount /var/www/vhosts

# Copiamos los archivos del directorio antiguo al nuevo
cp -aRv /var/www/vhosts.original/* /var/www/vhosts

# Eliminamos la carpeta de /var/www/vhosts.original para liberar espacio en el disco.
rm -rf /var/www/vhosts.original