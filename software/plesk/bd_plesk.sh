#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes del sistema
apt-get update

# Instalamos el servidor de Bases de Datos
apt-get install mysql-server -y

# Cambiamos el archivo de configuración de MySQL
cp conf/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

# Creamos bases de datos, usuarios y permisos
mysql -u root -e "CREATE DATABASE host1_psa;"
mysql -u root -e "CREATE USER '$USUARIOPLESK'@'%' IDENTIFIED BY '$PASSWD';"
mysql -u root -e "GRANT ALL ON host1_psa.* TO '$USUARIOPLESK'@'%' WITH GRANT OPTION;"

mysql -u root -e "CREATE DATABASE host1_apsc;"
mysql -u root -e "CREATE USER '$USUARIOAPSC'@'%' IDENTIFIED BY '$PASSWD';"
mysql -u root -e "GRANT ALL ON host1_apsc.* TO '$USUARIOAPSC'@'%' WITH GRANT OPTION;"

mysql -u root -e "CREATE DATABASE host1_roundcubemail;"
mysql -u root -e "CREATE USER '$USUARIOMAIL'@'%' IDENTIFIED BY '$PASSWD';"
mysql -u root -e "GRANT ALL ON host1_roundcubemail.* TO '$USUARIOMAIL'@'%' WITH GRANT OPTION;"

# Reiniciamos el servidor de MySQL
systemctl restart mysql