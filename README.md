# Proyecto final – Segunda y tercera parte

_Sistemas Operativos_

Este archivo describe cómo ejecutar la **segunda parte del proyecto final de Sistemas Operativos** usando el código de este repositorio.

El objetivo es crear un entorno de pruebas con **Vagrant + Ansible** que levante dos máquinas virtuales Linux:

- `web`: servidor web con **Nginx**.
- `monitoring`: servidor de monitoreo con **Prometheus** y **Grafana**.

Todo el aprovisionamiento se realiza de forma automática al ejecutar `vagrant up`.

---

## 1. Requisitos previos

En la máquina **host** (Windows, Linux o macOS) se requiere:

- VirtualBox  
- Vagrant  
- Git (para clonar este repositorio)

> **Nota:** No es necesario instalar Ansible en el host. Se usa el provisioner `ansible_local`, que instala Ansible dentro de cada máquina virtual.

Para comprobar versiones (opcional):

```bash
vagrant --version
VBoxManage --version   # en Windows
```

---

## 2. Clonar el repositorio

En la consola de tu preferencia (Git Bash / PowerShell / terminal):

```bash
git clone https://github.com/javieralbauao/proyecto.git
cd proyecto
```

Al entrar a la carpeta deberías ver algo como:

- `.vagrant/` (se crea o rellena cuando se levanten las VMs)
- `files/`
- `ssh_keys/`
- `README.md`
- `Vagrantfile`
- `inventory`
- `playbook.yml`
- `prueba_admin.txt`
- `setup.sh`
- `site.yml`

Los archivos importantes para **la segunda parte del proyecto** son principalmente:

- `Vagrantfile`
- `site.yml`
- Carpeta `files/` (contiene el `index.html` personalizado del servidor web)

`playbook.yml`, `setup.sh`, `inventory`, `ssh_keys` y `prueba_admin.txt` pertenecen al **Lab 6 / primera parte** y se mantienen como referencia histórica.

---

## 3. Descripción de la arquitectura

El `Vagrantfile` define **dos máquinas virtuales**:

### VM `web`

- Box base: `minimal/xenial64`
- Hostname: `web`
- IP de red privada: `192.168.56.10`
- Puertos redirigidos:
  - `host: 8080 → guest: 80` (Nginx)
- Memoria: 1024 MB
- Provisioners:
  - `shell`: instala Ansible en la VM.
  - `ansible_local` con `site.yml` y tag `web`.

### VM `monitoring`

- Box base: `minimal/xenial64`
- Hostname: `monitoring`
- IP de red privada: `192.168.56.11`
- Puertos redirigidos:
  - `host: 9090 → guest: 9090` (Prometheus)
  - `host: 3000 → guest: 3000` (Grafana)
- Memoria: 2048 MB
- Provisioners:
  - `shell`: instala Ansible en la VM.
  - `ansible_local` con `site.yml` y tag `monitoring`.

El playbook `site.yml` contiene:

- Tareas con tag `web` → instalación y configuración de **Nginx** + copia de `index.html`.
- Tareas con tag `monitoring` → instalación y configuración de **Prometheus** y **Grafana**.

---

## 4. Levantar el entorno del proyecto

Desde la carpeta del repositorio:

```bash
# Levantar las dos máquinas
vagrant up
```

Esto hará:

1. Crear/arrancar las VMs `web` y `monitoring`.
2. Instalar Ansible dentro de cada VM (provisioner `shell`).
3. Ejecutar el playbook `site.yml` mediante `ansible_local`:
   - En `web` solo las tareas con tag `web`.
   - En `monitoring` solo las tareas con tag `monitoring`.

Para verificar el estado de las máquinas:

```bash
vagrant status
```

Si alguna vez quieres apagar las VMs:

```bash
vagrant halt
```

Y para destruirlas completamente (reiniciar todo desde cero):

```bash
vagrant destroy -f
```

> **Posible problema de puertos:**  
> Si en tu host ya hay algo usando los puertos `8080`, `9090` o `3000`, Vagrant mostrará un error de “port collision”. En ese caso, edita el `Vagrantfile` y cambia el valor `host:` por un puerto libre (por ejemplo 8081, 9091, 3001).

---

## 5. Acceso a las máquinas virtuales

Para conectarte por SSH a cada VM:

```bash
# VM servidor web
vagrant ssh web

# VM de monitoreo
vagrant ssh monitoring
```

Dentro de la VM verás un prompt similar a:

