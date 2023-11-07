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
sudo useradd --system --shell /usr/bin/nologin apprunner
```

### Allow the admin user to execute commands under the name of dockeruser
```shell
sudo visudo
```
Add for each script
**yourusername ALL=(apprunner) NOPASSWD: /usr/bin/local/start_caddy.sh**

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
```shell
sudo chown -R apprunner:apprunner /srv/caddy
sudo chmod -R 770 /srv/caddy
sudo chgrp -R docker /srv/caddy
```

#### Script for starting the docker container (start_caddy.sh)
Preparation: copy the script to /usr/bin/local and set the permissions
```shell
sudo chmod +x /usr/bin/local/start_caddy.sh
sudo chown dockeruser:docker /usr/bin/local/start_caddy.sh
sudo chgrp docker /usr/bin/local/start_caddy.sh
sudo chmod 770 /usr/bin/local/start_caddy.sh
```
Run the script as **dockeruser**
```shell
sudo -u dockeruser sh /usr/bin/local/start_caddy.sh
```
