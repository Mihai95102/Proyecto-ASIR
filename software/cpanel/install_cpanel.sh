#!/bin/bash

set -x

# Actualizamos los paquetes
sudo apt-get update -y

# Instalamos el comando CURL
sudo apt-get install curl -y

# Instalamos PERL
sudo apt-get install perl

# Ejecutamos el instalador de CPanel usando CURL
cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest