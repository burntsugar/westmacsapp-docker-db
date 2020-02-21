# 🏕 westmacsapp-docker-db

![Ghost Gum Flat](cover.jpg)

Our tents right [here](https://www.google.com/maps/place/23%C2%B043'45.9%22S+133%C2%B013'10.5%22E/@-23.7293999,133.0617016,62171m/data=!3m1!1e3!4m5!3m4!1s0x0:0x0!8m2!3d-23.7294056!4d133.2195889)

## 🏕 What is this?

I'm setting up a GraphQL server over at [westmacsapp-graphql-server](https://github.com/burntsugar/westmacsapp-graphql-server).

Containerising the database is assisting with development on multiple machines.

Play along, if you like :)

#  🏕 Set up for docker

##  🏕 Project directory

- westmacsapp-docker-db
    - Dockerfile
    - westmacsappdb.sql

## 🏕 Dockerfile

````bash
# Dockerfile
FROM postgis/postgis
COPY westmacsappdb.sql /docker-entrypoint-initdb.d
````

## 🏕 Build image

````bash
user$ docker build -t westmacsappdb-image .
````

## 🏕 Run container

````
user$ docker run -p 5431:5432 --name westmacsappdb-container -e POSTGRES_PASSWORD=somepassword -e POSTGRES_USER=someuser -d westmacsappdb-image
````

Container attributes:

* Container port: *5431*
* Mapped to host port: *5432*
* Container name: *westmacsappdb-container*
* Postgres username: *someusername*
* Postgres password: *somepassword*
* Image name: *postgis/postgis*

Options used:

* -d: Run in background

##  🏕 Stop container

````
user$ docker stop westmacsappdb-container
````

## 🏕 Start container

````
user$ docker stop westmacsappdb-container
````

## 🏕 Exec into shell

````
user$ docker exec -it westmacsappdb-container bash
````

## 🏕 Log in to shell psql

````
shell$ psql -U someuser
````

<br>

<hr>

*rrr@<span></span>burntsugar.rocks*