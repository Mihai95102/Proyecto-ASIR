# Hosting con Plesk
En este proyecto voy a llevar a cabo un despliegue en 2 servidores de hosting con Plesk, una instalación local y otra instalación en un servidor con base de datos remota.

## 1. Plesk como herramienta de Hosting
 Plesk es un panel de control de hosting  web. Se utiliza principalmente en entornos de hosting web basados en Windows y Linux. Plesk ofrece una amplia gama de funciones, como la gestión de sitios web, la administración de bases de datos, el correo electrónico y la seguridad, todo en una sola plataforma. Además, Plesk ofrece una amplia variedad de herramientas de automatización y gestión de clientes para ayudar a los proveedores de hosting a administrar sus negocios.

 Este proyecto se centra en utilizar Plesk en un entorno simulado de proveedor de hosting, abordando la creación y mantenimiento de dominios y subdominios, así como explorando todas las herramientas, configuraciones, seguridad, correo, extensiones e importación necesarias para lograr un entorno óptimo y seguro.

 Se exploran diferentes herramientas y configuraciones disponibles para garantizar un ambiente seguro y altamente funcional, tales como la implementación de políticas de seguridad, la aplicación de certificados SSL y la detección y mitigación de posibles vulnerabilidades.

 ## 2. Creación de la infraestructura con AWS:
Para llevar a cabo la instalación y despliegue de Plesk, se utilizará el servicio gratuito de Amazon para crear y configurar los servidores en un entorno real. Amazon ofrece una plataforma sólida y confiable, conocida como Amazon Web Services (AWS), que brinda una infraestructura escalable y flexible.

La infraestructura utilizada será la siguiente:

<img src="images/infraesructura.png" width="400"/>

### Requisitos de las instancia de Plesk en AWS:

Los requisitos de las instancias serán los mismos para los 2 servidores, tanto para el servidor Remoto como para el Local.

- __Sistema Operativo:__ el sistema operativo que se usará será Ubuntu Server 22.04 LTS, pero este no es único Sistema Operativo soportado por Plesk. Plesk es soportado tanto por Windows (Server o no) como por Linux (Ubuntu, Debian, CentOS, RHEL).

    <img src="images/4.png" width="350"/>

- __Tamaño de memoria RAM:__ para este proyecto será suficiente con escoger el tipo de memoria “t2.medium” que equivale a 4GB. En caso de tener un servidor de Plesk real si se necesitarán más recursos dependiendo del nivel de carga que se le dará, lo más recomendado para un servidor de Plesk real que se use para administrar un gran número de dominios es mínimo unos 8 o 16 GB de memoria RAM.

    <img src="images/5.png" width="380"/>

- __Par de claves:__ el par de claves “vockey.pem” de tipo RSA se usará para que sea posible la conexión remota al servidor usando SSH.

- __Configuración de red:__ en este caso se requiere abrir una serie de puertos específicos para que los servidores funcionen correctamente. Para ello se creará un nuevo grupo de seguridad al que se le asignará a las instancias durante su creación.

    <img src="images/6.png" width="400"/>
    
    Los puertos que se necesitarán abrir en las reglas de entrada son los siguientes:

    - __Puertos de Plesk:__ 8443 (__HTTPS__), 8880 (__HTTP__), 8447 (__Actualizaciones__)
    - __Servicios:__ 80 (__HTTP__), 443 (__HTTPS__), 7080 (__Apache Plesk__), 7081 (__SSL Apache Plesk__), 21 (__FTP__), 22 (__SSH__), 3306 (__MariaDB__), 53 TCP y 53 UDP (__DNS__)
    - __Correo:__ 25 y 465 (__SMTP__), 110 y 995 (__POP3__), 143 Y 993 (__IMAP__)
    - Para permitir hacer ping entre las instancias se añade la regla de “Todos los ICMP para iPv4”

- __Configuración de almacenamiento:__ la instalación de Plesk ocupa alrededor  de 10 GB por lo que para tener espacio de sobra ponemos 50 GB de tamaño disco duro.

    <img src="images/8.png" width="380"/>

- __Asignación de una IP Elástica:__ asignamos IP’s elásticas a las 3 instancias para que no cambien la IP’s cuando se reinicie AWS y para que no se rompa el servidor de Plesk por cambiar de IP.

## 2.1. Uso de Terraform con AWS

### ¿Qué es Terraform?

Terraform es una herramienta de código abierto que automatiza la creación y gestión de infraestructura en la nube. Permite describir la infraestructura deseada en un archivo de configuración y luego desplegarla de manera consistente y repetible en diferentes proveedores de cloud. Simplifica el proceso de administrar recursos como servidores, redes y bases de datos, facilitando la gestión eficiente de la infraestructura.

