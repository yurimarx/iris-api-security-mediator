## iris-api-security-mediator
This is a ObjectScript Application to enforce authorization rules using XDATA into API methods.
Can be developed with Docker and VSCode,
can be deployed as ZPM module.

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation with ZPM

zpm:USER>install iris-api-security-mediator

## Installation for development

Clone/git pull the repo into any local directory e.g. like it is shown below (here I show all the examples related to this repository, but I assume you have your own derived from the template):

```
$ git clone git@github.com:yurimarx/iris-api-security-mediator.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d --build
```


## How to Work With it

This template creates /crud REST web-application on IRIS which implements 4 types of communication: GET, POST, PUT and DELETE aka CRUD operations and custom XDATA sentences to enforce authorization rules.
These interface works with a sample persistent class Sample.Person.

Open http://localhost:52773/swagger-ui/index.html to test the REST API

# Testing GET requests

To test GET you need to have some data. You can create it with POST request (see below), or you can create some fake testing data. to do that open IRIS terminal or web terminal on /localhost:52773/terminal/  and call:

```
USER>do ##class(Sample.Person).AddTestData(10)
```
This will create 10 random records in Sample.Person class.


You can get swagger Open API 2.0 documentation on:
```
localhost:yourport/_spec
```

This REST API exposes two GET requests: all the data and one record.
To get all the data in JSON call:

```
localhost:52773/crud/persons/all
```

See the class dc.Sample.PersonREST, method GetAllPersons(). It has a XDATA custom auth authorization rule @security.and: roles: { PersonAdmin }. This rules force to the user of this API get PersonAdmin role. So, to execute it, create PersonAdmin role and assign this role to the user that you using to request the API method. 


## What's insde the repo

# Dockerfile

The simplest dockerfile to start IRIS and load ObjectScript from /src/cls folder
Use the related docker-compose.yml to easily setup additional parametes like port number and where you map keys and host folders.

# .vscode/settings.json

Settings file to let you immedietly code in VSCode with [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))

# .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript
