FROM node
MAINTAINER Ding-Yi Chen <dchen@redhat.com>
LABEL vendor="zanata.org" license="LGPLv2.1"\
      description="zanata/sinopia packs sinopia (a private npm repository server) as docker with atomic host support"

ARG USERNAME=sinopia
ENV HOME_DIR=/opt/$USERNAME

EXPOSE 4873

RUN adduser --disabled-password --gecos "" --home $HOME_DIR $USERNAME
RUN chown -R $USERNAME:$USERNAME $HOME_DIR

WORKDIR $HOME_DIR
USER $USERNAME
RUN mkdir storage
VOLUME $HOME_DIR/storage

RUN mkdir bin

COPY *.yaml $HOME_DIR/
COPY sinopia.service $HOME_DIR/
COPY *.sh $HOME_DIR/bin/

RUN npm install sinopia
CMD ["/bin/bash", "-c", "$HOME_DIR/bin/start.sh"]

### Atomic Host Support
###   This docker image can also be used in Fedora Atomic Host
###   Note that docker-compose is required in the atomic host.

### Atomic install
###   1. create sinopia user at the host
###   2. run install.sh inside container
###   3. Enable in systemd
LABEL INSTALL="bash -c 'getent passwd sinopia >/dev/null || sudo useradd -G docker sinopia && \
  docker run --rm --privileged -v /:/host -e HOST=/host -e LOGDIR=/var/log/\${NAME} -e CONFDIR=/etc/\${NAME} \
  -e DATADIR=/var/lib/\${NAME} -e IMAGE=\${IMAGE} -e NAME=\${NAME} \${IMAGE} /opt/${USERNAME}/bin/install.sh && \
  sudo cp /tmp/sinopia.yaml ~sinopia/ && \
  sudo cp /tmp/sinopia.service /etc/systemd/system/ && \
  sudo systemctl daemon-reload && sudo systemctl enable sinopia'"

### Atomic run
###   1. systemctl start sinopia
LABEL RUN="sudo systemctl start sinopia"

### Atomic uninstall
###   1. Remove from systemd
###   2. Remove from docker
###   3. Remove sinopia user
LABEL UNINSTALL="bash -c 'sudo systemctl stop sinopia && sudo systemctl disable sinopia && \
  sudo rm -f /etc/systemd/system/sinopia.service && sudo systemctl daemon-reload && \
  docker rm -f sinopia && \
  sudo userdel -r sinopia'"

LABEL version=1.4.0-4

