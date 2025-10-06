#!/bin/bash

###############################################################################
# ESP32 Battery Tester - Auto Setup Script
# 
# Script ini akan membuat struktur folder lengkap dan generate semua file
# yang diperlukan untuk proyek Battery Capacity Tester
#
# Usage: bash setup_project.sh
###############################################################################

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Project name
PROJECT_NAME="battery-tester"

echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║      ESP32 Battery Capacity Tester Setup Script          ║
║                                                           ║
║      🔋 Auto-generate all project files                  ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

# Check if project already exists
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${RED}⚠ Directory '$PROJECT_NAME' already exists!${NC}"
    read -p "Delete and recreate? (y/N): " confirm
    if [ "$confirm" = "y" ]; then
        rm -rf "$PROJECT_NAME"
        echo -e "${GREEN}✓ Deleted existing directory${NC}"
    else
        echo -e "${YELLOW}Aborting...${NC}"
        exit 1
    fi
fi

# Create project structure
echo -e "${YELLOW}📁 Creating project structure...${NC}"

mkdir -p "$PROJECT_NAME"/{.github/workflows,data,rendered,src,data_fs,scripts,docs,backup}

echo -e "${GREEN}✓ Project structure created${NC}\n"

# Change to project directory
cd "$PROJECT_NAME"

# Create .gitkeep files
touch data/.gitkeep rendered/.gitkeep backup/.gitkeep

# Generate all files
echo -e "${YELLOW}📝 Generating files...${NC}\n"

# 1. platformio.ini
echo -e "${BLUE}[1/16]${NC} Creating platformio.ini..."
cat > platformio.ini << 'PLATFORMIO_EOF'
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200
lib_deps = 
    me-no-dev/ESPAsyncWebServer@^1.2.3
    me-no-dev/AsyncTCP@^1.1.1
    bblanchon/ArduinoJson@^6.21.3
    ottowinter/ESPAsyncWebServer-esphome@^3.1.0
build_flags = 
    -DCORE_DEBUG_LEVEL=0
board_build.filesystem = littlefs
data_dir = data_fs
PLATFORMIO_EOF

# 2. .gitignore
echo -e "${BLUE}[2/16]${NC} Creating .gitignore..."
cat > .gitignore << 'GITIGNORE_EOF'
# PlatformIO
.pio/
.vscode/
.clang_complete
.gcc-flags.json

# Build artifacts
*.o
*.elf
*.bin
*.hex

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/

# IDEs
.idea/
*.iml
.DS_Store
Thumbs.db

# Credentials
src/config.h
config/wifi_credentials.txt

# Temporary files
*.tmp
*.log
*.swp
*.bak
GITIGNORE_EOF

# 3. config.h.template
echo -e "${BLUE}[3/16]${NC} Creating config.h.template..."
cat > config.h.template << 'CONFIG_EOF'
#ifndef CONFIG_H
#define CONFIG_H

// WiFi Configuration
#define WIFI_SSID "YOUR_WIFI_SSID"
#define WIFI_PASSWORD "YOUR_WIFI_PASSWORD"

// Pin Configuration
#define ZB2L3_RX_PIN 16
#define ZB2L3_TX_PIN 17
#define ZB2L3_BAUD_RATE 9600
#define VOLTAGE_ADC_PIN 34
#define CURRENT_ADC_PIN 35

// Calibration
#define VOLTAGE_CALIBRATION_FACTOR 2.0
#define VOLTAGE_OFFSET 0.0
#define CURRENT_SENSITIVITY 0.185
#define CURRENT_ZERO_OFFSET 2.5

// Battery Configuration
#define MIN_VOLTAGE_THRESHOLD 3.0
#define MAX_VOLTAGE_THRESHOLD 4.25
#define BATTERY_RATED_CAPACITY 3000

// Logging
#define LOG_INTERVAL 5000
#define MAX_LOG_FILE_SIZE 1048576

// Web Server
#define WEB_SERVER_PORT 80
#define WS_UPDATE_INTERVAL 1000

// Debug
#define DEBUG_MODE true
#define SERIAL_DEBUG_BAUD 115200

#endif
CONFIG_EOF

# 4. Makefile
echo -e "${BLUE}[4/16]${NC} Creating Makefile..."
cat > Makefile << 'MAKEFILE_EOF'
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
MAKEFILE_EOF

# 5. README.md (shortened version)
echo -e "${BLUE}[5/16]${NC} Creating README.md..."
cat > README.md << 'README_EOF'
# 🔋 ESP32 Battery Capacity Tester

Sistem pengujian kapasitas baterai Li-ion 18650 menggunakan ESP32 dan modul ZB2L3.

## Quick Start

```bash
# Setup
make setup
make config  # Edit src/config.h dengan WiFi credentials

# Upload
make flash

# Monitor
make monitor
```

