/*
  Arduino Arcade Reaction Game - Day 4
  Pins Used: 
  LEDs: 3, 5, 4, 9, 11 (PWM control for 50% dimmed brightness)
  Button: Pin 7 (INPUT_PULLUP)
  Potentiometer: Analog A0 (Speed Control)
*/

const int ledPins[] = {3, 5, 4, 9, 11}; 
const int buttonPin = 7;               
const int potPin = A0;
const int dimBrightness = 120; // 50% Dim for camera-friendly shots

int currentLED = 0;
int direction = 1; 
bool gamePlaying = true;

void setup() {
  Serial.begin(115200);
  for (int i = 0; i < 5; i++) {
    pinMode(ledPins[i], OUTPUT);
  }
  pinMode(buttonPin, INPUT_PULLUP); 
}

void loop() {
  int speed = map(analogRead(potPin), 0, 1023, 30, 300);

  if (gamePlaying) {
    for (int i = 0; i < 5; i++) {
      analogWrite(ledPins[i], 0);
    }
    
    analogWrite(ledPins[currentLED], dimBrightness);

    if (digitalRead(buttonPin) == LOW) {
      gamePlaying = false; 
      
      if (currentLED == 2) { // Index 2 is Pin 4 (Yellow Target)
        Serial.println("🏆 WINNER!");
        winCelebration();
      } else {
        Serial.println("❌ GAME OVER!");
        failBlinkExceptThree();
      }
    }

    currentLED += direction;
    if (currentLED == 4 || currentLED == 0) {
      direction = -direction; 
    }

    delay(speed);
  } else {
    if (digitalRead(buttonPin) == LOW) {
      delay(400); 
      gamePlaying = true;
    }
  }
}

void winCelebration() {
  for (int i = 0; i < 5; i++) {
    if (i == 2) {
      analogWrite(ledPins[i], dimBrightness); 
    } else {
      analogWrite(ledPins[i], 0);             
    }
  }
}

void failBlinkExceptThree() {
  for (int blinkCount = 0; blinkCount < 5; blinkCount++) {
    for (int j = 0; j < 5; j++) {
      if (j != 2) {
        analogWrite(ledPins[j], dimBrightness);
      } else {
        analogWrite(ledPins[j], 0); 
      }
    }
    delay(200);
    for (int j = 0; j < 5; j++) {
      analogWrite(ledPins[j], 0);
    }
    delay(200);
  }
}
