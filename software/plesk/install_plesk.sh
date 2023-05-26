#!/bin/bash

set -x

# Actualizamos los paquetes
sudo apt-get update -y

# Instalamos el comando WGET
sudo apt-get install wget

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

# Creamos un dominio
sudo plesk bin domain --create proyectoasir2.ddns.net -hosting true -ip 34.230.204.213 -login mihai -passwd @W62dv8ui

# Añadimos la extensión de AcronisBackup
sudo plesk bin extension --install AcronisBackup