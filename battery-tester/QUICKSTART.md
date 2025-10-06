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
