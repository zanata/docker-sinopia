FROM node
MAINTAINER Keyvan Fatehi <keyvanfatehi@gmail.com>
RUN adduser --disabled-password --gecos "" sinopia
WORKDIR /opt/sinopia
RUN npm install js-yaml sinopia2
RUN chown -R sinopia:sinopia /opt/sinopia
USER sinopia
RUN mkdir -p /opt/sinopia/storage
ADD /config.yaml /tmp/config.yaml
ADD /start.sh /opt/sinopia/start.sh
CMD ["/opt/sinopia/start.sh"]
EXPOSE 4873
VOLUME /opt/sinopia/storage
