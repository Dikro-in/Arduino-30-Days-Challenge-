#include <Servo.h>

const int trigPin = 10;
const int echoPin = 11;
const int buzzerPin = 4;
const int servoPin = 9;

Servo myServo;

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buzzerPin, OUTPUT);
  myServo.attach(servoPin);
  Serial.begin(9600);
}

void loop() {
  // Left to Right Sweep
  for (int i = 15; i <= 165; i += 3) {  
    myServo.write(i);
    delay(45);
    int distance = calculateDistance();
    
    // Processing needs exactly this structure to parse angles
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
  // Right to Left Sweep
  for (int i = 165; i >= 15; i -= 3) {  
    myServo.write(i);
    delay(45);
    int distance = calculateDistance();
    
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}

int calculateDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  long duration = pulseIn(echoPin, HIGH, 20000);
  int dist = duration * 0.034 / 2;
  return dist;
}