### Requisitos para uso de Terraform con AWS

Para el despliegue de infraestructura de servidores en AWS con Terraform es necesario instalar la herramienta de AWS CLI.

AWS CLI (__Command Line Interface__) es una herramienta que se ejecuta desde la línea de comandos que permite gestionar todos los servicios de Amazon Web Services.

Para instalar AWS CLI en nuestra instancia seguiremos los siguientes pasos:

1. Descargamos un archivo .zip con la aplicación AWS CLI.
    ```bash
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    ```
2. Descomprimimos el archivo que acabamos de descargar.
    ```bash
    unzip awscliv2.zip
    ```
3. Ejecutamos el script de instalación.
    ```bash
    sudo ./aws/install
    ```
4. Comprobamos que la instalación se ha realizado de forma correcta.
    ```bash
    aws --version
    ```
    <img src="images/16.png" width="380"/>

5. Configuramos AWS CLI con las credenciales de nuestra cuenta de AWS.

    <img src="images/18.png" width="380"/>

### Instalación de Terraform

Instalaremos Terraform en una instancia de AWS usando Ubuntu 22.04 como Sistema Operativo.

1. Primero actualizamos los paquetes del sistema e instalamos los recursos necesarios.
    ```bash
    sudo apt update && sudo apt install software-properties-common gnupg2 curl
    ```
2. Cargamos la clave GPG del repositorio
    ```bash
    curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor >  hashicorp.gpg
        
    sudo install -o root -g root -m 644 hashicorp.gpg /etc/apt/trusted.gpg.d/
    ```
3. Instalación de Terraform en Ubuntu
    ```bash
    sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

    sudo apt update && sudo apt install terraform
    ```
4. Comprobamos que se ha instalado correctamente viendo la versión de Terraform.

    <img src="images/21.png" width="380"/>

5. Al estar usando Visual Studio Code, como extra vamos a instalar la extensión de Terraform para que Code detecte el lenguaje que usa Terraform, que es YAML y la extensión de los archivos de Terraform “.tf”.

    <img src="images/22.png" width="380"/>

### Despliegue de la infraestructura con Terraform

Primero crearemos los grupos de seguridad habilitando los puertos necesarios para cada instancia:

<img src="images/24.png" width="380"/>

<img src="images/25.png" width="380"/>

A continuación, creamos las instancias, asignándole la AMI del Sistema Operativo que queremos usar, el tamaño de RAM, el tipo de key, el grupo de seguridad que hemos creado, el nombre de la instancia y el tamaño de disco que usaremos:

<img src="images/26.png" width="380"/>

<img src="images/27.png" width="380"/>

Finalmente asignamos una IP elástica a cada una de las instancias:

<img src="images/28.png" width="380"/>

Para ver el script completo aquí se puede ver: 

https://github.com/Mihai95102/Proyecto-ASIR/blob/main/infraestructura/plesk_infraestructure.tf

Una vez tengamos el script de la infraestructura creado, iniciaremos el script para que se creen las instancias.
Para iniciar el proceso ejecutamos los siguientes comandos:

```bash 
terraform init (iniciamos la herramienta de Terraform)
```

<img src="images/29.png" width="380"/>

```bash
terraform apply (cargamos el contenido del script que hemos hecho para que se inicie el proceso de creación)
```

<img src="images/30.png" width="380"/>

Primero nos mostrará los cambios que se van a aplicar y al final tendremos que escribir “yes” para confirmar los cambios.

<img src="images/31.png" width="380"/>

Al acabar la ejecución del script, podemos ir a nuestras instancias de AWS y veremos que se han creado correctamente todas las instancias.

<img src="images/32.png" width="500"/>

## 3. Instalación de Plesk

Para la instalación de Plesk tanto en __Local__ como en __Remoto__ crearemos un script de Bash donde automatizamos la instalación.

El script será el siguiente:

```bash
#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes
apt-get update

# Instalamos el comando WGET
apt-get install wget

# Descargamos el instalador de Plesk usando WGET
wget https://autoinstall.plesk.com/plesk-installer

# Movemos el instalador de Plesk a /tmp
mv plesk-installer /tmp

# Entramos a /tmp
cd /tmp

# Le damos permisos de ejecución al archivo del instalador
chmod +x ./plesk-installer

# Ejecutamos el instalador de Plesk
# sudo PLESK_DB_DSN_PREFIX=mysql://plesk1:hola@44.214.48.106/host1_
sudo ./plesk-installer --select-product-id plesk --select-release-latest --installation-type Recommended
```

