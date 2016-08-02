FROM node
MAINTAINER Ding-Yi Chen <dchen@redhat.com>
ARG USERNAME=sinopia
ENV HOME_DIR=/opt/$USERNAME
RUN adduser --disabled-password --gecos "" --home $HOME_DIR $USERNAME
RUN mkdir -p $HOME_DIR/storage
WORKDIR $HOME_DIR
RUN npm install js-yaml sinopia2
RUN chown -R $USERNAME:$USERNAME $HOME_DIR
USER $USERNAME
ADD config.yaml /tmp/config.yaml
ADD start.sh $HOME_DIR/start.sh
CMD ["/bin/bash", "-c", "$HOME_DIR/start.sh"]
EXPOSE 4873
VOLUME $HOME_DIR/storage
