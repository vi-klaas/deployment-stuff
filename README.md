# deployment-stuff
This repository helps to reproduce server setup and deployment

## Docker
Installing Docker on Debian
#### Update the apt package index:
```shell
sudo apt-get update
sudo apt-get install \
 ca-certificates \
 curl \
 gnupg \
 lsb-release
```

#### Add Docker’s official GPG key:
```shell
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
#### Set up the Docker stable repository for Debian:
```shell
echo"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bookworm stable"| sudo tee/etc/apt/sources.list.d/docker.list > /dev/null  This command adds the correct repository for Debian Bookworm.
```
#### Update the apt package index and install Docker:
```shell
sudo apt-get update sudo apt-get install docker-ce docker-ce-cli containerd.io
```

#### Verify the installation by running the hello-world Docker image:
```shell
sudo docker run hello-world
```
This will add the correct Docker repository for Debian Bookworm and then install Docker. Be sure to have sudo privileges to execute these commands.
Also, always ensure that you're using the correct repository for your Linux distribution and version to avoid such issues.


## Users and groups
### Users and their purpose:
* admin-user
* **dockeruser**: run docker container
* **apprunner**: user to be used inside containers with restricted rights

```shell
sudo useradd dockeruser # todo: group?
sudo useradd --system --shell /usr/sbin/nologin apprunner
```

### Allow the admin user to execute commands under the name of dockeruser
```shell
sudo visudo
```
Add the following line to allow all commands to be executed as user dockeruser
```log
yourusername ALL=(dockeruser) NOPASSWD: ALL
```

## git authentication
Follow this guide
* generate or check your key
* add your public key to each repository that you want to use
https://docs.github.com/authentication/connecting-to-github-with-ssh

## Utils
This folder provides scripts that help the deployment process.
First, copy all scripts to **/usr/local/bin**
```shell
sudo cp utils/* /usr/local/bin/
sudo chmod 750 /usr/local/bin/set_permissions_startscript.sh
sudo chmod 750 /usr/local/bin/set_permissions_dockermounts.sh
sudo chmod 750 /usr/local/bin/set_permissions_deploymentscript.sh
```

### Set permissions
#### set_permissions_dockermounts.sh
```
sudo /usr/local/bin/set_permissions_dockermounts.sh /srv/caddy
```
Sets _recursively_ the 
* user **apprunner**
* group **apprunner**
* and permissions chmod **740**
to folders including subfolders and files located as given
```log
-rwxr-----    /srv/caddy
```
use this for folder that contains folders and files that are mounted into docker containers

#### set_permissions_startscript.sh
```shell
sudo /usr/local/bin/set_permissions_startscript.sh start_caddy.sh
```
Sets the 
* user **dockeruser**
* group **docker**
* and permissions chmod **750** 
to a script located in **/usr/local/bin/**
```log
-rwxr-x---    /usr/local/bin/start_caddy.sh
```
use this for every start script that is starting docker or docker compose.

#### set_permissions_deploymentscript.sh
```shell
sudo /usr/local/bin/set_permissions_deploymentscript.sh deploy_shiny_prod.sh
```
Keeps user and group and sets the 
* the permissions chmod **750** 
to a script located in **/usr/local/bin/**
```log
-rwxr-x---    /usr/local/bin/deploy_shiny_prod.sh
```
use this for every deployment script that is using git clone/pull to get the newest version of an app.

## Caddy
### Caddy Directories
Location of data **/srv/caddy**
#### Create directories (certs only in case of self-managed certificates)
```shell
sudo mkdir /srv/caddy/
sudo mkdir /srv/caddy/data
sudo mkdir /srv/caddy/config
sudo mkdir /srv/caddy/media
sudo mkdir /srv/caddy/static
sudo mkdir /srv/caddy/certs
```

#### Create a Caddyfile (or copy)
```shell
sudo nano /srv/caddy/Caddyfile
```

