import blobscanner.*;
import processing.video.*;

Detector bd;
Capture video;

void setup() {

  size(640,480);
  video = new Capture(this, width, height, 30);
  video.start();

}

void draw() {

  if(video.available()) {

    video.read();

  }

  video.filter(THRESHOLD);
  bd =new Detector(this,255);
  bd.findBlobs(video.pixels, 640, 480);
  bd.loadBlobsFeatures(); 
  bd.drawContours(color(0,0,255),2);

}
