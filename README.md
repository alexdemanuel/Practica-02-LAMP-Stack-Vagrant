# Practica-02-LAMP-Stack-Vagrant
# Creacion de la maquina con vagrant
 - Inicializamos vagrant que nos creara un archiva vagrantfile
 ```
 vagrant init
 ```
- Accedemos al archivo vagrantfile y ponemos lo siguiente en su interior
```
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64" #Sistema que vamos a utilizar
  config.vm.network "private_network", ip: "192.168.33.10" #Direccion IP y tipo de red
  config.vm.provision "shell", path: "script.sh" #Las utilidades que se van a instalar por defecto en la maquina     
end
```
# Creacion de archivo script.sh 
 **Donde meteremos los comandos para instalar las utilidades que necesitemos**

- Actualizamos los repositorios
```
apt-get update
```
- Instalacion Apache HTTP Server
```
apt-get install -y apache2
apt-get install -y php libapache2-mod-php php-mysql
cp /vagrant/index.php /var/www/html

```

- Instalamos las utilidadesde debconf
```
apt-get install -y debconf-utils
```
- Asignamos una contraseña al usuario root de MYSQL
```
DB_ROOT_PASSWD=password
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"
```

- Instalamos MYSQL
```
apt-get install -y mysql-server
```
- Clonar repositorio de la apicacion web
```
apt-get install -y git
cd /tmp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
```
- Eliminamos el index.html para que nos muestre el index.php
```
rm /var/www/html/index.html 
```
- movemos los archivos web del repositorio a la carpeta html para que la muestre al web y le cambiamos los permisos
```
cp /tmp/iaw-practica-lamp/src/. /var/www/html -R 
chown www-data:www-data * -R
```
- Eliminamos el index.html para que nos muestre el index.php
```
rm /var/www/html/index.html 
```
- Ejecutar script que hay dentro de db
```
cd /tmp/iaw-practica-lamp/db
mysql -u root -p$DB_ROOT_PASSWD < database.sql 
```
**$DB_ROOT_PASSW es para entrar a mysql la variable esta especificada arriba donde se indica cual sera la contraseña del usuario root**