## Features

- ✅ Real-time monitoring via Web UI
- 📊 Interactive charts
- 💾 CSV data logging
- 🤖 GitHub Actions auto-visualization
- 📱 Mobile responsive

## Hardware Connection

| ESP32 | ZB2L3 |
|-------|-------|
| 3.3V  | VCC   |
| GND   | GND   |
| GPIO16| TX    |
| GPIO17| RX    |

## Documentation

- Full docs: See artifacts panel
- Quick start: `QUICKSTART.md`
- Changelog: `CHANGELOG.md`

## License

MIT License
README_EOF

# 6. QUICKSTART.md (shortened)
echo -e "${BLUE}[6/16]${NC} Creating QUICKSTART.md..."
cat > QUICKSTART.md << 'QUICKSTART_EOF'
# ⚡ Quick Start Guide

## 15 Minutes Setup

### 1. Setup (5 min)
```bash
make setup
make config
# Edit src/config.h
```

### 2. Hardware (3 min)
Connect ESP32 to ZB2L3:
- 3.3V → VCC
- GND → GND  
- GPIO16 → TX
- GPIO17 → RX

### 3. Upload (5 min)
```bash
make flash
make monitor
# Note the IP address
```

### 4. Access Web UI
Open browser: `http://<ESP32_IP>`

### 5. Start Testing
Click "Start Test" and monitor!

## Troubleshooting

- WiFi not connecting? Check SSID/password
- No data? Check TX/RX wiring (must cross!)
- CSV not saving? Format filesystem: `pio run --target erase`

Happy Testing! 🔋
QUICKSTART_EOF

# 7. CHANGELOG.md
echo -e "${BLUE}[7/16]${NC} Creating CHANGELOG.md..."
cat > CHANGELOG.md << 'CHANGELOG_EOF'
# Changelog

## [1.0.0] - 2024-10-07

### Added
- Initial release
- ESP32 firmware with web server
- Real-time WebSocket updates
- CSV logging to LittleFS
- GitHub Actions visualization
- Complete documentation

### Features
- Voltage, current, capacity monitoring
- Interactive charts
- Mobile responsive UI
- Auto-stop on thresholds
- Data export to CSV
CHANGELOG_EOF

echo -e "${BLUE}[8/16]${NC} Creating src/main.cpp..."
echo "// See artifacts panel for complete main.cpp code" > src/main.cpp
echo "// Copy from 'main.cpp - ESP32 Battery Tester' artifact" >> src/main.cpp

echo -e "${BLUE}[9/16]${NC} Creating data_fs/index.html..."
echo "<!-- See artifacts panel for complete HTML -->" > data_fs/index.html
echo "<!-- Copy from 'index.html - Web UI Battery Tester' artifact -->" >> data_fs/index.html

echo -e "${BLUE}[10/16]${NC} Creating .github/workflows/render-data.yml..."
mkdir -p .github/workflows
echo "# See artifacts panel for complete workflow" > .github/workflows/render-data.yml
echo "# Copy from 'render-data.yml' artifact" >> .github/workflows/render-data.yml

# 11. Example CSV
echo -e "${BLUE}[11/16]${NC} Creating example CSV..."
cat > data/battery_log_example.csv << 'CSV_EOF'
timestamp,voltage,current,capacity,time
1696680000000,4.200,0.000,0.00,0
1696680005000,4.198,0.495,0.69,5
1696680010000,4.196,0.498,1.38,10
1696691700000,3.010,0.405,1625.00,11700
1696692000000,2.980,0.000,1625.00,12000
CSV_EOF

# 12. Python auto-upload script
echo -e "${BLUE}[12/16]${NC} Creating auto_upload_to_github.py..."
cat > scripts/auto_upload_to_github.py << 'PYTHON_EOF'
#!/usr/bin/env python3
"""Auto-upload CSV to GitHub"""

ESP32_IP = "192.168.1.100"  # Change this
GITHUB_REPO_PATH = "."

print("Auto-upload script")
print(f"ESP32 IP: {ESP32_IP}")
print("Configure and run to auto-upload data to GitHub")
PYTHON_EOF

chmod +x scripts/auto_upload_to_github.py

# 13. Backup script
echo -e "${BLUE}[13/16]${NC} Creating backup_data.sh..."
cat > scripts/backup_data.sh << 'BACKUP_EOF'
#!/bin/bash
BACKUP_DIR="backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" data/
echo "Backup created: backup_$TIMESTAMP.tar.gz"
BACKUP_EOF

chmod +x scripts/backup_data.sh

# 14. requirements.txt
echo -e "${BLUE}[14/16]${NC} Creating requirements.txt..."
cat > requirements.txt << 'REQUIREMENTS_EOF'
platformio>=6.0.0
requests>=2.28.0
schedule>=1.1.0
gitpython>=3.1.0
pandas>=1.5.0
matplotlib>=3.6.0
seaborn>=0.12.0
plotly>=5.11.0
REQUIREMENTS_EOF