La instalación puede llevar unos 10-15 minutos en completarse.

<img src="images/42.png" width="420"/>

Al terminar la instalación se  realizará la configuración inicial de Plesk a través del CLI (hay que tener en cuenta de que la configuración inicial sólo se puede realizar una vez, si algo falla y no se completa correctamente ya no se podrá volver a hacer a menos que instalemos otro servidor de Plesk).

```bash
# Configuración postinstalación de Plesk
plesk bin init_conf --init \
    -name $NAME \
    -passwd $PASSWD \
    -phone $PHONE \
    -email $EMAIL \
    -company "SKYNET S.L" \
    -address "Calle Ave del Paraíso 2" \
    -city $CITY \
    -zip $ZIP \
    -country $COUNTRY \
    -state $STATE \
    -trial_license true

# Cambiamos el idioma de la interfaz de Plesk
mysql -u root -e "use psa; update misc set val='es-ES' where param='def_locale'; update misc set val='es-ES' where param='admin_locale';"
```

<img src="images/44.png" width="750"/>

Para la instalación en remoto antes de instalar Plesk hay que configurar el servidor de Bases de Datos.

Para configurar el servidor de Bases de Datos vamos a escribir un script dónde se automatizará todo el proceso de configuración:

```bash
#!/bin/bash

set -x

# Variables
source ../vars/variables.sh

# Actualizamos los paquetes del sistema
apt-get update

# Instalamos el servidor de Bases de Datos
apt-get install mariadb-server -y

# Cambiamos el archivo de configuración de MySQL
cp conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Creamos bases de datos, usuarios y permisos
mysql -u root -e "CREATE USER '$USUARIOPLESK'@'%' IDENTIFIED BY '$BD_PASS';"
mysql -u root -e "GRANT ALL ON *.* TO '$USUARIOPLESK'@'%' WITH GRANT OPTION;"

# Reiniciamos el servidor de MySQL
systemctl restart mysql
```

Una vez finalizada la configuración del servidor de Bases de Datos, iremos al servidor de Plesk donde instalaremos la herramienta usando el servidor remoto que hemos configurado.

El proceso de despliegue de Plesk en una base de datos remota es el mismo que el despliegue en una base de datos local, la diferencia es que para realizar la instalación a la hora de ejecutar el instalador se definirá una nueva variable en la que se indicará la IP del servidor de Bases de Datos remoto que se quiere usar, el usuario nuevo que hemos creado y su contraseña correspondiente.

<img src="images/50.png" width="750"/>

Al acabarse la instalación podemos comprobar en el servidor de Bases de Datos como se han creado las bases de datos de Plesk.

<img src="images/51.png" width="250"/>

También al acceder al servidor de Plesk Remoto e ir a la sección de Bases de Datos podemos ver cómo está usando el servidor que configuramos previamente en vez del local.

<img src="images/52.png" width="250"/>

<img src="images/53.png" width="380"/>

### Ventajas y desventajas del uso de una Base de Datos Centralizada

Estas son algunas de las ventajas e inconvenientes de la instalación de Plesk en una base de datos centralizada:

__Ventajas:__ 

- Separar los servicios web y de bases de datos permite optimizar cada servidor para las tareas requeridas, por ejemplo, agregar más memoria a los servidores de bases de datos y permitirles utilizar toda la memoria disponible, sin competir con otros servicios.

- Puede usar muchas menos bases de datos para varios servidores Plesk, reduciendo la cantidad de trabajo de mantenimiento de la base de datos.

__Desventajas:__ 

- Si se utiliza una única base de datos para todos los servidores Plesk, la base de datos se convierte en un único punto de error para todos esos servidores Plesk.


- La velocidad de la red y la conectividad entre el servidor de la base de datos y Plesk deberían ser lo suficientemente buenas y estables.

## 4. Creación y administración de dominios

### Creación de dominios

La creación de dominios y mantenimiento de dominios en Plesk se hace de una forma muy cómoda e intuitiva. Tenemos 2 opciones a la hora de crear un dominio:

