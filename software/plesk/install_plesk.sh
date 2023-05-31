#!/bin/bash

set -x

# Actualizamos los paquetes
apt-get update -y

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
sudo ./plesk-installer --select-product-id plesk --select-release-latest --installation-type Recommended

# Configuración postinstalación de Plesk
plesk bin init_conf --init \
    -default-ip 34.230.204.213 \
    -netmask 255.255.255.0 \
    -iface eth0 \
    -ip-type shared \
    -hostname plesk.ddns.net \
    -name "Mihai" \
    -passwd @W62dv8ui \
    -phone 642083481 \
    -email mbut182@g.educaand.es \
    -company "SKYNET S.L" \
    -address "Calle Ave del Paraíso 2" \
    -city "Almería" \
    -zip 04117 \
    -country ES \
    -state ALM \
    -trial_license true

# Cambiamos el idioma de la interfaz de Plesk
mysql -u root -e "use psa; update misc set val='es-ES' where param='def_locale'; update misc set val='es-ES' where param='admin_locale';"

# Cambiamos la interfaz de Plesk
# plesk bin poweruser --off