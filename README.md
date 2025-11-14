A. Comandos en el HOST (Git Bash, Windows)

# 1. Ir a la carpeta del proyecto
cd "/c/uao/2025-6B/Sistemas Operativos/Entrega Proyecto Parte 1/VagrantVM/proyecto_vm"

# 2. Ver que estás en la carpeta correcta
pwd
ls

# 3. Mostrar versiones (rúbrica: entorno listo)
vagrant --version
"/c/Program Files/Oracle/VirtualBox/VBoxManage.exe" --version

# 4. (Opcional, si quieres mostrar recreación) destruir VM
vagrant destroy -f

# 5. Levantar la VM
vagrant up

# 6. Verificar que está corriendo
vagrant status

# 7. Entrar a la VM
vagrant ssh

B. Dentro de la VM – Información básica
# 1. Ver hostname
hostname

# 2. Ver interfaces de red
ip a

# (Puedes buscar la IP 192.168.56.30 en alguna interfaz host-only)

C. Usuarios y grupo app-users

# 1. Ver info de los usuarios
getent passwd admin tester appuser

# 2. Ver el grupo app-users y sus miembros
getent group app-users

# 3. Ver grupos de cada usuario
groups admin
groups tester
groups appuser

D. Carpeta /data y permisos

# 1. Ver permisos y dueño de /data
ls -ld /data 
# Salida esperada : drwxr-x--- 1 admin app-users ... /data

# 2. Como admin (debe poder escribir)
su - admin
cd /data
touch prueba_admin.txt
ls -l
exit

# 3. Como tester (solo lectura/ejecución, el touch IDEALMENTE debe fallar)
su - tester
cd /data
ls -l
touch prueba_tester.txt
exit

# 4. Como appuser (igual que tester)
su - appuser
cd /data
ls -l
touch prueba_appuser.txt
exit

# E. Instalación y prueba de Nginx, Prometheus y Grafana
# Todo esto es dentro de la VM como usuario vagrant (o con sudo).

# 1. Actualizar sistema

sudo apt update
sudo apt upgrade -y    # opcional pero queda bien en el video

# 2. Instalar Nginx

sudo apt install -y nginx

# Ver estado
sudo systemctl status nginx

# Prueba desde la VM
curl http://localhost

# En el host (fuera de la VM, en el navegador):

# Abre: http://192.168.56.30
# → muestra página por defecto de Nginx.

# 3. Instalar Prometheus

sudo apt install -y prometheus prometheus-node-exporter prometheus-pushgateway prometheus-alertmanager

# Ver estado del servicio principal
sudo systemctl status prometheus

# Prueba rápida
curl http://localhost:9090

# En el host, navegador (chrome)
Abre: http://192.168.56.30:9090

# 4. Instalar Grafana
# Paquetes necesarios
sudo apt install -y apt-transport-https software-properties-common wget

# Agregar llave GPG y repositorio
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# Actualizar e instalar Grafana
sudo apt update
sudo apt install -y grafana

# Habilitar y arrancar servicio
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Ver estado
sudo systemctl status grafana-server


# En el host, navegador:

Abre: http://192.168.56.30:3000
Usuario/clave inicial: admin / admin (puedes mostrar el login aunque no cambies la contraseña en el video para ahorrar tiempo).

# F. Configuración SSH con llaves (3 usuarios)
# 1. Comprobar que la clave pública está en la VM (Todavía dentro de la VM:)

ls

# Deberías ver: id_rsa.pub

# 2. Crear .ssh y authorized_keys para cada usuario

# Para admin
sudo mkdir -p /home/admin/.ssh
sudo cp /home/vagrant/id_rsa.pub /home/admin/.ssh/authorized_keys
sudo chown -R admin:admin /home/admin/.ssh
sudo chmod 700 /home/admin/.ssh
sudo chmod 600 /home/admin/.ssh/authorized_keys

# Para tester
sudo mkdir -p /home/tester/.ssh
sudo cp /home/vagrant/id_rsa.pub /home/tester/.ssh/authorized_keys
sudo chown -R tester:tester /home/tester/.ssh
sudo chmod 700 /home/tester/.ssh
sudo chmod 600 /home/tester/.ssh/authorized_keys

# Para appuser
sudo mkdir -p /home/appuser/.ssh
sudo cp /home/vagrant/id_rsa.pub /home/appuser/.ssh/authorized_keys
sudo chown -R appuser:appuser /home/appuser/.ssh
sudo chmod 700 /home/appuser/.ssh
sudo chmod 600 /home/appuser/.ssh/authorized_keys


# Opcional, para mostrar en el video:

ls -R /home/admin/.ssh
ls -R /home/tester/.ssh
ls -R /home/appuser/.ssh

# G. Probar SSH desde el HOST para cada usuario
# Sal de la VM:

exit

# Ya en Git Bash, en la carpeta del proyecto:

cd "/c/uao/2025-6B/Sistemas Operativos/Entrega Proyecto Parte 1/VagrantVM/proyecto_vm"

# 1. Como admin
ssh -i ssh_keys/id_rsa admin@192.168.56.30
whoami
pwd
exit

# 2. Como tester
ssh -i ssh_keys/id_rsa tester@192.168.56.30
whoami
exit

# 3. Como appuser
ssh -i ssh_keys/id_rsa appuser@192.168.56.30
whoami
exit