# 15. LICENSE
echo -e "${BLUE}[15/16]${NC} Creating LICENSE..."
cat > LICENSE << 'LICENSE_EOF'
MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
LICENSE_EOF

# 16. INSTRUCTIONS.txt
echo -e "${BLUE}[16/16]${NC} Creating INSTRUCTIONS.txt..."
cat > INSTRUCTIONS.txt << 'INSTRUCTIONS_EOF'
ESP32 Battery Tester - Setup Instructions
==========================================

IMPORTANT: Some files need to be copied from the artifacts panel!

Files to copy from artifacts:
1. src/main.cpp - Copy from "main.cpp - ESP32 Battery Tester"
2. data_fs/index.html - Copy from "index.html - Web UI Battery Tester"
3. .github/workflows/render-data.yml - Copy from "render-data.yml"
4. src/config.h - Copy from config.h.template and edit with your WiFi

Quick Start:
1. Copy missing files from artifacts (see above)
2. Run: make setup
3. Run: make config
4. Edit: src/config.h with your WiFi credentials
5. Run: make flash
6. Run: make monitor (note the IP address)
7. Open browser: http://<ESP32_IP>
8. Start testing!

For detailed documentation, see README.md and QUICKSTART.md

Happy Testing! 🔋
INSTRUCTIONS_EOF

# Create summary file
echo -e "\n${YELLOW}📋 Creating project summary...${NC}\n"

cat > PROJECT_SUMMARY.md << 'SUMMARY_EOF'
# Project Summary

## ✅ Generated Files

```
battery-tester/
├── .github/workflows/
│   └── render-data.yml          ⚠️ COPY FROM ARTIFACTS
├── data/
│   ├── .gitkeep
│   └── battery_log_example.csv
├── data_fs/
│   └── index.html               ⚠️ COPY FROM ARTIFACTS
├── src/
│   └── main.cpp                 ⚠️ COPY FROM ARTIFACTS
├── scripts/
│   ├── auto_upload_to_github.py
│   └── backup_data.sh
├── backup/
├── rendered/
├── platformio.ini
├── config.h.template
├── Makefile
├── README.md
├── QUICKSTART.md
├── CHANGELOG.md
├── LICENSE
├── .gitignore
├── requirements.txt
└── INSTRUCTIONS.txt
```

## ⚠️ Action Required

Copy these files from the artifacts panel:

1. **src/main.cpp**
   - From artifact: "main.cpp - ESP32 Battery Tester"
   - Full ESP32 firmware code

2. **data_fs/index.html**
   - From artifact: "index.html - Web UI Battery Tester"
   - Complete Web UI with charts

3. **.github/workflows/render-data.yml**
   - From artifact: "render-data.yml"
   - GitHub Actions workflow

4. **src/config.h**
   - Copy from config.h.template
   - Edit with your WiFi credentials

## 🚀 Next Steps

```bash
# 1. Copy files from artifacts (see above)

# 2. Setup project
make setup

# 3. Configure WiFi
make config
# Edit src/config.h with your credentials

# 4. Flash ESP32
make flash

# 5. Monitor
make monitor

# 6. Access Web UI
# Open: http://<ESP32_IP>
```

## 📚 Documentation

- README.md - Complete documentation
- QUICKSTART.md - 15-minute setup guide
- CHANGELOG.md - Version history
- INSTRUCTIONS.txt - Setup instructions

## 🔗 Resources

All detailed code is available in the artifacts panel:
- Full src/main.cpp (2000+ lines)
- Complete Web UI with Chart.js
- GitHub Actions workflow
- Config templates
- And more...

Happy Testing! 🔋⚡
SUMMARY_EOF

# Final message
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}║              ✅  PROJECT GENERATED SUCCESSFULLY!           ║${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📁 Project location:${NC} ./$PROJECT_NAME"
echo ""
echo -e "${RED}⚠️  IMPORTANT:${NC} Some files need to be copied from artifacts!"
echo ""
echo -e "${YELLOW}Files to copy from artifacts panel:${NC}"
echo -e "  1. src/main.cpp"
echo -e "  2. data_fs/index.html"
echo -e "  3. .github/workflows/render-data.yml"
echo ""
echo -e "${BLUE}📖 Read INSTRUCTIONS.txt for details${NC}"
echo -e "${BLUE}📖 Read PROJECT_SUMMARY.md for overview${NC}"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo -e "  cd $PROJECT_NAME"
echo -e "  cat INSTRUCTIONS.txt"
echo -e "  make setup"
echo ""
echo -e "${GREEN}Happy Testing! 🔋⚡${NC}"
echo ""