```bash
vagrant@web:~$
vagrant@monitoring:~$
```

---

## 6. Pruebas desde el navegador (host)

Con las máquinas levantadas (`vagrant up`):

### 6.1 Servidor web (Nginx)

En el navegador de tu host:

```text
http://localhost:8080
```

Debería mostrarse la página `index.html` personalizada que se copia desde `files/...` al directorio `/var/www/html/index.html` de la VM `web`.

### 6.2 Prometheus

En el navegador:

```text
http://localhost:9090
```

Debería aparecer la interfaz de **Prometheus**, ejecutándose en la VM `monitoring`.

### 6.3 Grafana

En el navegador:

```text
http://localhost:3000
```

Se abre la interfaz de **Grafana**.  
Las credenciales por defecto suelen ser:

- Usuario: `admin`
- Contraseña: `admin` (puede pedir cambio en el primer inicio).

---

## 7. Comandos para el servidor web (Nginx)

Estas instrucciones se piden explícitamente en la rúbrica.  
Todos los comandos se ejecutan **dentro de la VM `web`**:

```bash
vagrant ssh web
```

### Ver estado del servicio

```bash
sudo systemctl status nginx
```

### Iniciar el servidor web

```bash
sudo systemctl start nginx
```

### Detener el servidor web

```bash
sudo systemctl stop nginx
```

### Reiniciar el servidor web

```bash
sudo systemctl restart nginx
```

Con esto se pueden tomar capturas de pantalla para demostrar:

- Cómo se consulta el estado.
- Cómo se inicia, se detiene y se reinicia el servicio del servidor web.

---

## 8. Notas sobre archivos del Lab 6 / primera parte

En este repositorio también se incluyen algunos archivos usados en el **Laboratorio 6** y en la primera parte del proyecto:

- `playbook.yml`  
  Playbook sencillo utilizado inicialmente para provisionar una sola máquina con Nginx y `cowsay`.

- `setup.sh`  
  Script de shell usado como provisionador en Vagrant (instalación de cowsay y Nginx).

- `inventory`, `ssh_keys/`, `prueba_admin.txt`  
  Archivos relacionados con prácticas previas (usuarios, claves SSH, pruebas de permisos, etc.).

Para la **segunda parte del proyecto**, el flujo recomendado es:

1. Clonar el repositorio.  
2. Entrar a la carpeta `proyecto`.  
3. Ejecutar `vagrant up`.  
4. Probar el servidor web y las herramientas de monitoreo desde el navegador como se describe en las secciones anteriores.

---

## 9. Cómo reproducir el proyecto para la evaluación

1. Clonar este repositorio.  
2. Entrar a la carpeta `proyecto`.  
3. Ejecutar `vagrant up`.  
4. Esperar a que se completen los provisionamientos de `web` y `monitoring`.  
5. Verificar:
   - `http://localhost:8080` → Nginx funcionando.  
   - `http://localhost:9090` → Prometheus disponible.  
   - `http://localhost:3000` → Grafana disponible.  
6. Usar los comandos de la sección 7 para mostrar cómo se controla el servicio Nginx.

## 10. Validación de monitoreo – Tercera parte del proyecto

En la **tercera parte del proyecto** se valida el monitoreo de la máquina virtual usando:

- Un **sitio web estático** desplegado en Nginx.
- **Prometheus** recopilando métricas (web y monitoring).
- Un **dashboard en Grafana** con visualización de:
  - Peticiones recibidas (tráfico).
  - Consumo de memoria.
  - Consumo de disco.

Toda la lógica sigue usando el mismo `Vagrantfile` y el mismo `site.yml` definidos en este repositorio.

### 10.1 Sitio web estático en Nginx

Los archivos del sitio estático se encuentran en:

- `files/index.html` → página principal personalizada.
- `files/img/uao.png` → imagen usada en el sitio.

Cuando se ejecuta:

```bash
vagrant up
# o
vagrant provision web
```

Ansible copia estos archivos a la VM `web` en:

- `/var/www/html/index.html`
- `/var/www/html/img/uao.png`

Para validar desde el host:

1. Asegúrate de que la VM `web` está arriba:

   ```bash
   vagrant status
   ```

2. Abre en el navegador de tu máquina host:

   ```text
   http://localhost:8080
   ```

3. Deberías ver **el sitio estático personalizado** (no la página por defecto de Nginx), incluyendo:
   - El contenido de `index.html`.
   - La imagen `uao.png`.

---

### 10.2 Verificación de métrica en Prometheus

