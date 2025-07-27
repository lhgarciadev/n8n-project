# n8n-project

Este proyecto proporciona una configuración lista para usar y desplegar una instancia de n8n junto con una base de datos PostgreSQL, utilizando Docker y Docker Compose. La gestión del ciclo de vida del entorno está completamente automatizada a través de un `Makefile`.

## Opciones de Despliegue

Puedes desplegar este proyecto de dos maneras:

1.  **Manualmente**: Siguiendo los pasos detallados a continuación.
2.  **Con Makefile**: Utilizando los comandos predefinidos en el `Makefile` para una gestión automatizada.

---

## Despliegue Manual

### Prerrequisitos

-   [Docker](https://docs.docker.com/get-docker/)
-   [Docker Compose](https://docs.docker.com/compose/install/)

### Configuración

1.  **Crear el directorio para archivos locales:**
    El `docker-compose.yml` está configurado para montar un volumen local desde el directorio `local-files/`. Crea este directorio si no existe:
    ```bash
    mkdir -p local-files
    ```

2.  **Configurar el archivo de entorno:**
    Copia el archivo `example.env` a `.env`:
    ```bash
    cp example.env .env
    ```
    Abre el archivo `.env` y modifica los valores según tus necesidades. Es **crucial** que te asegures de que las contraseñas (`POSTGRES_PASSWORD`, `N8N_BASIC_AUTH_PASSWORD`) y la clave de encriptación (`N8N_ENCRYPTION_KEY`) sean seguras.

### Despliegue

1.  **Inicia los servicios:**
    Abre una terminal en la raíz del proyecto y ejecuta el siguiente comando:

    ```bash
    docker-compose up -d
    ```

    Esto descargará las imágenes necesarias y creará e iniciará los contenedores en segundo plano.

2.  **Accede a n8n:**
    Una vez que los contenedores estén en funcionamiento, puedes acceder a la interfaz de n8n abriendo tu navegador y visitando [http://localhost:5678](http://localhost:5678).

    Se te pedirá el usuario y la contraseña que definiste en las variables `N8N_BASIC_AUTH_USER` y `N8N_BASIC_AUTH_PASSWORD`.

### Gestión de Archivos Locales

El directorio `local-files/` en este proyecto está montado dentro del contenedor de n8n en la ruta `/home/node/local-files`. Puedes usar este directorio para:

-   Leer archivos en tus flujos de trabajo (por ejemplo, leer un archivo CSV).
-   Escribir archivos generados por tus flujos de trabajo.

### Detener el entorno

Para detener y eliminar los contenedores, redes y volúmenes creados, ejecuta:

```bash
docker-compose down -v
```

---

## Despliegue con Makefile

### Prerrequisitos

-   [Docker](https://docs.docker.com/get-docker/)
-   [Docker Compose](https://docs.docker.com/compose/install/)
-   [Make](https://www.gnu.org/software/make/)

### Comandos de Makefile

El `Makefile` simplifica la gestión del entorno. Puedes ver todos los comandos disponibles ejecutando `make help`.

-   `make help`: Muestra este mensaje de ayuda.
-   `make setup`: Prepara el entorno inicial (crea `local-files/` y `.env`).
-   `make up`: Inicia los servicios en segundo plano (ejecuta `setup` si es necesario).
-   `make down`: Detiene los servicios y elimina los volúmenes.
-   `make stop`: Detiene los servicios.
-   `make start`: Inicia los servicios.
-   `make restart`: Reinicia los servicios.
-   `make logs`: Muestra los logs de los contenedores en tiempo real.
-   `make inspect`: Inspecciona el contenedor.
-   `make ip`: Muestra la IP y el puerto del contenedor.
-   `make clean`: **(Acción destructiva)** Detiene y elimina todos los contenedores, redes, volúmenes de Docker y el directorio `local-files`.
