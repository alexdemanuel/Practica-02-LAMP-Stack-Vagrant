#!/bin/bash
apt-get update
#instalacion Apache HTTP Server
apt-get install -y apache2
apt-get install -y php libapache2-mod-php php-mysql
cp /vagrant/index.php /var/www/html

#instalo las utilidadesde debconf
apt-get install -y debconf-utils

#seleccionamos la contraseña para root
DB_ROOT_PASSWD=123456
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"
#instalamos mysql
apt-get install -y mysql-server

#Clonar repositorio de la apicacion web
apt-get install -y git
cd /tmp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

#movemos los archivos web del repositorio a la carpeta html para que la muestre al web y le cambiamos los permisos
cp /tmp/iaw-practica-lamp/src/. /var/www/html -R

#entramos a la carpeta de la web y le cambiamos los permisos
cd /var/www/html 
chown www-data:www-data * -R

#Eliminamos el index.html para que nos muestre el index.php
rm /var/www/html/index.html 

#Ejecutar script que hay dentro de db
cd /tmp/iaw-practica-lamp/db
mysql -u root -p$DB_ROOT_PASSWD < database.sql #esto es para entrar a mysql la variable esta especificada arriba