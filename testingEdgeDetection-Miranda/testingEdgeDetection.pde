import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer shutter;
boolean curtains=false;
boolean space = false;
boolean edge =false;
boolean invert = false;

/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */
double time= millis();
import processing.video.*;
int imgCount = 0;
Capture cam;
int thresh=10;
void setup() {
  size(640, 480);

  String[] cameras = Capture.list();
  minim = new Minim(this); 

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }  
    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);

    // Start capturing the images from the camera
    cam.start();
  }
}
void draw() {
  color[]temp=new color[480*640];
  if (cam.available() == true) {
    cam.read();
  }

  image(cam, 0, 0);
  if (edge) {

    loadPixels();
    float up ;
    float down;
    float left;
    float right ;
    int val;
    for (int y = 1; y < 478; y++) {
      for (int x= 1; x < 638; x++) {
        color w= pixels[y*640+x];
        pixels[y*640+x]=color((int)(red(w)+green(w)+blue(w)) / 3);
      }
    }
    for (int y = 1; y < 478; y++) {
      for (int x= 1; x < 638; x++) {
        up = red(pixels[(y*640)+(x-1)]);
        down = red(pixels[y*640+(x+1)]);
        left = red(pixels[((y-1)*640)+x]);
        right = red(pixels[((y+1)*640)+x]); 
        val=(int)sqrt(sq(left-right)+sq(up-down));
        if (val>thresh) {
          val=255;
        }
        if (invert) {
          val= 255-val;
        }

        temp[y*640+x]=color(val);
      }
    }
    for (int y = 1; y < 478; y++) {
      for (int x= 1; x < 638; x++) {
        pixels[y*640+x]=temp[y*640+x];
      }

      updatePixels();
    }
  }


  if (curtains) {
    image(loadImage("curtains.png"), 0, 0);
  }
  if (space) {
    image(loadImage("space.png"), 0, 0);
  }
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}

void keyPressed() {
  println(keyCode);
  if (keyCode == 32) {
    imgCount++;
    shutter = minim.loadFile("shutter.mp3");
    shutter.play();
    saveFrame("line-"+imgCount+".jpg");
    String currentImg = "line-"+imgCount+".jpg";
    time= millis();
    while (millis () < time+1000) {
      image(loadImage(currentImg), 0, 0);
    }
  }
  if (keyCode == 38 ) {
    thresh--;
  }
  if (keyCode == 40 ) {
    thresh ++;
  }
  if (keyCode == 69) {
    edge=!edge;
    space=false;
    curtains=false;
  }
  if (keyCode == 73) {
    invert=!invert;
  }
  if (keyCode == 67) {
    curtains=!curtains;
    space=false;
  }
  if (keyCode == 83) {
    space=!space;
    curtains=false;
  }
  keyCode = 0;
}

