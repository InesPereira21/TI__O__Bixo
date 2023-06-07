import processing.serial.*;
color white = #F5F5F5;
color black = #020202;
color red = #FF4949;
color purple = #6A67FF;
color lightPurple = #B2B1FF;
color green =#00DC30;
PFont mainFontBold, fontRegular;

PImage marbles, bradboard, landingPage, infoPage, infoPage2;

int corners = 65;

boolean page1, page2, page3, page4, cast=false;
// ARDUINO
Serial myPort;
String val;
String value = "";
int sensorVal = 0;

void setup() {
  fullScreen();
  // size(1440, 1024);
  background(#6A67FF);

  page1 =true;
  page2 = false;
  page3 =false;
  page4 = false;

  mainFontBold = createFont("Fredoka-Bold.ttf", 209);
  fontRegular = createFont("Fredoka-Regular.ttf", 209);
  marbles = loadImage("marbles.png");
  bradboard = loadImage("bradboard.png");

  landingPage = loadImage("pages/landingPAge.jpg");
  infoPage = loadImage("pages/infoPage__1.jpg");
  infoPage2 = loadImage("pages/3__infoPage__2.jpg");


  fill(black);
  textAlign(CENTER);
  textFont(mainFontBold);
  textSize(103.5);

  
  ///ARDUINO
  String portName = "COM7";
  myPort = new Serial(this, portName, 9600);
  
}

void draw() {
  background(#6A67FF);


  // ARDUINO
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n');
    try {
      sensorVal = Integer.valueOf(val.trim());
    }
    catch(Exception e) {
      ;
    }
    println(val); // read it and store it in vals!
  }

  String [] V;
  //String [] H;
  //H=split(val, '/');
  V=split(val, '/');
  //if (H[1].charAt(0)=='1')
  //  cast=true;
  //else
  //  cast=false;
  //  /----


  rectMode(LEFT);

  mainFontBold = createFont("Fredoka-Bold.ttf", 150);

  noStroke();
  imageMode(CENTER);

  if (page1 && !cast) {
    noStroke();
    image(landingPage, width * .5, height * .5);
  } else if (!cast && page2) {
    image(infoPage, width * .5, height * .5);
  } else if (!cast && page3) {
    image(infoPage2, width * .5, height * .5);
  }

  //  else if (!cast && !page1) {
  else if (!cast && page4) {
    fill(black);
    textSize(34);
    text("Definição de Variáveis", width * .5, height * .1);

    background(white);
    fill(black);
    textAlign(CENTER);
    textFont(mainFontBold);
    textSize(70);
    text("  Escolhe o número de berlindes \n  a serem lançados!", width * .5, height * .17);

    rectMode(CENTER);
    fill(red);
    rect(width * .25, height * .55, width * .2, width * .2, corners);
    fill(white);
    textFont(fontRegular);

    textSize(300);

    
    // ARDUINO
    text(V[0], width * .24, height * .68);

    textFont(fontRegular);
    textAlign(CENTER);
    fill(purple);
    textSize(300);
    text("+", width * .5, height * .60); //68);


    fill(green);
    rect(width - width * .25, height * .55, width * .2, width * .2, corners);
    fill(white);
    textFont(fontRegular);

    textSize(300);
    
    
    // ARDUINO
    text(V[1], width - width * .25, height * .68);


    //...............
    textAlign(CENTER);
    fill(black);
    textSize(58);
    text("(usando os botões)", width * .5, height - height * .2);
    textFont(mainFontBold);
    textSize(34);
    text("depois clica no botão branco", width * .5, height - height * .1);
  } else if (cast) {
    textFont(fontRegular);
    textAlign(CENTER);
    fill(purple);
    textSize(300);
    text("Sending Marbles...", width * .5, height * .68);
  }
}

void serialEvent(Serial myPort) {
  // put the incoming data into a String
  // the '\n' is our end delimiter
  // indicating the end of a complete packet
  value = myPort.readString();
  // alternative
  // value = myPort.readStringUntil('\n');

  if (value != null) {
    // remove breakline in the end of buffer
    String str = value.substring(0, value.length()-2);

    // alternative
    // String str = int(trim(value));
    println ("received:", str);
  }
}
void keyPressed() {
  if (key == ' ') {
    if (page1) {
      //  page1 = !page1;
      page1 = false;
      page2 = true;
    } else if (page2) {
      page2 = false;
      page3 =true;
    } else if (page3) {
      page3 = false;
      page4 =true;
    }
  } else if (keyCode == LEFT) {
    if (page2) {
      page2 = false;
      page1 =true;
    }
    else  if (page3) {
      page3 = false;
      page2 =true;
    }
        else  if (page4) {
      page4 = false;
      page3 =true;
    }
  }
}
