#include <Servo.h>

const int trigPin = 9;
const int echoPin = 10;
Servo signServo;

int minutes = 25;
int seconds = 0;
bool timerRunning = false;
unsigned long lastTick = 0;
unsigned long lastWaveTime = 0; // Tracks precise wave timing

// Safe mechanical angles
const int downAngle = 10;  
const int upAngle = 195;   

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  
  signServo.attach(4); 
  signServo.write(downAngle); // Set starting default position
  
  Serial.println("===========================");
  Serial.println("   HANDS-FREE FOCUS TIMER   ");
  Serial.println("===========================");
  Serial.println("Status: WAVE HAND TO START");
}

void loop() {
  long duration;
  int distance;
  
  // Quick, clean sensor pulse
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  duration = pulseIn(echoPin, HIGH, 20000);
  distance = duration * 0.034 / 2;
  
  // Non-blocking gesture control (Must wait 1.5 seconds between waves)
  if (distance > 0 && distance <= 15 && (millis() - lastWaveTime > 1500)) {
    timerRunning = !timerRunning;
    lastWaveTime = millis(); // Lock out instant double-triggers
    
    if (timerRunning) {
      Serial.println("\n[!] SESSION STARTED");
      signServo.write(upAngle); // Snap immediately to UP position
    } else {
      Serial.println("\n[||] SESSION PAUSED");
      signServo.write(downAngle); // Snap immediately to DOWN position
    }
  }
  
  // Clock processing logic
  if (timerRunning) {
    if (millis() - lastTick >= 1000) {
      lastTick = millis();
      
      if (seconds == 0) {
        if (minutes == 0) {
          timerRunning = false;
          Serial.println("\n🎉 WORK DONE! TAKE A BREAK! 🎉");
          signServo.write(downAngle);
          while(true);
        } else {
          minutes--;
          seconds = 59;
        }
      } else {
        seconds--;
      }
      
      Serial.print("Time Left: ");
      if (minutes < 10) Serial.print("0");
      Serial.print(minutes);
      Serial.print(":");
      if (seconds < 10) Serial.print("0");
      Serial.println(seconds);
    }
  }
}
