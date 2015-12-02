//variables for neopixel
#include <Adafruit_NeoPixel.h>
#define PIN 6

Adafruit_NeoPixel strip = Adafruit_NeoPixel(16, PIN, NEO_GRB + NEO_KHZ800);

//variables for pulse
int pulsePin = A0;
int neoRing = 6;

// these variables are volatile because they are used during the interrupt service routine!
volatile int BPM;                   // used to hold the pulse rate
volatile int Signal;                // holds the incoming raw data
volatile int IBI = 600;             // holds the time between beats, must be seeded! 
volatile boolean Pulse = false;     // true when pulse wave is high, false when it's low
volatile boolean QS = false;        // becomes true when Arduoino finds a beat.
int QScounter;
boolean human;

void setup(){
  Serial.begin(9600);
  pinMode(pulsePin,INPUT);
  pinMode(neoRing,OUTPUT);
  strip.begin();
  strip.setBrightness(255);
  strip.show();
  interruptSetup();
}

void loop(){
 
  if(BPM > 55) {
   human = true; 
  }
  
  if (QS == true && human == true && IBI > 650 && IBI < 1100){
    rainbow(5);
  Serial.println("QS true and human present!");
  }
//  
//  if(QScounter > 30) {
//   rainbow(5);
//   Serial.println(QS);
//   //delay(1000);
//   QS = false;
//   QScounter = 0;
//
//    
//  }
//  
  /*if (QS == false){
    blackout();
  }*/
//  
//  if (BPM >= 50){
//    rainbow(5);
//  }
//  
//  if (BPM < 50){
//   strip.setPixelColor(0, 0, 0, 0);   
//   //strip.setBrightness(0);  
//    strip.show(); 
//  }
  
  //delay(20);
  
  
}

// Fill the dots one after the other with a color
/*void colorWipe(uint32_t c, uint8_t wait) {
  for(uint16_t i=0; i<strip.numPixels(); i++) {
      strip.setPixelColor(i, c);
      strip.show();
      delay(wait);
  }
}*/

void rainbow(uint8_t wait) {
  uint16_t i, j;

  for(j=0; j<256; j++) {
    for(i=0; i<strip.numPixels(); i++) {
      strip.setPixelColor(i, Wheel((i+j) & 255));
    }
    strip.show();
    delay(wait);
  }
}

// Input a value 0 to 255 to get a color value.
// The colours are a transition r - g - b - back to r.
uint32_t Wheel(byte WheelPos) {
  WheelPos = 255 - WheelPos;
  if(WheelPos < 85) {
   return strip.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  } else if(WheelPos < 170) {
    WheelPos -= 85;
   return strip.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  } else {
   WheelPos -= 170;
   return strip.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
  }
}

/*void blackout() {  
    strip.setPixelColor(0, 0, 0, 0);   
    strip.setBrightness(0);  
    strip.show();  
  }  */