#### Set Correct permissions
The user **apprunner** is the user inside the docker container.
So, this user needs permissions for the folders that are mounted into the docker container
```shell
sudo chown -R apprunner:apprunner /srv/caddy
sudo chmod -R 740 /srv/caddy
sudo chgrp -R docker /srv/caddy
```
or use this script
```
sudo utils/set_permissions_dockermounts.sh /srv/caddy
```

#### Script for starting the docker container (start_caddy.sh)
Preparation: copy the script to /usr/bin/local and set the permissions
```log
-rwxr-x---
```

```shell
sudo /usr/local/bin/set_permissions_startscript.sh start_caddy.sh
# or
sudo chown dockeruser:docker /usr/bin/local/start_caddy.sh
sudo chmod 750 /usr/local/bin/start_caddy.sh
```

Run the script as **dockeruser**
```shell
sudo -u dockeruser sh /usr/bin/local/start_caddy.sh
```


## Shiny Apps
### Shiny Server
#### Directory structure on host
Move the index-app from this repo to **/srv/shiny/apps** and **/srv/shiny/apps_dev**
```log
/srv/shiny
|-- apps
|   |-- app1
|   |   |-- app.R (or ui.R/server.R)
|   |-- app2
|   |   |-- app.R (or ui.R/server.R)
|   |-- index
|       |-- app.R (or ui.R/server.R)
|-- apps-test
|   |-- app1
|   |   |-- app.R (or ui.R/server.R)
|   |-- app2
|   |   |-- app.R (or ui.R/server.R)
|   |-- index
|       |-- app.R (or ui.R/server.R)
|
|-- shiny-server.conf
```
* **/srv/shiny/apps**: This directory contains the production-ready Shiny applications. Each app has its own directory (e.g., app1, app2), and inside each app directory is the app.R file (or both ui.R and server.R if you're using the two-file structure).
* **/srv/shiny/apps-test**: This directory holds the development/testing versions of the Shiny applications. The structure mirrors the production apps directory.
* **/srv/shiny/index**: The app containing the index landing page to reach all apps.
* **/srv/shiny/apps-test/index**: Similar to the production index, this would be your landing page or directory listing for development apps.
* **/srv/shiny/shiny-server.conf**: The Shiny Server configuration file.

If not existing, create the directories
```shell
sudo mkdir /srv/shiny
sudo mkdir /srv/shiny/apps
sudo mkdir /srv/shiny/apps-test
```
Copy from this repo the index and example app and shiny-server config
```shell
sudo cp shiny-server.conf /srv/shiny/
sudo cp index /srv/shiny/apps/
sudo cp mini-example /srv/shiny/apps/
sudo cp index /srv/shiny/apps-test/
sudo cp mini-example /srv/shiny/apps-test/
```

#### Build the docker image
* in the Dockerfile, adapt
  * the R libraries to install
  * the user id and group id to match the docker host
* assuming from this repo directory
* on mac, include option **--platform linux/amd64**

```shell
cd shiny
docker build -t sorcshinyimage .
```
_TODO: set up own docker registry, instead of building containers on this server_

#### Run the shiny-server docker
Change the permissions for the start script
```shell
sudo /usr/local/bin/set_permissions_startscript.sh start_shiny_prod.sh
sudo /usr/local/bin/set_permissions_startscript.sh start_shiny_test.sh
```
and run the script as **dockeruser**
```shell
sudo -u dockeruser /usr/local/bin/start_shiny_prod.sh
# or
sudo -u dockeruser /usr/local/bin/start_shiny_test.sh
```

#### Restart only the shiny server, e.g. after changing the config
```shell
docker exec -it shiny-prod sudo systemctl restart shiny-server
```


### Deploying Shiny Apps
Use the script **deploy_shiny.sh** as your normal user
```shell
sudo /usr/local/bin/deploy_shiny.sh app_name git_repo_full_path test_or_prod
# this will deploy to /srv/shiny/apps/myapp
sudo /usr/local/bin/deploy_shiny.sh myapp git@github.com:username/myapp.git prod
# this will deploy to /srv/shiny/apps-test/myapp
sudo /usr/local/bin/deploy_shiny.sh myapp git@github.com:username/myapp.git test
```
