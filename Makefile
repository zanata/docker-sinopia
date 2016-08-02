REGISTRY = docker.io
REPOSITORY = zanata/sinopia2

## Container name for docker run
CONTAINER_NAME ?= sinopia

## Host port for docker run
HOST_PORT ?= 4873

## Host port for docker run
CONTAINER_PORT ?= 4873

## Host volume storage directory
VOLUME_HOST_DIR ?= ${HOME}/.cache/sinopia
VOLUME_CONTAINER_DIR ?= /opt/sinopia/storage

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
    help:  Show this heip
    build: build the image
    exec:  login to existing container with a shell
    push:  push the image to registry (only for image author)
    rerun: Remove the existing container and run
    run:   invoke a container in default setting
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

rerun:
ifneq ($(shell docker ps -aqf name=${CONTAINER_NAME}),)
	docker rm -f ${CONTAINER_NAME}
endif
	make run

run: ensure-build ${VOLUME_HOST_DIR}
	docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} -v ${VOLUME_HOST_DIR}:${VOLUME_CONTAINER_DIR} ${REPOSITORY}

##== Supporting targets ==
${VOLUME_HOST_DIR}:
	mkdir -p ${VOLUME_HOST_DIR}
ifeq ($(SELINUX),1)
	$(SUDO) chcon -Rt svirt_sandbox_file_t ${VOLUME_HOST_DIR}
endif

##== Build, if not built already
ensure-build:
ifeq ($(shell docker images -q ${REPOSITORY}),)
	make build
endif

