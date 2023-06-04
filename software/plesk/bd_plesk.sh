#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes del sistema
apt-get update -y

# Instalamos el servidor de Bases de Datos
apt-get install mysql-server -y

# Cambiamos el archivo de configuración de MySQL
cp conf/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciamos el servidor de MySQL
systemctl restart mysql

# Creamos dos usuarios y les damos permisos a las bases de datos
mysql -u root -e "CREATE USER '$USUARIO1'@'%' IDENTIFIED BY '$PASSWD';"
mysql -u root -e "GRANT ALL ON *.* TO '$USUARIO1'@'%' WITH GRANT OPTION;"
mysql -u root -e "CREATE USER '$USUARIO2'@'%' IDENTIFIED BY '$PASSWD';"
mysql -u root -e "GRANT ALL ON *.* TO '$USUARIO2'@'%' WITH GRANT OPTION;"