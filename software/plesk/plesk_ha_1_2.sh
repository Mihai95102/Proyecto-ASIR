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