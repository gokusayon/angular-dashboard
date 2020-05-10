#   Building the image
#       docker build -f node.dockerfile -t gokusayon/trends-dashboard . 
#   Running container after linking with existing container
#       docker run -p 80:80 --name dash -d --link trends:trends-app gokusayon/trends-dashboard    
#   Go to container shell
#       docker exec -i -t dash /bin/sh

#   Create an isolated network.
#       docker network create --driver bridge isolated_network 
#       docker run -d --net=isolated_network -p 5000:5000 --name trends gokusayon/trends-app
#       docker run -d --net=isolated_network -p 80:80 --name dash gokusayon/trends-dashboard

FROM        node:alpine as build-stage

LABEL       AUTHOR="Vasu Sheoran"  

RUN         mkdir -p /usr/src/app 
WORKDIR     /usr/src/app

COPY        . /usr/src/app

EXPOSE      4200

ENTRYPOINT  [ "ng", "serve", "--host", "0.0.0.0" ]
# ENTRYPOINT ["npm", "start"]