En la VM `monitoring` se instalan:

- `prometheus`
- `prometheus-node-exporter`

Además, el archivo `files/prometheus.yml` se copia a `/etc/prometheus/prometheus.yml` y configura dos targets:

- `web-node` → `192.168.56.10:9100`
- `monitoring-node` → `localhost:9100`

Para validar desde el host:

1. Asegúrate de que la VM `monitoring` está arriba:

   ```bash
   vagrant status
   ```

2. Abre en el navegador:

   ```text
   http://localhost:9090
   ```

3. En la interfaz de Prometheus:

   - Ve a **Status → Targets**.
   - Deberías ver los jobs, por ejemplo:
     - `web-node` con `192.168.56.10:9100` en estado **UP**.
     - `monitoring-node` con `localhost:9100` en estado **UP**.

4. Puedes probar algunas consultas de ejemplo (en la pestaña **Graph**):

   - **Memoria disponible (bytes)**:

     ```promql
     node_memory_MemAvailable_bytes
     ```

   - **Uso de disco en `/` (tamaño total)**:

     ```promql
     node_filesystem_size_bytes{mountpoint="/", fstype=~"ext4|xfs"}
     ```

   - **Espacio libre en `/`**:

     ```promql
     node_filesystem_free_bytes{mountpoint="/", fstype=~"ext4|xfs"}
     ```

Usar estas consultas sirve para comprobar que Prometheus está recibiendo y almacenando métricas correctamente.

---

### 10.3 Configuración del dashboard en Grafana

Grafana está desplegado en la VM `monitoring` y se expone en el puerto 3000 del host.

1. En el navegador del host abre:

   ```text
   http://localhost:3000
   ```

2. Inicia sesión (por defecto):

   - Usuario: `admin`
   - Contraseña: `admin` (puede pedirte cambiarla la primera vez).

#### 10.3.1 Agregar Prometheus como origen de datos

1. En el menú izquierdo ve a **Configuration → Data sources → Add data source**.
2. Selecciona **Prometheus**.
3. En el campo **URL** escribe:

   ```text
   http://localhost:9090
   ```

4. Haz clic en **Save & test** y verifica que Grafana muestre **"Data source is working"**.

#### 10.3.2 Crear el dashboard con las métricas solicitadas

Crea un nuevo dashboard:

1. Menú izquierdo → **Dashboards → New → New dashboard**.
2. Añade paneles usando el origen de datos Prometheus.

A continuación se proponen 3 paneles para cumplir con la consigna de la tercera parte:

##### Panel 1: Peticiones recibidas (tráfico de red)

- **Título del panel:** `Peticiones recibidas (tráfico)`
- **Tipo de visualización:** `Time series` (línea).
- **Consulta PromQL de ejemplo:**

  ```promql
  rate(node_network_receive_bytes_total{instance="192.168.56.10:9100"}[5m])
  ```

Esto muestra el **tráfico de entrada** (bytes por segundo) hacia la VM `web`.

##### Panel 2: Consumo de memoria (%)

- **Título del panel:** `Uso de memoria (%)`
- **Tipo de visualización:** `Gauge` o `Time series`.
- **Consulta PromQL (porcentaje usado en la VM web):**

  ```promql
  (1 - (node_memory_MemAvailable_bytes{instance="192.168.56.10:9100"} 
        / node_memory_MemTotal_bytes{instance="192.168.56.10:9100"})) * 100
  ```

##### Panel 3: Consumo de disco en `/` (%)

- **Título del panel:** `Uso de disco en / (%)`
- **Tipo de visualización:** `Gauge` o `Bar gauge`.
- **Consulta PromQL:**

  ```promql
  (1 - (node_filesystem_free_bytes{instance="192.168.56.10:9100", mountpoint="/", fstype=~"ext4|xfs"}
        / node_filesystem_size_bytes{instance="192.168.56.10:9100", mountpoint="/", fstype=~"ext4|xfs"})) * 100
  ```

---

### 10.4 Qué mostrar en la documentación y el video

Para la **tercera parte**, puedes incluir:

- Captura del sitio estático en `http://localhost:8080`.
- Capturas de Prometheus:
  - Página de **Targets** con los endpoints `UP`.
  - Alguna consulta de ejemplo.
- Capturas de Grafana:
  - Data source Prometheus configurado.
  - Dashboard con los 3 paneles:
    - Peticiones/Tráfico.
    - Consumo de memoria.
    - Consumo de disco.

