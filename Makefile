# AnonOS MVP - Makefile for GitHub Codespaces
# Builds in /tmp to avoid noexec/nodev mount restrictions on /workspaces

BUILD_DIR=/tmp/anonos-build
ISO=live-image-amd64.hybrid.iso

.PHONY: all clean config build test serve ls

all: clean config build

clean:
	sudo rm -rf $(BUILD_DIR)
	sudo lb clean

config:
	mkdir -p $(BUILD_DIR)
	cp -r auto config Makefile $(BUILD_DIR)/
	sudo bash -c "cd $(BUILD_DIR) && lb config"

build:
	sudo bash -c "cd $(BUILD_DIR) && lb build"
	sudo cp $(BUILD_DIR)/$(ISO) . 2>/dev/null || true

test:
	sudo bash -c "cd $(BUILD_DIR) && qemu-system-x86_64 	  -cdrom $(ISO) 	  -m 2048 	  -nographic 	  -serial mon:stdio 	  -display none"

serve:
	python3 -m http.server 8080 &
	@echo "Download your ISO at: http://$$(hostname -I | awk '{print $$1}'):8080/$(ISO)"

ls:
	@ls -lh $(ISO) 2>/dev/null || echo "No ISO found. Run 'make build' first."
