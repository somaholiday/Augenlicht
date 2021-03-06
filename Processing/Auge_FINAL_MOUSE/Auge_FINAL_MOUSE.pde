// LEDs
OPC opc;

// LEAP
float lastX, lastY;
PImage texture;
Ring rings[];

// DEMO MODE
String[] demoImageFiles = new String[] {
  "bokeh.jpeg", 
  "flames.jpeg", 
  //  "gradients.jpeg", 
  //  "lines.jpeg", 
  //  "painting.jpeg", 
  "rainbow1.jpeg", 
  "rainbow2.jpeg", 
  "rainbow3.jpeg", 
  "rainbow4.jpeg", 
  "rainbow5.jpeg"
};

PImage[] demoImages;

int currentImage = 0;

boolean demoMode = false;
int demoDuration = 0;

int timeSinceInteraction = 0;
final int TIME_BEFORE_DEMO_MODE = 60 * 5; // frames
final int DEMO_FADE_TIME = 60 * 3;        // frames

int lastFingerCount = 0;

void setup() {
  size(800, 400, P2D);

  colorMode(HSB, 100);

  initLEDs();
  initMouseImages();
  initDemoImages();
}

void initLEDs() {
  opc = new OPC(this, "127.0.0.1", 7890);
  
  opc.setStatusLed(false);
  opc.showLocations(true);

  // (start index, num_leds, center_x, center_y, radius, rotation)
  opc.ledRing(64*0, 42, width/2, height/2, 225/2, 3*PI/2 + 0.02);
  opc.ledRing(64*1, 38, width/2, height/2, 200/2, 3*PI/2);
  opc.ledRing(64*2, 33, width/2, height/2, 175/2, 3*PI/2);
  opc.ledRing(64*3, 28, width/2, height/2, 150/2, 3*PI/2);
  opc.ledRing(64*3+28, 23, width/2, height/2, 120/2, 3*PI/2);
}

void initMouseImages() {
  texture = loadImage("ring.png");

  // We can have up to 100 rings. They all start out invisible.
  rings = new Ring[100];
  for (int i = 0; i < rings.length; i++) {
    rings[i] = new Ring();
  }
}

void initDemoImages() {
  demoImages = new PImage[demoImageFiles.length];

  String fileName = "";
  for (int i=0; i < demoImageFiles.length; i++) {
    fileName = demoImageFiles[i];
    demoImages[i] = loadImage(fileName);
  }

  currentImage = floor(random(demoImages.length));
}

//////////////////
//  D  R  A  W  //
//////////////////

void draw() {
  background(0);

  if (lastX == mouseX && lastY == mouseY) {
    timeSinceInteraction++;
    //if (timeSinceInteraction % 60 == 0) {
    //  println(timeSinceInteraction);
    //}
  } else {
    timeSinceInteraction = 0;
    demoMode = false; 
  }
  
  // switch to demoMode and pick a new Image
  if (timeSinceInteraction > TIME_BEFORE_DEMO_MODE && !demoMode) {
    //println("DEMO MODE");
    demoMode = true;
    currentImage = (currentImage + 1) % demoImageFiles.length;
    demoDuration = 0;
  }

  if (demoMode) {
    drawImageMapping();
  } else {
    drawMouse();
  }
  
  lastX = mouseX;
  lastY = mouseY;

  drawFPS();
}

void drawImageMapping()
{
  blendMode(BLEND);
  noTint();
  demoDuration = constrain(demoDuration, 0, DEMO_FADE_TIME);
  float bri = map(demoDuration, 0, DEMO_FADE_TIME, 0, 0.8);
  opc.setColorCorrection(2.5, bri, bri, bri);

  PImage img = demoImages[currentImage];

  // Scale the image so that it matches the width of the window
  int imHeight = img.height * width / img.width;

  // Scroll down slowly, and wrap around
  float speed = 0.05;
  float y = (millis() * -speed) % imHeight;

  // Use two copies of the image, so it seems to repeat infinitely  
  image(img, 0, y, width, imHeight);
  image(img, 0, y + imHeight, width, imHeight);
  
  demoDuration++;
}

void drawMouse() {
  blendMode(ADD);
  float bri = 0.8;
  opc.setColorCorrection(2.5, bri, bri, bri);
  background(0);

  float x = mouseX;
  float y = mouseY;

  float smoothX = lastX + (x - lastX) * 0.2;
  float smoothY = lastY + (y - lastY) * 0.2;

  rings[int(random(rings.length))].respawn(lastX, lastY, smoothX, smoothY);

  lastX = smoothX;
  lastY = smoothY;

  // Give each ring a chance to redraw and update
  for (int i = 0; i < rings.length; i++) {
    rings[i].draw();
  }
}

void drawFPS() {
  if (frameCount % 60 == 0) {
    surface.setTitle("FPS : " + nf(frameRate, 2, 4));
  }
}

void keyPressed() {
  currentImage = (currentImage + 1) % demoImageFiles.length;
}