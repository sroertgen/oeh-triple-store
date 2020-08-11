# Openeduhub Triple Store and SPARQL endpoint

This project sets up a triple store and serves a SPARQL endpoint to publish the vocabularies and other data used in the project to the web.

A special interest lies in connecting school curricula with a Linked Data approach.

## Components

- SPARQL server: [Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/index.html)
- Triple Store: [TDB](https://jena.apache.org/documentation/tdb/index.html)

Additionally there is a Dockerfile added, which uses the mentioned one as a starting point. It is then loading the vocabulary files from the openeduhub vocabulary GitHub repository into the container and loading them with TDB.

## Setup

A docker-compose file is used to set everything up.

There are two ways you can add vocabulary:

- provide them inside your Dockerfile, e.g.
  - **TODO**
- upload them using the GUI

- set your password in the .env file (if you want to), e.g. `PW=openeduhub`
- you can set the following options in the docker-compose file if you want:
    - ...**TODO**
- run: `docker-compose up`
- your endpoint is served under: http://localhost:3030 
