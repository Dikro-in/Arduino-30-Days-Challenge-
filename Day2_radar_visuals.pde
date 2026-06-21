import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;

Serial myPort; 
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;

void setup() {
  size (1200, 700); // Screen Resolution
  smooth();
  // MAC FIX: Looks for your active Arduino USB port dynamically
  String portName = Serial.list()[4]; 
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('.'); 
  printArray(Serial.list());
}

void draw() {
  fill(0, 4); 
  rect(0, 0, width, height-height*0.065); 
  
  fill(98, 245, 31); // Glowing Radar Green Color
  // Draw the radar lines
  drawRadar(); 
  drawLine(); 
  drawObject();
  drawText();
}

void serialEvent (Serial myPort) { 
  data = myPort.readStringUntil('.');
  data = data.substring(0, data.length()-1);
  
  index1 = data.indexOf(","); 
  angle= data.substring(0, index1); 
  distance= data.substring(index1+1, data.length()); 
  
  iAngle = int(angle);
  iDistance = int(distance);
}

void drawRadar() {
  pushMatrix();
  translate(width/2, height-height*0.074); 
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);
  // Draw the concentric measurement arcs
  arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI);
  arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
  arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
  arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);
  // Draw angle grid lines
  line(-width/2, 0, width/2, 0);
  for (int i=30; i<=150; i+=30) {
    line(0, 0, (-width/2)*cos(radians(i)), (-width/2)*sin(radians(i)));
  }
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width/2, height-height*0.074);
  strokeWeight(9);
  stroke(255, 10, 10); // Red color for detected targets!
  pixsDistance = iDistance * ((width - width * 0.0625) / 2 / 40); 
  if(iDistance < 40) {
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)), (width/2-width*0.05) * cos(radians(iAngle)), -(width/2-width*0.05) * sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  translate(width/2, height-height*0.074);
  strokeWeight(9);
  stroke(30, 250, 60); // Dynamic sweep line
  line(0, 0, (width/2-width*0.05)*cos(radians(iAngle)), -(width/2-width*0.05)*sin(radians(iAngle)));
  popMatrix();
}

void drawText() {
  // Screen overlay details
  fill(0);
  noStroke();
  rect(0, height-height*0.065, width, height);
  fill(98, 245, 31);
  textSize(20);
  text("10cm", width/2+width*0.115, height-height*0.083);
  text("20cm", width/2+width*0.22, height-height*0.083);
  text("30cm", width/2+width*0.32, height-height*0.083);
  text("40cm", width/2+width*0.42, height-height*0.083);
  textSize(40);
  text("Angle: " + iAngle + " °", width*0.05, height-height*0.02);
  text("Distance: " + (iDistance > 40 ? 0 : iDistance) + " cm", width*0.4, height-height*0.02);
}
