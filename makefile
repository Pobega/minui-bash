# This is the main, user-facing makefile for managing local Docker-based
# build operations. It orchestrates the use of 'makefile.bash' inside
# a Docker container.

BASH_VERSION = 5.2
HOST_WORKSPACE = $(shell pwd)
GUEST_WORKSPACE = /root/workspace

PLATFORM ?= tg5040
IMAGE_NAME = ghcr.io/loveretro/$(PLATFORM)-toolchain:modernize

.PHONY: all build build-only shell pull clean

all: build

build: pull build-only
build-only:
	docker run --rm -v $(HOST_WORKSPACE):$(GUEST_WORKSPACE) $(IMAGE_NAME) /bin/bash -c 'apt-get update && apt-get install -y gnupg && . ~/.bashrc && cd /root/workspace && make -f makefile.bash'

shell:
	docker run -it --rm -v $(HOST_WORKSPACE):$(GUEST_WORKSPACE) $(IMAGE_NAME) /bin/bash

pull:
	docker pull $(IMAGE_NAME)

clean:
	docker run --rm -v $(HOST_WORKSPACE):$(GUEST_WORKSPACE) $(IMAGE_NAME) /bin/bash -c '. ~/.bashrc && cd /root/workspace && make -f makefile.bash clean PLATFORM=$(PLATFORM)'
