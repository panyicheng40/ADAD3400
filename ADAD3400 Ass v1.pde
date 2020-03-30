Pattern pt;
float angle = 0.0;
int loop = 1000;
int base = -100;
boolean mv = true;

void setup(){
  fullScreen();
  frameRate(25);
}

void draw() {
  // reset the background 
  background (255);
  
  // create the moving ellipses
  noFill();
  stroke(0);
  strokeWeight(14);
  for(int n = loop; n < width+900; n += 30+(mouseY/108*10))
    ellipse(width/2, height/2, n+mouseX/5-500, n-mouseX/5-100);
  loop += 5;
  if (loop == 1125) loop = 1000;
  
  // create a white cycle base
  fill(255);
  stroke(0);
  ellipse(width/2, height/2, 1008, 1008);
  
  // create the moving lines
  stroke(0);
  strokeWeight(7);
  for(int i = base; i < height+200; i += (10+mouseY/20)) {
    line(0, i, width/2, i-40+mouseX/20);
    line(width/2, i-40+mouseX/20, width, i);
  }
  base += 5;
  if (base == -40) base = -100;
  
  // create a base which can be controlled to disappear
  if(mv) {
    fill(255);
    stroke(0);
    ellipse(width/2, height/2, 1008, 1008);
  }
  
  // create the middle Moire illusion
  pushMatrix();
  translate(width/2, height/2);
  for (int i = 0; i < 180; i++) {
    rotate(PI/90);
    fill (0);
    noStroke ();
    triangle (0, 0, 500, -2.5, 500, 2.5);
  }
  angle += 0.004;
  rotate (angle); 
  pt = new Pattern(7, 7);
  pt.display();
  popMatrix();
  noFill();
  stroke(0);
  strokeWeight(28);
  ellipse(width/2, height/2, 1008, 1008);
  
  // create a textbar to display the status
  fill(0);
  rect(0,0,width,15);
  fill(255);
  textAlign(LEFT,TOP);
  text("fps = "+round(frameRate),40,0);
  if(mv){
  fill(255,0,0);
  text("Occlusion",100,0);
  }
  if(!mv){
  text("Transparent",100,0);
}
}
 
class Pattern {
  float p1, p2;
  Pattern(float p1_, float p2_) {
    p1 = p1_;
    p2 = p2_;
  }
  void display() {
    pushMatrix();
    translate(p1, p2);
    for (int i = 0; i < 180; i++) {
      rotate(PI/90);
      fill (0);
      noStroke ();
      triangle (0, 0, 500, -2.5, 500, 2.5);
    }
    popMatrix();
  }
}

void mousePressed(){
  mv = !mv;
}
