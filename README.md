## Sinopia

Sinopia is a private npm repository server.
This is a fork of [keyvanfatehi/sinopia](https://github.com/keyvanfatehi/sinopia), yet tune for Zanata team.



### Sinopia Service Setup (From Source Code)
#### Configure
You can skip to the section **Run Service** if you just want the default configuration.

##### Dockerfile
Configure how the docker image be built.

##### Makefile
Configures how the container interact with host.
Notable variables:

* `CONTAINER_NAME`: container name for `docker run`
* `HOST_PORT`: host port for container port forwarding.
* `VOLUME_HOST_DIR`: host directory for volume storage.

These variable can also be passed as environment variables.

##### start.sh
How the service be run inside the container

##### Run Service
Simply run the service:
`make run`

For removing existing container, then run at host port 5000:
`HOST_PORT=5000 make rerun`

For help:
`make help`

### Sinopia Service Setup (Without Source Code)
#### Pull Docker Image
`docker pull zanata/sinopia2:latest`

##### Without git clone docker-sinopia
`docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:4873 -v ${VOLUME_HOST_DIR}:/opt/sinopia/storage zanata/sinopia2:latest`

### NPM Client Setup
Setting NPM Registry:
`npm set registry http://${DOCKER_HOST}:${HOST_PORT}/`

For examples, use:
`npm set registry http://localhost:4873/` 
if you run your sinopia at localhost, default port `4873`.

### Check the Service
1. Use browser to go to `http://${DOCKER_HOST}:${HOST_PORT}/`.
You should see system running.

2. Running `npm install <package>` and see if the package download successfully. *Notes: cached packages do not show in web UI. Sinopia Web UI only show manually published packages.*

