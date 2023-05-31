#!/bin/bash

set -x

# Actualizamos los paquetes
sudo apt-get update -y

# Creamos un dominio
plesk bin domain --create proyectoplesk.ddns.net -hosting true -ip 34.230.204.213 -login mihai -passwd @W62dv8ui