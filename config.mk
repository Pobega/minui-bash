# Configuration variables for other makefiles.
# Defines things like Bash version, workspace paths, platform, etc that are
# shared across the different makefiles.

BASH_VERSION = 5.2

HOST_WORKSPACE = $(shell pwd)
GUEST_WORKSPACE = /root/workspace

PLATFORM ?= tg5040
IMAGE_NAME = ghcr.io/loveretro/$(PLATFORM)-toolchain:modernize
