HOST_WORKSPACE=$(shell pwd)
GUEST_WORKSPACE=/root/workspace

PLATFORM=tg5040
IMAGE_NAME=ghcr.io/loveretro/$(PLATFORM)-toolchain:modernize

.PHONY: all
all: build

build: pull
	docker run --rm -v $(HOST_WORKSPACE):$(GUEST_WORKSPACE) $(IMAGE_NAME) /bin/bash -c '. ~/.bashrc && cd /root/workspace && make -f makefile.bash'

shell:
	docker run -it --rm -v $(HOST_WORKSPACE):$(GUEST_WORKSPACE) $(IMAGE_NAME) /bin/bash

pull:
	docker pull $(IMAGE_NAME)
