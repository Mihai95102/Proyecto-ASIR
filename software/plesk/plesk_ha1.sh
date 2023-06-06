#!/bin/bash

set -x

# Cambiamos el contenido del archivo para que plesk sepa que esta en un clusteHA
cp conf/panel.ini.sample /usr/local/psa/admin/conf/panel.ini.sample

# Montamos el directorio NFS
mount -t nfs -o "hard,timeo=600,retrans=2,_netdev" 44.208.3.123:/var/nfs/plesk-ha/vhosts /mnt

# Copiamos los archivos de vhosts al punto de montaje
cp -aRv /var/www/vhosts/* /mnt

# Desmontamos el punto de montaje NFS
umount /mnt

# Montamos el directorio de los archivos de Plesk en NFS
mount -t nfs -o "hard,timeo=600,retrans=2,_netdev" 44.208.3.123:/var/nfs/plesk-ha/plesk_files /nfs/plesk_files

# Creamos árbol de directorios en el punto de montaje
mkdir -p /nfs/plesk_files/etc/{apache2,nginx,psa,sw,sw-cp-server,domainkeys,psa-webmail}

# Copiamos los archivos de los servicios al punto de montaje
cp -a /etc/passwd /nfs/plesk_files/etc/
cp -aR /etc/apache2/. /nfs/plesk_files/etc/apache2
cp -aR /etc/nginx/. /nfs/plesk_files/etc/nginx
cp -aR /etc/psa/. /nfs/plesk_files/etc/psa
cp -aR /etc/sw/. /nfs/plesk_files/etc/sw
cp -aR /etc/sw-cp-server/. /nfs/plesk_files/etc/sw-cp-server
cp -aR /etc/sw-engine/. /nfs/plesk_files/etc/sw-engine
cp -aR /etc/domainkeys/. /nfs/plesk_files/etc/domainkeys
cp -aR /etc/psa-webmail/. /nfs/plesk_files/etc/psa-webmail

# Creamos nuevas carpetas en /nfs/plesk_files
mkdir -p /nfs/plesk_files/var/{spool,named}

# Copiamos archivos
cp -aR /var/named/. /nfs/plesk_files/var/named
cp -aR /var/spool/. /nfs/plesk_files/var/spool

# Nuevas carpetas
mkdir -p /nfs/plesk_files/opt/plesk/php/{7.4,8.2}/etc

# Copiamos los archivos
cp -aR /opt/plesk/php/7.4/etc/. /nfs/plesk_files/opt/plesk/php/7.4/etc
cp -aR /opt/plesk/php/8.2/etc/. /nfs/plesk_files/opt/plesk/php/8.2/etc

# Cramos nuevas carpetas
mkdir -p /nfs/plesk_files/usr/local/psa/{admin/conf,admin/plib/modules,etc/modules,var/modules,var/certificates}

# Copiamos nuevos archivos
cp -aR /usr/local/psa/admin/conf/. /nfs/plesk_files/usr/local/psa/admin/conf
cp -aR /usr/local/psa/admin/plib/modules/. /nfs/plesk_files/usr/local/psa/admin/plib/modules
cp -aR /usr/local/psa/etc/modules/. /nfs/plesk_files/usr/local/psa/etc/modules
cp -aR /usr/local/psa/var/modules/. /nfs/plesk_files/usr/local/psa/var/modules
cp -aR /usr/local/psa/var/certificates/. /nfs/plesk_files/usr/local/psa/var/certificates

# Desmontamos el punto de montaje
umount /nfs/plesk_files

# Controlador de eventos para mantener /etc/passwd actualizado
plesk bin event_handler --create -command "/bin/cp /etc/passwd /nfs/plesk_files/etc/passwd" -priority 50 -user root -event phys_hosting_create
plesk bin event_handler --create -command "/bin/cp /etc/passwd /nfs/plesk_files/etc/passwd" -priority 50 -user root -event phys_hosting_update
plesk bin event_handler --create -command "/bin/cp /etc/passwd /nfs/plesk_files/etc/passwd" -priority 50 -user root -event phys_hosting_delete

plesk bin event_handler --create -command "/bin/cp /etc/passwd /nfs/plesk_files/etc/passwd" -priority 50 -user root -event ftpuser_create
plesk bin event_handler --create -command "/bin/cp /etc/passwd /nfs/plesk_files/etc/passwd" -priority 50 -user root -event ftpuser_update
plesk bin event_handler --create -command "/bin/cp /etc/passwd /nfs/plesk_files/etc/passwd" -priority 50 -user root -event ftpuser_delete

plesk bin event_handler --create -command "/bin/cp /etc/passwd /nfs/plesk_files/etc/passwd" -priority 50 -user root -event site_subdomain_create
plesk bin event_handler --create -command "/bin/cp /etc/passwd /nfs/plesk_files/etc/passwd" -priority 50 -user root -event site_subdomain_update
plesk bin event_handler --create -command "/bin/cp /etc/passwd /nfs/plesk_files/etc/passwd" -priority 50 -user root -event site_subdomain_delete
plesk bin event_handler --create -command "/bin/cp /etc/passwd /nfs/plesk_files/etc/passwd" -priority 50 -user root -event site_subdomain_move