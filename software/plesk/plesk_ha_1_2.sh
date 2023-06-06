#!/bin/bash

set -x

# Para administrar el clúster HA y los recursos compartidos instalamos estas herramientas
apt-get install corosync pacemaker -y

# Deshabilitamos los servicios de plesk para que el software del cluster HA se encargue
for i in \
    plesk-ip-remapping \
    plesk-php74-fpm.service \
    plesk-php82-fpm.service \
    plesk-web-socket.service \
    plesk-task-manager.service \
    plesk-ssh-terminal.service \
    plesk-repaird.socket \
    sw-engine.service \
    sw-cp-server.service \
    psa.service \
    cron.service \
    xinetd.service \
    nginx.service \
    apache2.service httpd.service \
    mariadb.service mysql.service postgresql.service \
    named.service bind9.service named-chroot.service \
    postfix.service; \
    do systemctl disable $i && systemctl stop $i; \
done

# Creamos directorio para montar NFS
mkdir -p /nfs/plesk_files

# Cambiamos el contenido del archivo /etc/hosts
cp conf/hosts /etc/hosts

# Cambiamos el archivo de configuración de corosync
cp conf/corosync.conf /etc/corosync/corosync.conf

# Instalamos JQ
apt-get install jq -y

# Nos movemos de directorio
cd /usr/lib/ocf/resource.d/heartbeat/

# Agentes de recursos
wget https://github.com/ClusterLabs/resource-agents/blob/main/heartbeat/awseip
wget https://raw.githubusercontent.com/ClusterLabs/resource-agents/main/heartbeat/Filesystem
wget https://www.plesk.com/filelink.php?d=BindFilesystem
wget https://www.plesk.com/filelink.php?d=PleskHA

# Cambiamos el nombre de los recursos
mv 'filelink.php?d=BindFilesystem' /usr/lib/ocf/resource.d/heartbeat/BindFilesystem
mv 'filelink.php?d=PleskHA' /usr/lib/ocf/resource.d/heartbeat/PleskHA

# Le damos permisos de ejecución a los recursos
chmod 755 awseip Filesystem BindFilesystem PleskHA