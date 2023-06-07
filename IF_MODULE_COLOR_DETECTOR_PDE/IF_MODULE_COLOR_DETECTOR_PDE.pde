import processing.serial.*;

import processing.video.*;
//this code is a modified version of a previous program, some vestigial dead code may be left in the program
float theta;
Capture cam;
float speed=radians(0);
boolean test;
String T="select one of the 6 experiences by pressing it's number";
int exp=-1;
float avgB=0;
int e=0;
int countR=0, countG=0;
boolean debug=true, isColor=false;

int interval=0;
///Arduino
Serial myPort;
byte ledState = 'L';
///
void setup() {
  frameRate(1);
  fullScreen();
  ///Arduino
  // get and print the list of avariable ports
  printArray(Serial.list());

  //change to match the port
  String portName = Serial.list()[0];

  myPort = new Serial(this, portName, 9600);

  //// sets a specific byte to buffer until before calling serialEvent().
  myPort.bufferUntil('\n');

  //// removes all data stored on buffer
  myPort.clear();


  ///
  String[] cameras = Capture.list();
  rectMode(CENTER);
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
    cam = new Capture(this, cameras[1]);
    cam.start();
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  interval++;

  pushMatrix();
  scale(4);
  image(cam, 0, 0);
  popMatrix();
  cam.loadPixels();

  int sat[]=new color[cam.pixels.length], bright[]=new color[cam.pixels.length], red[]=new color[cam.pixels.length], green[]=new color[cam.pixels.length], blue[]=new color[cam.pixels.length], hue[]=new color[cam.pixels.length];
  for (int i=0; i<640; i+=10) {
    for (int j=0; j<480; j+=10) {
      int loc=i+j* 640;

      bright[loc] =  round(brightness  (cam.pixels[loc]));
      red[loc] =  round(red  (cam.pixels[loc]));
      green[loc] =  round(green  (cam.pixels[loc]));
      blue[loc] =  round(blue  (cam.pixels[loc]));
      avgB+=bright[loc];
      colorMode(HSB, 360, 100, 100);
      hue[loc]=round(hue(cam.pixels[loc]));
      sat[loc]=round(saturation(cam.pixels[loc]));
      bright[loc] =  round(brightness  (cam.pixels[loc]));
      colorMode(RGB, 255, 255, 255);
    }
  }
  noStroke();
  cam.updatePixels();
  avgB=avgB/bright.length;


  //println(avgB);
  pushMatrix();
  //translate(width, 0);
  scale(1, 1);
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //background(255);
  //background(map(avgB, 0, 2, 255, 0));
  for (int i=0; i<640; i+=10) {
    for (int j=0; j<480; j+=10) {
      int loc=i+j* 640;


      fill(0);

      pushMatrix();
      translate(i*width/640, j*height/480);

      textSize(16);
      translate(10, 10);
      int sense=100;
      scale(-1, 1);
      //if (max(blue[loc], green[loc], red[loc])==red[loc] && blue[loc]<100 && green[loc]<100 ) {
      fill(155);

      if ( green[loc] > sense && red[loc] < sense && blue[loc] < sense && i>=220 && i<=360 && j>=200 && j<=260) {
        fill(0, 255, 0);
        countG++;
      }
      if ( red[loc] > sense && green[loc] < sense && blue[loc] < sense && i>=220 && i<=360 && j>=200 && j<=260) {

        fill(255, 0, 0);
        countR++;
      }
      if (debug && i>=220 && i<=360 && j>=200 && j<=260)
        ellipse(0, 0, 30, 30);
      popMatrix();
    }
  }
  boolean compare=false;
  if (interval==5) {
    if (countG>2 || countR>2)
      compare=true;
    if (compare)
      if (countG > countR  ) {
        myPort.write("0");
        isColor=true;
      } else if (countG < countR) {
        myPort.write("1");
        isColor=false;
      } else
        myPort.write("2");
    interval=0;
  }
  //Arduino
  println("countR = "+countR+" countG = "+countG+" - "+isColor);
  countR=0;
  countG=0;
  //////////////////////////////////////////////////////////////////////////////
  popMatrix();
  avgB=0;
  textAlign(CORNER);
  fill(0);
  text(T, 10, height-10);
  fill(255);
  text(T, 9, height-9);
}

void keyPressed() {
  debug=!debug;
}