- __Desde la interfaz gráfica:__ esta forma es la más fácil y rápida para crear un dominio. Se puede crear un dominio en blanco donde subimos nosotros mismos nuestros archivos o podemos crear un sitio que tenga instalado WordPress

    <img src="images/100.png" width="380"/>

    Cuando tengamos claro la forma de crear el dominio le asignamos un nombre y lo vinculamos a una dirección IP.

    <img src="images/101.png" width="380"/>

    <img src="images/102.png" width="380"/>

    Además el dominio lo podemos vincular a la cuenta de un cliente, es decir, 
	dentro de Plesk podemos crear varios clientes y dentro cada cliente tendrá
	todos los dominios y subdominios vinculados a él, por otra parte se puede crear 
	un usuario para el cliente con el que este va a poder gestionar sus dominios, 
	subdominios y cuentas de correo de forma autónoma sin tener que contactar con
	el proveedor, en este caso nosotros.

    <img src="images/103.png" width="330"/>

    Una vez tengamos creado el cliente podremos crear una suscripción vinculada a 
	él dónde se guardarán todos los dominios y subdominios del cliente,

    <img src="images/105.png" width="380"/>

    <img src="images/104.png" width="420"/>

	A la hora de crear subdominios el proceso es similar, sólo que tendremos que
	indicar el dominio donde queremos que se cree el subdominio.

    <img src="images/106.png" width="420"/>

    Aquí podemos ver todos los dominios y subdominios del cliente.

    <img src="images/107.png" width="420"/>

- __Desde CLI:__ Plesk nos ofrece la opción de crear dominios desde el terminal, esto es muy conveniente en casos cuando se tienen que crear muchos dominios de forma rápida, para ello se puede crear un script de bash donde se puede automatizar la creación de los dominios.

    <img src="images/109.png" width="750"/>

    <img src="images/108.png" width="750"/>

### Administración de dominios

Las opciones que ofrece Plesk a la hora de administrar los dominios son las siguientes:

- __Bases de datos:__ en cada dominio se pueden crear y administrar las bases de datos que crearemos para la instalación de aplicaciones en los dominios y subdominios, por ejemplo cuando instalemos en el dominio un sitio WordPress este automáticamente creará una base de datos donde guardará todas las tablas de WordPress.

    <img src="images/111.png" width="350"/>

    <img src="images/110.png" width="420"/>


- __Backup y restauración:__ podemos administrar y crear copias de seguridad para garantizar la seguridad de los dominios y subdominios para los clientes. En caso de que ocurra algún problema con el dominio, por error de configuración o otra cosa, este se puede restaurar a una versión anterior a los cambios gracias a la copia de seguridad. Por lo que es importante programar las copias de seguridad para que se hagan por lo menos semanalmente y también tenemos que tener en cuenta el espacio que ocupan estas copias, así que sería recomendable guardarlas en un dispositivo externo o crear un servidor específicamente para guardar las copias de seguridad.

    <img src="images/112.png" width="500"/>

- __Certificados SSL:__ para mejorar la seguridad de los dominios debemos protegerlos con Certificados SSL, ya sean gratuitos o de pago, aunque la mejor opción es siempre la gratuita. 

    <img src="images/114.png" width="350"/>

    En mi caso al no tener un dominio comprado propio, he optado por registrar un dominio de host en NoIP ya que ofrece el registro de un nombre de host de forma gratuita al crear una cuenta.

    <img src="images/115.png" width="500"/>

    A la hora de no tener un dominio propio esto limita bastante a la hora de emitir certificados SSL para el dominio y los subdominios de este.

    En definitiva, al menos con el dominio gratuito de ofrece NoIP se puede proteger el dominio registrado aunque no se puedan proteger ni el webmail ni los subdominios de este.

    <img src="images/117.png" width="350"/>
    <img src="images/118.png" width="350"/>
    <img src="images/119.png" width="350"/>


- __ImunifyAV:__ la herramienta de ImunifyAV está presente en todos los dominios y subdominios de Plesk, esta aplicación nos garantiza mantener nuestro dominios libres de Malware.

    <img src="images/121.png" width="420"/>
    <img src="images/122.png" width="500"/>

- __Configuración de PHP:__ dentro de las opciones del dominio que ofrece Ples también podemos configurar las opciones de PHP de forma gráfica, por ejemplo la versión de PHP que queremos usar dependiendo de nuestras necesidades.

    <img src="images/123.png" width="500"/>

	O podemos administrar las opciones de seguridad de PHP y cambiarlas según
	las necesidades de cada dominio.

    <img src="images/124.png" width="420"/>

- __Registros:__ en este apartado se recopilan todos los datos relacionados con el dominio, desde los errores hasta quien ha accedido al dominio.

    <img src="images/125.png" width="500"/>

