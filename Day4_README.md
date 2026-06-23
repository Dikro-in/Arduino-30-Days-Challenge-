# 🕹️ Arduino Arcade Reaction Timer Game (Day 4)

Welcome to Day 4 of learning Arduino! This repository contains the source code for a dynamic, reaction-based hardware arcade game built using an Arduino Uno.

## 🚀 How the Game Works
1. **The Loop:** 5 LEDs cascade back and forth in a ping-pong sequence.
2. **Speed Control:** A potentiometer alters the clock speed of the game dynamically.
3. **The Target:** The center LED (Yellow) is the target.
4. **Win Condition:** Pressing the button exactly on the Yellow LED freezes it and turns off all other lights.
5. **Fail Condition:** Pressing the button on any Red LED causes all Red LEDs to flash together while the Yellow target stays dead.

## 🔌 Hardware Setup & Wiring

| Component | Arduino Pin | Notes |
| :--- | :--- | :--- |
| **LED 1 (Red)** | Digital Pin 3 | PWM Pin |
| **LED 2 (Red)** | Digital Pin 5 | PWM Pin |
| **LED 3 (Yellow)** | Digital Pin 4 | **Target LED** |
| **LED 4 (Red)** | Digital Pin 9 | PWM Pin |
| **LED 5 (Red)** | Digital Pin 11 | PWM Pin |
| **Push Button** | Digital Pin 7 | Uses internal `INPUT_PULLUP` |
| **Potentiometer**| Analog Pin A0 | Reads speed configuration |

> ⚠️ **Note:** To prevent lens flare on cameras while shooting videos, the code limits the LED brightness to ~50% (`120` out of `255`) using PWM (`analogWrite`).

## 🛠️ Installation & Upload
1. Clone this repository or copy the code from `Arcade_Game.ino`.
2. Open it in the **Arduino IDE**.
3. Connect your Arduino Uno to your laptop.
4. Select the correct COM port and board layout.
5. Click **Upload** 🚀.

Stay tuned for Day 5!
