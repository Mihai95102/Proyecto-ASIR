#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes
sudo apt-get update -y

# Creamos un dominio
# plesk bin domain --create $CREATE -hosting true -ip $HOST_IP -login $ROL -passwd $PASSWD

# Creamos un rol para los usuarios
plesk bin role --create $ROL \
    -owner $OWNER \
    -webSitesAndDomainsManagement true \
    -spamfilterManagement true \
    -antivirusManagement true \
    -backupRestoreManagement true \
    -browseStats true \
    -applicationsManagement true \
    -filesManagement true \
    -dnsManagement true \
    -mailManagement true

# Creamos un nuevo usuario para que el cliente gestione su dominio
plesk bin user --create $ROL \
    -cname $ROL \
    -role $ROL \
    -passwd $PASSWD \
    -owner $OWNER \
    -external-email $CORREO \
    -subscription-name $CREATE