# Creamos la imagen para el contenedor de Docker
docker build .

docker image ls

#  El comando de Docker docker build -t node-app-image .
# se utiliza para construir una imagen de Docker a partir de un contexto de construcción
#  (normalmente un directorio que contiene un Dockerfile).
#  Aquí está el significado de cada parte del comando:  
# La opción -t se utiliza para asignar un nombre y, opcionalmente, 
# una etiqueta a la imagen que se está construyendo. 

docker build -t node-app-image .
docker image ls (vemos la imagen que hemos creado)

# para asegurarnos que todo funcion hacemos lo siguiente:
--name node app -> es para el contenedor
-d  -> estás indicando a Docker que ejecute la construcción de la imagen en segundo plano 
    docker run -d --name node-app node-app-image

docker ps

# después vamos a http://localhost:3000/ pero veremos que no funciona 
# esto pasa porque no podemos hablar con el contenedor directamente
# el contenedor no tiene comunicación con los dispositivos externos

primero detenemos el contenedor
  docker stopt id
  docker ps (vemos que no hay ningún contenedor ejecutandose)
  hacemos: docker rm node-app -f (kill the container) -f (force)
  docker ps (vacío)

# AHORA HAREMOS QUE EL CONTENEDOR SE COMUNIQUE A TRAVÉS DE LOS PUERTOS
# usamos el 3000 xk express usa ese puerto
  # (puerto 1 de la máquina) ; (puerto 2 es del contenedor).
 docker run -p3000:3000 -d --name node-app node-app-image

 # NO LO CAMBIES:

 const express = require('express')
const app = express()

// REQUEST
app.get('/', (req , res) => {
	res.send('<h2> FUNCIONA 💻</h2>')
})

const port = process.env.PORT || 3000

app.listen (port, () => 
 console.log('server listening on port: ', `http://localhost:${port}`)
 )


# EJECUTAMOS EL COMANDO:
  docker run -p3000:3000 -d --name node-app node-app-image
  docker ps

  # El comando docker exec -it node-app bash te permite ingresar al terminal 
  # interactivo del contenedor llamado "node-app" utilizando el shell Bash. 
  # Esto puede ser útil para realizar tareas de mantenimiento, 
  # ejecutar comandos adicionales o depurar dentro del entorno del contenedor.

     docker exec -it node-app bash
     ls

# DESPUÉS ELIMINAMOS EL CONTENEDOR: 
 docker rm node-app -f
  explicar lo del node_modules se copiará a nuestro contenedor.

# crear nuestro .dockerignore
node_modules
Dockerfile
.dockerignore
.git
.gitignore

# RECONSTRUIMOS LA IMAGEN 
   docker build -t node-app-image .
# CONSTRUIMOS EL CONTENEDOR
   docker run -p3000:3000 -d --name node-app node-app-image
   docker ps
   docker exec -it node-app bash (para salirnos solo ponemos exit)
   ls

# SUPONGAMOS QUE HACEMOS UN CAMBIO AL CÓDIGO CAMBIAMOS EL CÓDIGO


# TENDRIAMOS QUE RECONSTRUIR LA IMAGEN Y CREAR UN NUEVO CONTENEDOR
   docker exec -it node-app bash 
   ls
   cat index.js
   exit

# HACEMOS LO SIGUIENTE:
 docker rm node-app -f
 docker build -t node-app-image .
 docker run -p3000:3000 -d --name node-app node-app-image
 docker ps

 # VAMOS AL NAVEGADOR Y VEMOS EL CAMBIO DEL CÓDIGO

# VOLUMES DE DOCKER 
https://aws.plainenglish.io/the-ultimate-guide-to-docker-volumes-812498a4d996
  Qué son los volúmenes en Docker? 🤔️:
  Los contenedores Docker son efímeros. 
  Eso significa que los contenedores duran poco tiempo. 
  Los contenedores son muy flexibles. 
  Pueden ser fácilmente creados, eliminados y escalados según las necesidades. 
  Pero ¿qué pasa si tu aplicación necesita almacenar algunos datos? 
  ¿Y si el contenedor se elimina o, peor aún, se bloquea? 
  ¿Serás capaz de recuperar tus datos? 
  La respuesta es ¡NO! Los datos dentro del contenedor se pierden 
  si se elimina o se vuelve a crear.

  Mientras que la naturaleza flexible y efímera de Docker hace que sea fácil de escalar, 
  también crea un problema para la persistencia de datos. 
  Para resolver este problema de persistencia de datos los volúmenes docker vienen al rescate.


# ELIMINAR CONTENEDOR:

    docker rm node-app -f

# le pasamos el flag de volumes

  docker run -v pathfolderonlocation:pathfolderoncontainer -p3000:3000 -d --name node-app node-app-image

 docker run -v C:\Users\jesua\OneDrive\Escritorio\NODE-DOCKER\:/app -p3000:3000 -d --name node-app node-app-image

 # usuarios windows
cmd:         %cd%
powershell: ${pwd}

 # usuarios linux,mac:
 $(pwd):

 # QUEDARÍA ASÍ USANDO POWERSHELL SOLO HAY QUE USAR LA TERMINAL ADECUADA:
 docker run -v ${pwd}:/app -p3000:3000 -d --name node-app node-app-image
 docker ps

 # vamos al código y hacemos un cambio

 vamos a la terminal y hacemos lo siguiente
  docker exec -it node-app bash 
   cat index.js
   exit

