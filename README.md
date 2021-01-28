## IRIS Publisher
This is an application to generate your online dynamic or offine static application documentation. You create XData to your classes with "text/html" or "text/markdown" mime type and the IRIS Publisher will collect all XData and create your documentation site using MkDocs. 

## IRIS Publisher in action:
<img src="https://github.com/yurimarx/iris-publisher/raw/master/IRISPublisher.gif" alt="IRIS Publisher in action">

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation and Running

```
$ git clone https://github.com/yurimarx/iris-publisher
```

Open the terminal in this directory and run:

```
$ docker-compose up -d --build
```


## How to Work With it

Annotate ObjectScript classes in your project like this (See Person.cls as sample):

```
/// Documentation for Person in HTML
XData PersonDocHtml [ MimeType = text/html ]
{
<h1>This is the Person class</h1>
}

/// Documentation for Person in Markdown
XData PersonDocMarkdown [ MimeType = text/markdown ]
{
<h1>This is the Person class in MD</h1>
}
```
To Generate the Documentation and execute the Documentation Server From API:

1. Execute http://localhost:52773/swagger-ui/index.html?url=http://localhost:52773/api/mgmnt/v1/USER/spec/crud#/default/UpdateDocConfig with this sample body to config your documentation parameters:

```
{
"SiteName":"Publisher",
"Summary":"Documentation of the Publisher",
"Description":"This an Application to generate documentation from XDATA",
"DeveloperName":"Yuri Gomes",
"DeveloperEmail": "yurimarx@gmail.com",
"DeveloperWebsite": "ymservices.tech"
}

```
2. Execute http://localhost:52773/swagger-ui/index.html?url=http://localhost:52773/api/mgmnt/v1/USER/spec/crud#/default/InitiatePublisher to generate documentation and up the documentation server 


3. The IRIS Publisher it will serve your documentation in: http://localhost:8000

If you want download the static version, download the folder from your docker instance: /mkdocs/iris-publisher/site

To Generate the Documentation and Up Documentation Server From IRIS Terminal run: 

```
##class("dc.mkdocs.Generator").Generate()
```

## Change the Theme:

### Current themes
<img src="https://github.com/yurimarx/iris-publisher/raw/master/themes.gif" alt="IRIS Publisher themes">

The first theme is the default, to set last theme update the config setting Theme to readthedocs, see:

´´´
{
"SiteName":"Publisher",
"Summary":"Documentation of the Publisher",
"Description":"This an Application to generate documentation from XDATA",
"DeveloperName":"Yuri Gomes",
"DeveloperEmail": "yurimarx@gmail.com",
"DeveloperWebsite": "ymservices.tech",
"Theme": "readthedocs"
}

´´´

## How to start coding
This repository is ready to code in VSCode with ObjectScript plugin.
Install [VSCode](https://code.visualstudio.com/) and [ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) plugin and open the folder in VSCode.
Open /src/cls/PackageSample/ObjectScript.cls class and try to make changes - it will be compiled in running IRIS docker container.

Feel free to delete PackageSample folder and place your ObjectScript classes in a form
/src/cls/Package/Classname.cls

The script in Installer.cls will import everything you place under /src/cls into IRIS.

## What's insde the repo

# Dockerfile

The simplest dockerfile to start IRIS and load ObjectScript from /src/cls folder
Use the related docker-compose.yml to easily setup additional parametes like port number and where you map keys and host folders.

# .vscode/settings.json

Settings file to let you immedietly code in VSCode with [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))

# .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript
