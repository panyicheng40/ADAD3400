import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Pattern pt;
float angle = 0.0;
int loop = 1000;
int base = -100;
boolean mv = true;
float getX = 0;
float getY = 0;

void setup(){
  fullScreen();
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 3000 */
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}

void draw() {
  
  // reset the background 
  background (255);
  
  // create the moving ellipses
  noFill();
  stroke(0);
  strokeWeight(14);
  for(int n = loop; n < width+900; n += 30+(getY/108*10))
    ellipse(width/2, height/2, n+getX/5-500, n-getX/5-100);
  loop += 5;
  if (loop == 1125) loop = 1000;
  
  // create a white cycle base
  fill(255);
  stroke(0);
  ellipse(width/2, height/2, 1008, 1008);
  
  // create the moving lines
  stroke(0);
  strokeWeight(7);
  for(int i = base; i < height+200; i += (10+getY/20)) {
    line(0, i, width/2, i-40+getX/20);
    line(width/2, i-40+getX/20, width, i);
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

/* this function seems no use
void mousePressed(){
  mv = !mv;
}
*/

// receive the coordinate data from the track motion
void oscEvent(OscMessage theOscMessage) {
  
  // get the x,y value
  getX = 3 * theOscMessage.get(0).intValue();
  getY = 2.25 * theOscMessage.get(1).intValue();
  
  // print the address pattern and the typetag of the received OscMessage
  print("### received an osc message.\n");
  print("X: ");
  print(theOscMessage.arguments()[0]);
  print("\n");
  print("Y: ");
  print(theOscMessage.arguments()[1]);
  print("\n");
  
}
