/**
* Tecnologias de Interface, Winter 2023
* Universidade de Coimbra
* MSc in Design and Multimedia
*
* Week 4
* Example serial communication with Arduino (write)
* 
* @authors: Sérgio M. Rebelo, Ana Cláudia Rodrigues, and Tiago Cruz
* @since:   03–03–2023      
* @based:   https://www.arduino.cc/en/Tutorial/BuiltInExamples/ASCIITable
*/
//servo
#include <Servo.h>
Servo red, green;
bool open = false;
int pos = 0;


///
const int b1 = 2;
const int b2 = 3;
const int b3 = 4;
const int b4 = 5;
const int b5 = 6;
int s1 = 0;
int s2 = 0;
int s3 = 0;
int s4 = 0;
int s5 = 0;
int R = 0, G = 0, N = 0;
void setup() {
  pinMode(b1, INPUT);
  pinMode(b2, INPUT);
  pinMode(b3, INPUT);
  pinMode(b4, INPUT);
  pinMode(b5, INPUT);

  // Initialize serial data rate (bits per second) and wait for port to open
  Serial.begin(9600);
  red.attach(9);  // attaches the servo on pin 9 to the servo object
  green.attach(10);
//
  // wait for serial port to connect. Needed for native USB port only (Leonardo only)
  while (!Serial) {
    ;
  }
}

void loop() {

  //servo
  //if variables were declared
  if (open) {

    if (R == 0 && G == 0)
      open = false;

    //if (Serial.available() > 0) {

    //while there is marbles to be sent
    while (R > 0 || G > 0) {
      Serial.println("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      //move open
      for (pos = 65; pos <= 180; pos += 1) {
        if (R > 0)
          red.write(pos);
        if (G > 0)
          green.write(pos);

        delay(10);
      }
      //move closed
      for (pos = 180; pos >= 65; pos -= 1) {
        if (R > 0)
          red.write(pos);
        if (G > 0)
          green.write(pos);
        delay(10);
      }
      R--;
      G--;
    }
    //}
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  else {
    s1 = digitalRead(b1);
    s2 = digitalRead(b2);
    s3 = digitalRead(b3);
    s4 = digitalRead(b4);
    s5 = digitalRead(b5);


    if (s1 == HIGH) {
      // turn LED on:
      G++;
    }

    if (s2 == HIGH) {
      // turn LED on:
      G--;
    }
    if (s3 == HIGH) {
      // turn LED on:
      R++;
    }

    if (s4 == HIGH) {
      // turn LED on:
      R--;
    }
  }

  if (R < 0) R = 0;
  if (G < 0) G = 0;
  if (s5 == HIGH)
    open = true;
  if (R == 0 && G == 0)
    open = false;

  Serial.println((String)String(R) + "/" + String(G) );


delay(100);


  
}
