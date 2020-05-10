#   Building the image
#       docker build -f Dockerfile -t gokusayon/trends-dashboard . 
#   Running container after linking with existing container
#       sudo docker run -p 80:80 --name dash -d --link trends:trends-app gokusayon/trends-dashboard    
#       sudo docker run -p 80:80 --name dash -d gokusayon/trends-dashboard   
#   Go to container shell
#       docker exec -i -t dash /bin/sh
#   sudo docker build -f Dockerfile -t gokusayon/trends-app .
#   sudo docker run -d -p 5000:5000 --name trends gokusayon/trends-app
#   sudo docker run -d -p 80:4200    --name dash -v $(pwd):/var/www -w "/var/www" node npm start
#   sudo docker run -d -p 80:4200 --link trends:trends --name dash -v $(pwd):/var/www -w "/var/www" node npm start 
#   sudo docker run -d -p 80:4200 --network isolated_network --name dash -v $(pwd):/var/www -w "/var/www" node npm start

### STAGE 1: Build ###

# We label our stage as 'build-stage'

FROM        node:alpine as build-stage

LABEL       AUTHOR="Vasu Sheoran"  

RUN         mkdir -p /usr/s rc/app 
WORKDIR     /usr/src/app

COPY        package.json package-lock.json* ./

RUN         npm install --silent
# RUN         npm link @angular/cli --silent

COPY        . /usr/src/app

ARG         API_BASE_URL
ENV         API_BASE_URL "$API_BASE_URL"
ARG         configuration=production
RUN         npm run build -- --output-path=./dist/out --configuration $configuration

FROM        nginx

## Copy our default nginx config
COPY nginx/default.conf /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From 'build-stage' stage copy over the artifacts in dist folder to default nginx public folder
COPY        --from=build-stage /usr/src/app/dist/out/ /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]