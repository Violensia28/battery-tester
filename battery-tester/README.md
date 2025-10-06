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
