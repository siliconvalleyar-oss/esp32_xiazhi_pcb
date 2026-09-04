# XiaoZhi - Asistente de Voz con ESP32-C6 (Versión Multisensor)

![KiCad Version](https://img.shields.io/badge/KiCad-8.0+-blue.svg)
![ESP32-C6](https://img.shields.io/badge/ESP32-C6-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

Repositorio del diseño PCB para el dispositivo **XiaoZhi**, una estación de desarrollo y asistente de voz de código abierto basado en el **ESP32-C6**. Este diseño integra audio digital de alta calidad, iluminación RGB, pantalla OLED, **pantalla TFT**, **sensores ambientales (gas, temperatura/humedad, distancia)** y **comunicación CAN** en una sola placa diseñada con **KiCad**.

---

## 📖 Descripción

XiaoZhi evoluciona para convertirse en un nodo IoT multisensor ideal para automatización del hogar, monitoreo industrial o robótica. Además de la interacción por voz (micrófono y altavoz), la placa incorpora:

- **MQ-6**: Detección de gases combustibles (LPG, butano, metano).
- **AHT21B**: Medición precisa de temperatura y humedad ambiental (I2C).
- **VL53L0X**: Sensor de distancia por tiempo de vuelo (ToF) de hasta 2 metros.
- **ST7789**: Pantalla TFT a color para gráficos avanzados (SPI).
- **MCP2515**: Controlador CAN bus (con transceptor) para comunicación vehicular o industrial.

Todo ello manteniendo la conectividad Wi-Fi 6, BLE 5.0 y la interfaz USB-UART integrada.

---

## ✨ Características Principales

- **Microcontrolador**: ESP32-C6 (RISC-V dual-core, Wi-Fi 6, BLE 5.0, Zigbee/Thread).
- **Audio**:
  - Micrófono MEMS **INMP441** (I2S).
  - Amplificador **MAX98357A** (I2S) para altavoz externo.
- **Interfaz y depuración**: **FT232** integrado para USB-UART.
- **Iluminación y control**:
  - LED GPIO estándar y LED direccionable **WS2812**.
  - Pulsadores (BOOT y RESET).
- **Pantallas**:
  - **SSD1306** (OLED 128x64, I2C) para información rápida.
  - **ST7789** (TFT a color, SPI) para gráficos, menús o visualización de datos.
- **Sensores**:
  - **MQ-6** (gas) – Salida analógica (ADC).
  - **AHT21B** (temperatura/humedad) – I2C.
  - **VL53L0X** (distancia ToF) – I2C.
- **Comunicación industrial**:
  - **MCP2515** + transceptor CAN (SPI) para bus CAN 2.0.
- **Alimentación**: 5V vía USB-C, con reguladores internos para 3.3V.

---

## 📦 Lista de Componentes (BOM)

| Componente | Cantidad | Descripción | Referencia en PCB |
| :--- | :--- | :--- | :--- |
| ESP32-C6-WROOM-1 | 1 | Módulo Wi-Fi/BLE/Zigbee | U1 |
| INMP441 | 1 | Micrófono MEMS I2S | U2 |
| MAX98357A | 1 | Amplificador Clase D I2S | U3 |
| FT232RL (o FT232RQ) | 1 | Conversor USB-UART | U4 |
| WS2812B | 1 (o N) | LED RGB direccionable | D1 |
| LED (GPIO) | 1 | LED indicador estándar | D2 |
| SWITCH (Push Button) | 2 | Pulsadores (BOOT y RESET) | SW1, SW2 |
| SSD1306 (I2C) | 1 | Display OLED de 0.96" | OLED1 |
| **MQ-6** | **1** | **Sensor de gas (LPG, butano, metano)** | **U6** |
| **AHT21B** | **1** | **Sensor de temperatura y humedad (I2C)** | **U7** |
| **VL53L0X** | **1** | **Sensor de distancia ToF (Time-of-Flight)** | **U8** |
| **ST7789** | **1** | **Pantalla TFT a color (SPI) - 1.3" / 1.54"** | **U9** |
| **MCP2515** | **1** | **Controlador CAN (SPI) + TJA1050 (transceptor)** | **U10** |
| Regulador 3.3V (AMS1117) | 1 | LDO para alimentación interna | U5 |
| Cristal 40MHz | 1 | Oscilador para FT232 (según esquema) | X1 |
| Resistencias, Capacitores, Conectores | Varios | Pasivos y terminales (USB-C, JST) | - |

---

## 🔌 Asignación de Pines (Pinout)

> **⚠️ Importante**: La siguiente tabla es una referencia estándar. Verifica siempre el esquemático (`*.sch`) para confirmar las conexiones finales.

| Periférico | Pin del ESP32-C6 | Descripción / Notas |
| :--- | :--- | :--- |
| **INMP441 (Mic)** | GPIO3 (I2S_BCK) | Bit Clock |
| | GPIO2 (I2S_WS) | Word Select (LRCLK) |
| | GPIO1 (I2S_DIN) | Data Output (DOUT) |
| | 3.3V / GND | Alimentación |
| **MAX98357A (Amp)** | GPIO3 (I2S_BCK) | Bit Clock (compartido) |
| | GPIO2 (I2S_WS) | Word Select (compartido) |
| | GPIO4 (I2S_DOUT) | Data Input (DIN) |
| | GPIO5 | Shutdown (SD) - Activo bajo |
| | 5V / GND | Alimentación |
| **WS2812** | GPIO6 | Data Input |
| | 5V / GND | Alimentación |
| **SSD1306 (OLED) / AHT21B / VL53L0X** | GPIO7 (I2C_SCL) | Bus I2C compartido (SCL) |
| | GPIO8 (I2C_SDA) | Bus I2C compartido (SDA) |
| | 3.3V / GND | Alimentación (todas comparten bus) |
| **FT232 (UART)** | GPIO9 (RX) | RX del ESP (conectar a TX del FT) |
| | GPIO10 (TX) | TX del ESP (conectar a RX del FT) |
| | GPIO11 (DTR) | Auto-reset (opcional) |
| **SWITCH BOOT** | GPIO12 | Boot (GPIO0 en otros chips, verificar) |
| **SWITCH RESET** | CHIP_EN | Reset (EN) |
| **LED GPIO** | GPIO13 | Ánodo del LED (con resistencia) |
| **MQ-6 (Gas)** | **GPIO14** | **Salida analógica (ADC)** |
| **ST7789 (TFT)** | **GPIO15 (SPI_MOSI)** | **Master Out / Slave In** |
| | **GPIO16 (SPI_SCLK)** | **Clock SPI** |
| | **GPIO17 (DC)** | **Data/Command** |
| | **GPIO18 (CS)** | **Chip Select (activo bajo)** |
| | **GPIO19 (RST)** | **Reset de la pantalla** |
| **MCP2515 (CAN)** | **GPIO15 (SPI_MOSI)** | **Comparte MOSI con TFT** |
| | **GPIO16 (SPI_SCLK)** | **Comparte SCLK con TFT** |
| | **GPIO20 (CS)** | **Chip Select exclusivo para CAN** |
| | **GPIO21 (INT)** | **Interrupción del MCP2515** |
| | 5V / GND | Alimentación (transceptor CAN) |

---

## 🧩 Integración de Sensores y Bus Compartido

Para optimizar los pines del ESP32-C6, el diseño utiliza buses compartidos:

- **Bus I2C (GPIO7 y GPIO8)**: Conecta simultáneamente el **SSD1306**, el **AHT21B** y el **VL53L0X**. Cada dispositivo tiene una dirección I2C única, por lo que no hay conflicto.
- **Bus SPI (GPIO15 y GPIO16)**: Conecta el **ST7789** y el **MCP2515**. Se diferencian mediante pines **CS (Chip Select)** independientes (GPIO18 para TFT, GPIO20 para CAN).
- **ADC (GPIO14)**: Reservado exclusivamente para la salida analógica del sensor de gas **MQ-6**. Se recomienda agregar un capacitor de filtrado en la PCB para estabilizar la lectura.

---

## 🛠️ Uso del Proyecto en KiCad

### Requisitos
- KiCad **v8.0** o superior.
- Símbolos y huellas adicionales para los nuevos componentes (es posible que necesites descargar librerías externas para el MCP2515, VL53L0X o ST7789).

### Abrir y Editar
1. Clona este repositorio:
   ```bash
   git clone https://github.com/tu-usuario/xiaozhi-pcb.git
   cd xiaozhi-pcb
