#!/bin/bash

set -x

# Actualizamos los paquetes
sudo apt-get update -y

# Cambiamos la interfaz de Plesk
sudo plesk bin poweruser --off

# Creamos un dominio
sudo plesk bin domain --create proyectoasir2.ddns.net -hosting true -ip 172.31.83.139 -login mihai -passwd @W62dv8ui