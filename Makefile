# AnonOS MVP - Makefile for GitHub Codespaces

.PHONY: all clean config build test iso

all: clean config build

clean:
	sudo lb clean

config:
	sudo lb config

build:
	sudo lb build

test: build
	qemu-system-x86_64 	  -cdrom live-image-amd64.hybrid.iso 	  -m 2048 	  -nographic 	  -serial mon:stdio 	  -display none

serve:
	python3 -m http.server 8080 &
	@echo "Download your ISO at: http://$:8080/live-image-amd64.hybrid.iso"

ls:
	@ls -lh *.iso 2>/dev/null || echo "No ISO found. Run 'make build' first."
