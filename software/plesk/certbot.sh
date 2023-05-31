#!/bin/bash

set -x

# Instalamos snap:
sudo snap install core

# Actualizamos snap:
sudo snap refresh core

# Eliminamos si existiese alguna instalación previa de certbot con apt:
sudo apt-get remove certbot

# Instalamos el cliente de Certbot con snapd:
sudo snap install --classic certbot

# Creamos una alias para el comando certbot:
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Obtenemos el certificado y configuramos el servidor web Apache:
sudo certbot --apache -m mbut182@g.educaand.es --agree-tos --no-eff-email -d hostingplesk.ddns.net

# Comprobamos que existe un temporizador que se encarga de renovar los certificados de forma automática:
systemctl list-timers