- __Monitoring:__ con esta opción podemos usar la aplicación que ofrece Plesk para el monitoreo externo de los dominios del servidor de Plesk, para usar la aplicación tenemos que registrarnos en la aplicación llamada 360 Monitoring.

	Una vez nos hayamos registrado en 360 Monitoring podemos conectar nuestra
	cuenta con los servidores de Plesk y activar el monitoreo para los dominios.

	Lo bueno 360 Monitoring es que podemos vincular varios servidores de hosting 
	para monitorearlos, junto a los dominios y subdominios de cada uno.

    <img src="images/134.png" width="500"/>
    <img src="images/135.png" width="460"/>

- __Instalar aplicaciones:__ Plesk de base nos ofrece una serie de aplicaciones preconfiguradas para instalar en los dominios, como WordPress o Prestashop

    <img src="images/136.png" width="460"/>
    <img src="images/137.png" width="460"/>

    También se pueden instalar otras aplicaciones externas cargando el contenido de la aplicación en el administrador de archivos del dominio.

    <img src="images/144.png" width="500"/>

## 5. Gestión de correo

Los dominios que gestionemos de nuestros clientes aparte de tener sus diferentes dominios y subdominios, también necesitarán sus propias cuentas de correo, por lo que dentro de cada dominio iremos al apartado de “Correo” y creamos las cuentas de correo necesarias para el cliente.

<img src="images/147.png" width="750"/>

Para crear la cuenta es muy fácil, simplemente le asignamos un nombre a la cuenta de correo y una contraseña.

<img src="images/148.png" width="750"/>
<img src="images/149.png" width="500"/>

### Importación de correo

Lo primero que necesitamos es saber los datos de la cuenta de correo a importar, como la dirección de correo, la contraseña, el servidor IMAP y SMTP, el puerto que usa y el cifrado que usa. Para saber estos datos tendremos que ir al servidor donde se encuentra la cuenta de correo a importar y ver los datos de la configuración manual de la cuenta.

<img src="images/158.png" width="350"/>
<img src="images/168.png" width="350"/>
<img src="images/169.png" width="350"/>


Después de introducir los datos del host de origen y sean correctos, la cuenta se sincronizará con el servidor de origen.

<img src="images/170.png" width="500"/>

## 6. Gestión de usuarios y roles

Plesk ofrece la opción de crear distintos usuarios dentro del servidor, esto se puede para dar acceso a nuestros clientes al servidor para que gestionen sus propios dominios, subdominios y cuentas de correo.

Antes de crear cuentas de usuarios tenemos que crear nuevos roles de usuario o usar los que dan ya por defecto el propio Plesk.

<img src="images/171.png" width="350"/>

Hay que tener en cuenta que los clientes no tienen que tener demasiados permisos a la hora de poder gestionar sus dominios. El rol que crearemos para los clientes será el siguiente.

<img src="images/172.png" width="350"/>
<img src="images/173.png" width="350"/>

Ahora crearemos un nuevo usuario y le asignaremos el rol que acabamos de crear.

<img src="images/174.png" width="350"/>
<img src="images/175.png" width="500"/>

Una vez creado el usuario vamos a tratar de acceder al servidor con el usuario que hemos creado y ver que se han aplicado los permisos del
rol de usuario.

<img src="images/176.png" width="350"/>

Como se puede ver dicho usuario tiene un acceso limitado a la hora de gestionar los dominios.

<img src="images/177.png" width="500"/>

## 7. Extensiones de Plesk

Plesk ofrece una gran cantidad de extensiones de seguridad, DNS, copias de seguridad, desarrollo web, etc.

Algunas de las extensiones más interesantes de Plesk son:

- Acronis Backup: es una herramienta de copias de seguridad de pago, aunque ofrece una prueba gratuita.

    <img src="images/181.png" width="500"/>

    Al habilitarse los backups dentro del servidor, podremos acceder a nuestra 
	cuenta de Acronis para ver los dispositivos vinculados a la cuenta, además
	desde Plesk podremos ver la configuración asignada en el servidor.

    <img src="images/188.png" width="750"/>
    <img src="images/189.png" width="500"/>

- Google PageSpeed Insights: extensión de Google que nos da una puntuación en base a la seguridad de nuestra página y a la rapidez de esta.

    <img src="images/190.png" width="650"/>

- SEO Toolkit: herramienta de posicionamiento web para que las páginas que alojamos en nuestros paneles salgan las primeras en el buscador cuando se busque algo relacionado.

    <img src="images/194.png" width="500"/>

	Esta extensión nos permite asignar una serie de palabras clave relacionadas
	con nuestras páginas para que tenga un mejor posicionamiento en los 
	buscadores

    <img src="images/195.png" width="720"/>