.PHONY: help setup build upload uploadfs monitor clean

help:
	@echo "Battery Tester - Available Commands"
	@echo ""
	@echo "  setup     : Install dependencies"
	@echo "  config    : Setup configuration"
	@echo "  build     : Build project"
	@echo "  upload    : Upload firmware"
	@echo "  uploadfs  : Upload filesystem"
	@echo "  flash     : Build and upload all"
	@echo "  monitor   : Open serial monitor"
	@echo "  clean     : Clean build files"
	@echo "  backup    : Backup data"

setup:
	pip install platformio

config:
	@if [ ! -f src/config.h ]; then \
		cp config.h.template src/config.h; \
		echo "Please edit src/config.h with your WiFi credentials!"; \
	fi

build: config
	pio run

upload: build
	pio run --target upload

uploadfs:
	pio run --target uploadfs

flash: build upload uploadfs
	@echo "Flash completed!"

monitor:
	pio device monitor

clean:
	pio run --target clean

backup:
	./scripts/backup_data.sh --compress
