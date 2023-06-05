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