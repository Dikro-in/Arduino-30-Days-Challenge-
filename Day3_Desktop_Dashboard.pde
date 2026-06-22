import processing.serial.*;

Serial myPort;
String timeString = "25:00";
String statusString = "STANDBY MODE";
boolean isRunning = false;

// Animation & UI variables
float currentProgress = 1.0; 
float targetProgress = 1.0;
color bgDark = color(15, 17, 23);       // Cyberpunk deep slate
color accentNeon = color(0, 230, 118);  // Emerald active glow
color accentOff = color(255, 61, 0);    // Crimson standby glow
float colorFade = 0.0;
float waveAngle = 0;

void setup() {
  size(800, 550);
  
  // Find your Arduino port safely
  try {
    String portName = Serial.list()[4]; 
    myPort = new Serial(this, portName, 9600);
    myPort.bufferUntil('\n');
  } catch (Exception e) {
    println("Serial Port setup skipped or not found.");
  }
}

void draw() {
  background(bgDark);
  
  // 1. ANIMATION MATH
  if (isRunning) {
    colorFade = lerp(colorFade, 1.0, 0.08);
  } else {
    colorFade = lerp(colorFade, 0.0, 0.08);
  }
  color currentAccent = lerpColor(accentOff, accentNeon, colorFade);
  
  try {
    String[] parts = split(timeString, ':');
    float totalSecs = int(parts[0]) * 60 + int(parts[1]);
    targetProgress = totalSecs / (25.0 * 60.0);
  } catch(Exception e) { }
  currentProgress = lerp(currentProgress, targetProgress, 0.1);

  // 2. DRAW HEADER GRID
  stroke(35, 41, 55);
  line(0, 70, width, 70);
  
  fill(255, 230);
  textSize(16);
  textAlign(LEFT);
  text("NEURAL_CORE_OS // v4.2", 40, 42);
  
  textAlign(RIGHT);
  fill(currentAccent);
  noStroke();
  ellipse(width - 150, 36, 10, 10);
  fill(150);
  text(statusString, width - 40, 42);

  // 3. DRAW MAIN ADVANCED GLOWING RADIAL TIMER
  pushMatrix();
  translate(width/2 - 120, height/2 + 20);
  
  // Outer track ring
  noFill();
  stroke(28, 33, 46);
  strokeWeight(12);
  ellipse(0, 0, 240, 240);
  
  // Dynamic Progress Arc Glow
  stroke(currentAccent, 40); 
  strokeWeight(20);
  arc(0, 0, 240, 240, -HALF_PI, -HALF_PI + (TWO_PI * currentProgress));
  
  stroke(currentAccent);
  strokeWeight(12);
  strokeCap(ROUND);
  arc(0, 0, 240, 240, -HALF_PI, -HALF_PI + (TWO_PI * currentProgress));
  
  // Giant Central Numbers
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(64);
  text(timeString, 0, -5);
  textSize(12);
  fill(120);
  text("REMAINING", 0, 35);
  popMatrix();

  // 4. SIDEBAR PANEL: METRICS & WIREFRAME VISUALIZATIONS
  int panelX = width - 240;
  stroke(35, 41, 55);
  line(panelX, 70, panelX, height);
  
  // Sub-panel metric cards
  drawMetricCard(panelX + 20, 110, "DAILY GOAL", "75% COMPLETE", currentAccent);
  drawMetricCard(panelX + 20, 200, "CURRENT STREAK", "4 SESSIONS", color(0, 176, 255));
  
  // Brainwave Simulation Wireframe
  fill(120);
  textSize(11);
  textAlign(LEFT);
  text("FOCUS MONITORING WAVEFORM", panelX + 20, 310);
  noFill();
  stroke(currentAccent, 100);
  strokeWeight(1.5);
  beginShape();
  for (int x = panelX + 20; x < width - 20; x++) {
    float y = 370 + sin(waveAngle + (x * 0.05)) * (isRunning ? 25 : 4);
    vertex(x, y);
  }
  endShape();
  waveAngle += isRunning ? 0.07 : 0.01;
}

void drawMetricCard(int x, int y, String label, String value, color valColor) {
  fill(24, 29, 41);
  noStroke();
  rect(x, y, 200, 65, 6);
  fill(120);
  textSize(11);
  text(label, x + 15, y + 22);
  fill(valColor);
  textSize(16);
  text(value, x + 15, y + 48);
}

void serialEvent(Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    if (inString.equals("[!] SESSION STARTED")) {
      isRunning = true;
      statusString = "FOCUS MODE ACTIVE";
    } else if (inString.equals("[||] SESSION PAUSED")) {
      isRunning = false;
      statusString = "SYSTEM PAUSED";
    } else if (inString.startsWith("Time Left: ")) {
      timeString = inString.replace("Time Left: ", "");
    } else if (inString.contains("WORK DONE")) {
      isRunning = false;
      timeString = "00:00";
      statusString = "BREAK TIME";
    }
  }
}
