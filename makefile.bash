BASH_VERSION = 5.2
BASH_SOURCE = bash-$(BASH_VERSION).tar.gz
BUILD_DIR = build/bash-$(BASH_VERSION)
CONFIGURE_ARGS = --without-bash-malloc --host=aarch64-pc-linux-gnu

TARGET = bash
PRODUCT = build/tg5040/bash

.PHONY: all
all: $(PRODUCT)

$(BASH_SOURCE):
	@echo "Fetching bash source version $(BASH_VERSION)..."
	mkdir -p build/
	wget https://ftp.gnu.org/gnu/bash/$(BASH_SOURCE) -O $(BASH_SOURCE)

$(BUILD_DIR)/extract: $(BASH_SOURCE) $(BUILD_DIR)/extract-only
$(BUILD_DIR)/extract-only:
	@echo "Extracting $(BASH_SOURCE)..."
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
	mkdir -p build/tg5040
	cp $(BUILD_DIR)/$(TARGET) $(PRODUCT)
	chown 1000:1000 $(PRODUCT)
	rm -rf $(BUILD_DIR)

.PHONY: clean
clean:
	rm -f $(PRODUCT)
	rm -rf build/bash-*
