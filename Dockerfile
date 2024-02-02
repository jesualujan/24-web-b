# Para crear una imagen de NODEJS debemos crear un archivo Dockerfile
# Este Dockerfile se utiliza para construir una imagen de Docker (Docker Image)
# ejecutará una aplicación NODEJS 

# FROM: Establece la imagen base para la construcción de la imagen de Docker
# para este ejemplo vamos a utilizar la versión 15 como base 
FROM node:15

# WORKDIR: Establece el directorio de trabajo dentro del contenedor como /app, todo lo que se copie en la imagen de Docker se almacenará en este directorio
WORKDIR /app

# COPY: copia el archivo package.json y package-lock.json a la imagen de Docker 
COPY package.json .

# Instala las dependencias de la aplicación Node.js en el contenedor. 
# Utiliza el archivo package.json copiado previamente para determinar qué paquetes instalar.
RUN npm install

# Copia todos los archivos y directorios desde el directorio de contrucción local
# al directorio de trabajo en el contenedor 
# Esto incluirá la aplicacón NODEJS y todos los archivos que se necesiten para ejecutar la aplicación
COPY . ./

# Variables de entorno
ENV PORT 3000
EXPOSE $PORT

# Establece el comando predeterminado a ejecutar cuando se inicia el contenedor
CMD ["npm" ,"run", "dev"]