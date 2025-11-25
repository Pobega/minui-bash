# This makefile contains the core logic for building the bash binary.
# It is designed to be run inside a Docker container by the main 'makefile'.

-include config.mk

BASH_SOURCE = bash-$(BASH_VERSION).tar.gz
BASH_SOURCE_SIG = $(BASH_SOURCE).sig
BUILD_DIR = build/bash-$(BASH_VERSION)
CONFIGURE_ARGS = --without-bash-malloc --host=aarch64-pc-linux-gnu

TARGET = bash
PRODUCT = build/$(PLATFORM)/bash

.PHONY: all
all: $(PRODUCT)

$(BASH_SOURCE_SIG):
	@echo "Fetching bash source signature..."
	wget https://ftp.gnu.org/gnu/bash/$(BASH_SOURCE_SIG) -O $(BASH_SOURCE_SIG)

$(BASH_SOURCE):
	@echo "Fetching bash source version $(BASH_VERSION)..."
	wget https://ftp.gnu.org/gnu/bash/$(BASH_SOURCE) -O $(BASH_SOURCE)

.PHONY: verify-bash-source
verify-bash-source: $(BASH_SOURCE) $(BASH_SOURCE_SIG)
	@echo "Verifying bash source with GPG signature..."
	gpg --list-keys --with-colons 64EA74AB > /dev/null 2>&1 || gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 64EA74AB
	gpg --batch --verify $(BASH_SOURCE_SIG) $(BASH_SOURCE)
	rm $(BASH_SOURCE_SIG)

$(BUILD_DIR)/extract: verify-bash-source $(BUILD_DIR)/extract-only
$(BUILD_DIR)/extract-only:
	@echo "Extracting $(BASH_SOURCE)..."
	mkdir -p build/
	tar -xf $(BASH_SOURCE) -C build
	rm $(BASH_SOURCE)

$(BUILD_DIR)/configure: $(BUILD_DIR)/extract $(BUILD_DIR)/configure-only
$(BUILD_DIR)/configure-only:
	@echo "Configuring bash..."
	(cd $(BUILD_DIR) && \
	./configure $(CONFIGURE_ARGS))

$(BUILD_DIR)/make: $(BUILD_DIR)/configure $(BUILD_DIR)/make-only
$(BUILD_DIR)/make-only:
	@echo "Compiling bash..."
	(cd $(BUILD_DIR) && \
	make)

$(PRODUCT): $(BUILD_DIR)/make $(PRODUCT)-only
$(PRODUCT)-only:
	@echo "Copying final executable and cleaning up..."
	mkdir -p build/$(PLATFORM)
	cp $(BUILD_DIR)/$(TARGET) $(PRODUCT)
	rm $(BUILD_DIR)/$(TARGET)
	rm -rf $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf build/bash-*
	rm -rf build/$(PLATFORM)
