
//right now it's click to take picture
import processing.video.*;

Capture cam;
//freezes the image for .3 seconds so you can see the image after taking it
int justTaken;
//self timer
boolean startedShot;
int selecting, delay; 
float takenDelay;
//number of shots
int shots;
//grayscale or sepia or other things, not yet implemented
String effect;
int shutterWidth;
int taking;
int counter;
PImage frame1;
PImage pic1;
PImage pic2;
PImage pic3;
PImage pic4;
PImage finalPic;
PImage tyPic;
int numPics;
void setup() {
  size(800, 600);
  delay = 5;
  shots = 4;
  effect = "none";
  taking = 0;
  counter = 0;
  justTaken = 0;
  takenDelay = 1;
  selecting = 0;
  startedShot = false;
  numPics = 0;
  frame1 = loadImage("attempt3.png");
  tyPic = loadImage("lml.png");
  frame1.resize(width, height);
  tyPic.resize(width, height);
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    } 

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
}

void draw() {
  if (selecting == 0) {
    makeButtons();
  } else if (selecting == 2) {
    thanksPage();
  } else {
    if (cam.available() ) {
      cam.read();
    }
    if (justTaken <= 0) {
      image(cam, 0, 0, width, height);
      runEffect();

      if (taking == 0 && startedShot == true) {
        selecting = 2;
        counter = 0;
        startedShot = false;
        combinePhotos();
      }
    } else {

      justTaken --;
    }
    if (taking > 0) {
      takePic();
      if (justTaken <= 0) {
        int a = (int) ((counter - 1)/ 60);
        textSize(100);
        fill(255, 0, 0);
        //println(a);
        text("" + a, 100, 100);
      }
    }
  }
}
void mousePressed() {
  if (selecting == 0) {
    buttonEvents();
  } else {
    if (taking == 0) {  
      startedShot = true;
      taking = shots;
      counter = (int) (delay * frameRate);
    }
  }
}
void runEffect() {
  if (effect == "gray" ) {
    loadPixels();
    for (int i = 1; i < width -1; i++) {
      for (int j = 1; j < height-1; j++) {
        colorMode(RGB);
        float r = red( pixels[j*width+i]);
        float g = green( pixels[j*width+i]);
        float b = blue( pixels[j*width+i]);

        float newr = .3* r + .59 * g + .11 * b;
        float newg = .3 * r + .59* g + .11 * b;
        float newb = .3 * r + .59 * g + .11 * b;

        if (newr >255) {
          newr = 255;
        }
        if (newg >255) {
          newg = 255;
        }
        if (newb >255) {
          newb = 255;
        }

        pixels[j*width+i] = color(newr, newg, newb);
      }
    }
    updatePixels();
  } else if (effect == "sepia") {
    loadPixels();
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        colorMode(HSB);
        pixels[j*width+i] = color(hue(pixels[j*width+i]), saturation(pixels[j*width+i]), brightness(pixels[j*width+i])+30);
        colorMode(RGB);
        float r = red( pixels[j*width+i]);
        float g = green( pixels[j*width+i]);
        float b = blue( pixels[j*width+i]);


        float newr = .678 * r + .769 * g + .189 * b;
        float newg = .349 * r + .686 * g + .168 * b;
        float newb = .272 * r + .534 * g + .131 * b;
        /*
float newr = .393 * r + .769 * g + .189 * b;
         float newg = .349 * r + .686 * g + .168 * b;
         float newb = .272 * r + .534 * g + .131 * b;
         */
        if (newr >255) {
          newr = 255;
        }
        if (newg >255) {
          newg = 255;
        }
        if (newb >255) {
          newb = 255;
        }

        pixels[j*width+i] = color(newr, newg, newb);
      }
    }
    updatePixels();
  }
}
void takePic() {
  if (counter <= 0) {
    taking --;
    numPics ++; 
    saveFrame("pic-" + numPics + ".png");
    takenEffect();
    counter = (int) (frameRate *( delay + takenDelay));
  } else {


    counter --;
  }
}
void takenEffect() {
  justTaken = (int) (takenDelay * frameRate);
}
void thanksPage() {
  counter++ ;
  image(loadImage("boothpic"+numPics/4+".png"), 0, 0);
  if (counter >= (int) ( 2 * frameRate)) {
    background(255);
    background(tyPic); //grayish
    textSize(125);
    fill(255, 255, 255);
    text("Thank you", 300, 250);
    text("for using", 350, 400);
    text("our photobooth!", 200, 550);
  }
  if (counter == (int) (5 * frameRate)) {
    counter = 0;
    selecting = 0;
  }
}
void buttonEvents() {
  selecting = 1;
}
void combinePhotos() {
  pic1 = loadImage("pic-"+(numPics - 3)+".png");
  pic1.resize(380, 249);

  pic2 = loadImage("pic-"+(numPics - 2)+".png");
  pic2.resize(380, 249);

  pic3 = loadImage("pic-"+(numPics - 1)+".png");
  pic3.resize(380, 249);

  pic4 = loadImage("pic-"+numPics+".png");
  pic4.resize(380, 249);

  image(frame1, 0, 0);
  image(pic1, 99, 78);
  image(pic2, 150, 300);
  image(pic3, 650, 80);
  image(pic4, 650, 300);
  saveFrame("boothpic"+numPics/4+".png");
}
void makeButtons() {
  background(255);
}

