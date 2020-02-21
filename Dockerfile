FROM postgis/postgis
COPY westmacsappdb.sql /docker-entrypoint-initdb.d
