#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes
apt-get update -y

# # Instalamos Apache
# apt-get install apache2

# # Ejecutamos el script de Certbot para solicitar el certificado
# sudo ./certbot_plesk.sh

# Instalamos el comando WGET
apt-get install wget

# Descargamos el instalador de Plesk usando WGET
wget https://autoinstall.plesk.com/plesk-installer

# Movemos el instalador de Plesk a /tmp
mv plesk-installer /tmp

# Entramos a /tmp
cd /tmp

# Le damos permisos de ejecución al archivo del instalador
chmod +x ./plesk-installer

# Ejecutamos el instalador de Plesk
sudo PLESK_DB_DSN_PREFIX=mysql://plesk1:hola@44.214.48.106/host1_psa ./plesk-installer --select-product-id plesk --select-release-latest --installation-type Recommended

# Configuración postinstalación de Plesk
plesk bin init_conf --init \
    -name $NAME \
    -passwd $PASSWD \
    -phone $PHONE \
    -email $EMAIL \
    -company "SKYNET S.L" \
    -address "Calle Ave del Paraíso 2" \
    -city $CITY \
    -zip $ZIP \
    -country $COUNTRY \
    -state $STATE \
    -trial_license true

# Cambiamos el idioma de la interfaz de Plesk
mysql -u root -e "use psa; update misc set val='es-ES' where param='def_locale'; update misc set val='es-ES' where param='admin_locale';"

# # Ejecutamos el script de creación de dominio, usuario y rol
# sudo ./create_plesk.sh