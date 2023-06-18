#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes del sistema
apt-get update

# Instalamos el servidor de Bases de Datos
apt-get install mariadb-server -y

# Cambiamos el archivo de configuración de MySQL
cp conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Creamos bases de datos, usuarios y permisos
mysql -u root -e "CREATE USER '$USUARIOPLESK'@'%' IDENTIFIED BY '$BD_PASS';"
mysql -u root -e "GRANT ALL ON *.* TO '$USUARIOPLESK'@'%' WITH GRANT OPTION;"

# Reiniciamos el servidor de MySQL
systemctl restart mysql