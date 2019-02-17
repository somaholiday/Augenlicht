void setup() {
  size(500, 500);
  smooth(8); 
}

void draw() {
  background(0);
  noFill();
  translate(width/2, height/2);
  
  int[] radii = new int[] {120, 150, 175, 200, 225};
  for (int r : radii) {
    stroke(255);
    ellipse(0, 0, r, r);
    stroke(255, 0, 0);
    ellipse(0, 0, r+2, r+2);
  }
  
  rotate(radians(45));
  stroke(255);
  rectMode(CENTER);
  int len = 300;
  rect(0, 0, len, len);
  
  drawFPS();
}

void drawFPS() {
  if (frameCount % 60 == 0) {
    surface.setTitle("FPS : " + nf(frameRate, 2, 4));
  }
}