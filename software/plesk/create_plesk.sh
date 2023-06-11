#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes
sudo apt-get update

# Creamos un dominio
plesk bin domain --create $CREATE -hosting true -ip $HOST_IP -login $ROL2 -passwd $PASSWD

# # Creamos una cuenta de email
# plesk bin mail --create $MAIL -mailbox true -passwd $PASSWD -status enabled -delivery true 

# Creamos un rol para los usuarios
plesk bin role --create $ROL2 \
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
plesk bin user --create $ROL2 \
    -cname $ROL2 \
    -role $ROL2 \
    -passwd $PASSWD \
    -owner $OWNER \
    -external-email $CORREO \
    -subscription-name $CREATE