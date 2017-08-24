## Sinopia

Sinopia is a private npm repository server.
This is a fork of [keyvanfatehi/sinopia](https://github.com/keyvanfatehi/sinopia), tuned for the Zanata team.

This service uses data volume, thus requires docker >= 1.9.0.
Fedora >= 23 and latest RHEL 7 have this capability.

### 1. Installation


#### With Atomic Host (recommended)
If you are using Fedora Atomic Host, just use:

```bash
atomic install sinopia
```

#### With docker

1. Pull zanata/sinopia2 image
  ```bash
  docker pull docker.io/zanata/sinopia2
  ```

2. Create sinopia user at host
  ```bash
  getent passwd sinopia >/dev/null || sudo useradd -G docker sinopia
  ```
3. Download `sinopia.yaml`
  ```bash
  sudo curl -o ~sinopia/sinopia.yaml https://raw.githubusercontent.com/zanata/zanata-sinopia-docker-files/master/sinopia.yaml
  ```

4. Download `sinopia.service`
  ```bash
  sudo curl -o /etc/systemd/system/sinopia.service https://raw.githubusercontent.com/zanata/zanata-sinopia-docker-files/master/sinopia.service
  ```
5. Setup systemd
  ```bash
  sudo systemctl daemon-reload && sudo systemctl enable sinopia
  ```

### 2. Run service
```bash
sudo systemctl start
```

### 3. NPM Client Setup
Setting NPM Registry:
```bash
npm set registry http://${DOCKER_HOST}:${HOST_PORT}/
```

For examples, use:
```bash
npm set registry http://localhost:4873/
```
if you run your sinopia at localhost, default port `4873`.

### 4. Check the Service

1. Use browser to go to `http://${DOCKER_HOST}:${HOST_PORT}/`.
You should see system running.

2. Running `npm install <package>` and see if the package download successfully. *Notes: cached packages do not show in web UI. Sinopia Web UI only show manually published packages.*

### A. Files

##### Dockerfile
Configure how the docker image be built.

##### Makefile
Configures how the container interact with host.
Notable variables:

* `CONTAINER_NAME`: container name for `docker run`
* `HOST_PORT`: host port for container port forwarding.
* `DATA_VOLUME`: name of data volume.

These variable can also be passed as environment variables.

##### start.sh
How the service be run inside the container

###  B. Old Way to Run Service

##### Simple
Simply run the service:
`make run`

For removing existing container, then run at host port 5000:
`HOST_PORT=5000 make rerun`

For help:
`make help`

##### Systemd
1. Create a `sinopia` user, assuming its home directory is `/home/sinopia`. Use following command:
  ```bash
  sudo useradd -G docker sinopia
  ```

2. Login as `sinopia` and git clone the source
   ```bash
   sudo su sinopia
   cd
   git clone https://github.com/zanata/zanata-sinopia-docker-files.git
   exit
   ```

3. Install sinopia.service to systemd
   ```bash
   sudo cp /home/sinopia/zanata-sinopia-docker-files/sinopia.service  /etc/systemd/system/multi-user.target.wants
   sudo systemctl daemon-reload
   ```

4. Start the service
   ```bash
   sudo systemctl start sinopia
   ```

### Sinopia Service Setup (Without Source Code)
#### Pull Docker Image
`docker pull zanata/sinopia2:latest`

##### Without git clone zanata-sinopia-docker-files
`docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:4873 -v ${VOLUME_HOST_DIR}:/opt/sinopia/storage zanata/sinopia2:latest`