# esto pasa xk cada que hacemos un cambio debemos iniciar el servidor de express
 entonces vamos a instalar nodemon 
  npm i nodemon --save-dev
   "start": "node index.js",
    "dev": "nodemon -L index.js"  quitamos el comando de test
    CMD [ "npm", "run" , "dev" ]

  Esta opción se utiliza para habilitar la funcionalidad de "Legacy Watch". 
  En algunos entornos, puede ser necesario habilitar esta opción
  para asegurarse de que nodemon detecte correctamente los cambios en los archivos.

docker rm node-app -f
docker build -t node-app-image .




# ELIMINAR CONTENEDOR
docker rm node-app -f
# ELIMINAR node_modules de mi maquina local
# reploy del contenedor:
 docker run -v ${pwd}:/app -p3000:3000 -d --name node-app node-app-image
 docker ps
 docker ps -a
 docker logs node-app

 # CREAMOS UN NUEVO VOLUMEN utilizamos un volumen anonimo:
  docker rm node-app -f
  docker run -v ${pwd}:/app -v /app/node_modules -p3000:3000 -d --name node-app node-app-image
  docker ps

  # después vamos al Dockerfile: quitamos el puerto

FROM node:15
WORKDIR /app
COPY package.json .
RUN npm install
COPY . ./      
EXPOSE 3000
CMD [ "npm", "run" , "dev" ]

FROM node:15
WORKDIR /app
COPY package.json .
RUN npm install
COPY . ./      
CMD [ "npm", "run" , "dev" ]

# vamos hablar un poco sobre que cualquiera puede ver nuestros archivos
# de docker pero debemos evitar que hagan modificaciones
 docker exec -it node-app bash
 creamos archicos como touch mytest touch myfile

# Después 
 kill the container:
 docker rm node-app -f

 # NOTA AGREGAMOS 
  :ro sirve para que el contenido del directorio en el contenedor no se pueda modificiar
  desde el contenedor.Es útil cuando se desea proporcionar solo lectura y acceso a ciertos
  archivos o directorios. 

   docker run -v ${pwd}:/app:ro -v /app/node_modules -p3000:3000 -d --name node-app node-app-
   docker exec -it node-app bash
   touch myNewTest
   touch: cannot touch 'mytest': Read-only file system

   # nota eliminar los archivos
   touch mytest touch myfile

# vamos al Dockerfile:
#VARIABLES DE ENTORNO
ENV PORT 3000
EXPOSE $PORT

# kill the container:
 docker rm node-app -f
# Reconstruir la imagen:
 docker build -t node-app-image .
# Deploy the container variables de entorno

 # LO PODEMOS HACER DE DOS FORMAS:

docker run -v ${pwd}:/app:ro -v /app/node_modules -e PORT=4000 -p3000:3000 -d --name node-app node-app-image

# ejecutamos este:
docker run -v ${pwd}:/app:ro -v /app/node_modules --env PORT=4000 -p3000:4000 -d --name node-app node-app-image

# hacemos un cambio en el código y hacemos refresh

docker ps
docker exec -it node-app bash
printenv


# AHORA PODEMOS TENER MUCHAS VARIABLES DE ENTORNO 
 crear .env en la carpeta raíz PORT=4000
 # kill the container:
 docker rm node-app -f

# ENVIOROMENT FILE:
docker run -v ${pwd}:/app:ro -v /app/node_modules --env-file ./.env -p3000:4000 -d --name node-app node-app-image
docker ps
docker exec -it node-app bash
printenv
docker ps (vemos un contenedor corriendo)
docker volume ls

# hay dos formas de eliminar un volumen
docker volume rm id o

docker volume prune   <- elimina los volumenes inecesarios.
damos y
docker volume ls
docker rm node-app -fv
docker ps
docker volume ls

# DOCKER COMPOSE: 
Docker Compose es una herramienta que te permite definir y gestionar aplicaciones multi-contenedor. 
Con Docker Compose, puedes describir toda la configuración de tu aplicación, 
incluyendo servicios, redes, volúmenes y demás, en un archivo llamado docker-compose.yml. 
Luego, puedes usar ese archivo para crear y gestionar todos los servicios definidos 
con un solo comando.

https://docs.docker.com/get-started/08_using_compose/#create-the-compose-file

creamos nuestro: docker-compose.yml

version: "3"
services: 
  node-app:
  postgres:
  mongo:
    build: .
    ports:
      - "3000:3000"
      - "4000:4000"
    volumes:
      - ./:/app
      - /app/node_modules #pequeño hack para no subir node_modules
    environment:
      - PORT=3000
    # env_file:
    #   -./.env

  # en la terminal ponemos:
   docker-compose up --help
   docker-compose up -d
   docker image ls
   docker ps


  # hacemos un cambio al código:
  docker-compose down -v  (elimina los volumnes anonimos)
  docker ps
  docker-compose up -d
  docker-compose down -v

  # hacemos un cambio de puerto en el Dockerfile

  # luego:
   docker-compose up -d
   docker image ls

   # debemos decirle a docker que hicimos un cambio y debemos reconstruir la imagen

  docker-compose down -v
  docker-compose up --help
  docker-compose up -d --build

  # Reegresar al puerto 3000 para no romper la app


  docker-compose down -v
  docker-compose up -d --build