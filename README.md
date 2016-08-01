## Sinopia

Sinopia is a private npm repository server.
This is a fork of keyvanfatehi/sinopia[keyvanfatehi/sinopia](https://github.com/keyvanfatehi/sinopia), yet tune for Zanata team.

### Sinopia Service Setup

#### Pull Docker Image

`docker pull zanata/sinopia2:latest`

#### Configure
You can skip to the section **Run Service** if you just want the default 
configuration.

##### Makefile
This file configures how the container interact with host.
Notable variables:

* `CONTAINER_NAME`: container name for `docker run`
* `HOST_PORT`: host port for container port forwarding.
* `VOLUME_HOST_DIR`: host directory for volume storage.

These variable can also be passed as environment variables.

##### start.sh
How the service be run inside the container

#### Run Service
Simply run the service:
`make run`

For removing existing container, then run at host port 5000:
`HOST_PORT=5000 make rerun`

For help:
`make help`

### NPM Client Setup

Setting NPM Registry:
`npm set registry http://<docker_host>:4873/`

## Links

* [Sinopia on Github](https://github.com/rlidwka/sinopia)
