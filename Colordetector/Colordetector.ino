/**
  Tecnologias de Interface, Winter 2023
  Universidade de Coimbra
  MSc in Design and Multimedia

  Week 4
  Example serial communication with Arduino (write)

  @authors: Sérgio M. Rebelo, Ana Cláudia Rodrigues, and Tiago Cruz
  @since:   03–03–2023
  @based:   https://www.arduino.cc/en/Tutorial/BuiltInExamples/ASCIITable
*/
//servo
#include <Servo.h>
Servo gate, sorter;
bool compare = false, open = false, green;
int pos2 = 0, pos = 0, posG = 65, posR = 180;


///



void setup() {


  // Initialize serial data rate (bits per second) and wait for port to compare
  Serial.begin(9600);
  gate.attach(9);  // attaches the servo on pin 9 to the servo object
  sorter.attach(10);
  //
  // wait for serial port to connect. Needed for native USB port only (Leonardo only)
  while (!Serial) {
    ;
  }

  sorter.write(0);
  gate.write(65);
}

void loop() {

  //servo
  //if variables were declared
  if (compare) {
    open = true;


    if (open) {
      //Serial.println("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      //move compare
      for (pos = 60; pos <= 179; pos += 1) {
        gate.write(pos);
        delay(10);
      }

      if (green)
        if (sorter.read() < 35)
          for (pos2 = 0; pos2 <= 35; pos2 += 1) {
            sorter.write(pos2);
            //  delay(10);
            if (pos2 == 35)
              open = false;
          }
        else
          open = false;
      if (!green)
        if (sorter.read() > 0)
          for (pos2 = 35; pos2 >= 0; pos2 -= 1) {
            sorter.write(pos2);

            //delay(10);
            if (pos2 == 0)
              open = false;
          }
        else
          open = false;
    }

    if (!open) {
      //move closed
      for (pos = 179; pos >= 60; pos -= 1) {

        gate.write(pos);

        delay(10);
        if (pos == 60)
          compare = false;
      }
    }
  }
  //}
  
    char s = char(Serial.read());
  // 0= red
  // 1= green
  // 2= nothing

  if (s == '0') {
    green = false;
    compare = true;
  }
  if (s == '1') {
    green = true;
    compare = true;
  }
  if (s == '2')
    compare = false;
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  //Serial.println((String)"green= " + String(green) + " compare= " + String(compare) + " open= " + String(open) + " s= " + String(s));

  delay(500);
}
