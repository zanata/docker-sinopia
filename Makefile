REGISTRY = docker.io
REPOSITORY = zanata/sinopia2

## Container name for docker run
CONTAINER_NAME ?= sinopia

## Host port for docker run
HOST_PORT ?= 4873

## Host port for docker run
CONTAINER_PORT ?= 4873

DATA_VOLUME ?= sinopia-data
VOLUME_CONTAINER_DIR ?= /opt/sinopia/storage

SYSTEMD_NOTIFY=/bin/systemd-notify

OS := $(shell uname)
ifeq (${OS},Linux)
	SELINUX:=1
ifeq ($(findstring unconfined_t,$(shell id -Z)),)
	SUDO = sudo
else
	SUDO =
endif
else
	SELINUX:=0
endif

define USAGE
Targets:
    help:            Show this heip
    build:           Build the image
    exec:            Login to existing container with a shell
    push:            Push the image to registry (only for image author)
    rerun:           Remove the existing container and run
    rm:              Remove the container
    run:             Invoke a container in default setting
endef


.PHONY: all help build exec push run ensure-build

export USAGE
help:
	@echo "$$USAGE"

build:
	docker build -t ${REPOSITORY} .

exec:
	docker exec -it ${CONTAINER_NAME} /bin/bash

push: ensure-build
	docker tag ${REPOSITORY} ${REGISTRY}/${REPOSITORY}
	docker push ${REGISTRY}/${REPOSITORY}

## 'docker volume ls -f name=${DATA_VOLUME}'  does not seem to work in EL7
rerun:
ifneq ($(shell docker ps -aqf name=${CONTAINER_NAME}),)
	make rm
endif
	make run

## No need remove Data volume, as it should be kept persistent
rm:
	docker rm -f ${CONTAINER_NAME}

run: ensure-build ensure-data-volume
	docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} -v ${DATA_VOLUME}:${VOLUME_CONTAINER_DIR} ${REPOSITORY}

##== Supporting targets ==

##=== Build, if not built already ===
ensure-build:
ifeq ($(shell docker images -q ${REPOSITORY}),)
	make build
endif

ensure-data-volume:
ifeq ($(shell docker volume ls | grep ${DATA_VOLUME}),1)
    docker volume create --name ${DATA_VOLUME}
endif
