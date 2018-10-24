# Practica-02-LAMP-Stack-Vagrant

>IES Celia Viñas (Almería) - Curso 2018/2019  
>Módulo: IAW - Implantación de Aplicaciones Web  
>Ciclo: CFGS Administración de Sistemas Informáticos en Red  
>Alumno: Alejandro De Manuel Olmedo

# Creación de la máquina con vagrant

- Inicializamos vagrant que nos creara un archivo `Vagrantfile`.

```
 vagrant init
 ```

- Accedemos al archivo `Vagrantfile` y ponemos lo siguiente en su interior:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64" #Sistema que vamos a utilizar
  config.vm.network "private_network", ip: "192.168.33.10" #Direccion IP y tipo de red
  config.vm.provision "shell", path: "script.sh" #Las utilidades que se van a instalar por defecto en la maquina     
end
```

# Creación del archivo `script.sh` para hacer el *provision*

**Donde meteremos los comandos para instalar las utilidades que necesitemos**

- Actualizamos los repositorios.
```bash
apt-get update
```

- Instalación Apache HTTP Server.
```bash
apt-get install -y apache2
apt-get install -y php libapache2-mod-php php-mysql
cp /vagrant/index.php /var/www/html
```

- Instalamos las utilidadesde debconf.
```bash
apt-get install -y debconf-utils
```

- Asignamos una contraseña al usuario root de MySQL.
```bash
DB_ROOT_PASSWD=password
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"
```

- Instalamos MySQL.
```bash
apt-get install -y mysql-server
```

- Clonar repositorio de la apicación web que queremos instalar.
```bash
apt-get install -y git
cd /tmp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
```

- Eliminamos el `index.html` para que nos muestre el `index.php`.
```bash
rm /var/www/html/index.html 
```

- Movemos los archivos web del repositorio a la carpeta html para que la muestre al web y le cambiamos los permisos.
```bash
cp /tmp/iaw-practica-lamp/src/. /var/www/html -R 
chown www-data:www-data * -R
```

- Ejecutar script de SQL que hay dentro del directorio `db`.
```bash
cd /tmp/iaw-practica-lamp/db
mysql -u root -p$DB_ROOT_PASSWD < database.sql 
```

**$DB_ROOT_PASSW es una variable que se utiliza para entrar a MySQL. La variable esta especificada arriba donde se indica cual sera la contraseña del usuario root**
