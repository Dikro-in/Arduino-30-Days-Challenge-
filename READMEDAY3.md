# Hands-Free Desk Productivity Dashboard ⏳

An interactive, gesture-controlled Pomodoro timer that merges custom hardware control with a premium desktop dashboard interface. Built for developers and study setups.

## 🚀 Features
* **Contactless Control:** Wave your hand over an ultrasonic sensor to start, pause, or reset your session.
* **Physical Hardware Indicator:** An automated servo motor mechanically flips up a "STUDY TIME" flag when your session is live.
* **Premium Desktop App UI:** Written in Processing (Java), featuring smooth animations, a circular countdown tracker, and an oscillating live data wireframe waveform.

## 🛠️ Components Used
* Arduino Uno R3 / R4
* HC-SR04 Ultrasonic Sensor
* SG90 Micro Servo Motor
* Processing 4 IDE (For the Desktop Application)

## 📐 Wiring Guide
* **Ultrasonic Sensor:** `Trig` ➡️ Pin 9 | `Echo` ➡️ Pin 10
* **Servo Motor (Signal):** `Orange Wire` ➡️ Pin 3
* **Power:** Connect all `VCC/5V` and `GND` lines to your Arduino power rails.

## 💻 How To Run
1. Upload `Gesture_Timer.ino` to your Arduino board.
2. Ensure your Arduino Serial Monitor is closed.
3. Open `Desktop_Dashboard.pde` in Processing, update the port index line `Serial.list()[1]` to match your device's USB port, and hit **Run**.
