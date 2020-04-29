import processing.video.*;
import blobscanner.*;
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;
Detector bd;
Capture video;
PImage prevFrame;

float threshold = 150;
int Mx = 0;
int My = 0;
int ave = 0;
int sendX = width/8;
int sendY = height/8;
int rsp = 5;
 
void setup() {
  size(640, 480);
  frameRate(25);
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  video = new Capture(this, width, height, 30);
  video.start();
  prevFrame = createImage(video.width, video.height, RGB);
}
 
void draw() {

  if (video.available()) {
    prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height); 
    prevFrame.updatePixels();
    video.read();
  }
  
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();
 
  Mx = 0;
  My = 0;
  ave = 0;

  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
 
      int loc = x + y*video.width;            
      color current = video.pixels[loc];      
      color previous = prevFrame.pixels[loc]; 
      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);
      float diff = dist(r1, g1, b1, r2, g2, b2);
 
      if (diff > threshold) { 
        pixels[loc] = video.pixels[loc];
        Mx += x;
        My += y;
        ave++;
      } 
      else
        pixels[loc] = video.pixels[loc];
    }
  }
  
  fill(255);
  rect(0, 0, width, height);
  
  if (ave != 0) { 
    Mx = Mx/ave;
    My = My/ave;
  }
  
  if (Mx > sendX + rsp/2 && Mx > 50)
    sendX+= rsp;
  else if (Mx < sendX - rsp/2 && Mx > 50)
    sendX-= rsp;
  if (My > sendY + rsp/2 && My > 50)
    sendY+= rsp;
  else if (My < sendY - rsp/2 && My > 50)
    sendY-= rsp;
 
  updatePixels();
  
  OscMessage myMessage = new OscMessage("Coordinate");
  myMessage.add(sendX);
  myMessage.add(sendY);
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
  print("### sended an osc message.\n");
  print("X: ");
  print(sendX);
  print("\n");
  print("Y: ");
  print(sendY);
  print("\n");
  
  bd =new Detector(this, 255);
  bd.findBlobs(video.pixels, 640, 480);
  bd.loadBlobsFeatures(); 
  bd.findCentroids();
  bd.drawBox(color(255, 0, 0), 5);
  
}
