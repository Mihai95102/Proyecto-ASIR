#!/bin/bash

set -x

# Actualizamos los paquetes
apt-get update -y

# Instalamos el comando CURL
apt-get install curl -y

# Instalamos PERL
apt-get install perl perl-base -y

# Ejecutamos el instalador de CPanel usando CURL
cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest