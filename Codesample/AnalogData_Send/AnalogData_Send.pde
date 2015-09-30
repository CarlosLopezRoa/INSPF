// simple analog input reader.
// it reads 0-5 analog inputs and send out to serial communication
// implmented for wearable workshop by KOBAKANT
// www.KOBAKANT.at

  
int led = 13;    //LED, it lights up when it is ready 
int count = 0;    // counter
int value0 = 0;  //analog input 0 value goes in here
int value1 = 0;  //analog input 1 value goes in here
int value2 = 0;
int value3 = 0;
int value4 = 0;
int value5 = 0;


void setup(){  

//teke off the following comment out to enable the internal pull up resistor.
//for more detail about pull up poins, read here http://www.arduino.cc/en/Tutorial/AnalogInputPins
/*  
// declaration of pin modes. do not forget to comment these out when you do not use internal pull ups.
  pinMode(14, OUTPUT); 
  pinMode(15, OUTPUT); 
  pinMode(16, OUTPUT); 
  pinMode(17, OUTPUT); 
  pinMode(18, OUTPUT); 
  pinMode(19, OUTPUT); 
  
// declaration of pin states
  digitalWrite(14, HIGH);  // set pullup on analog pin 0 
  digitalWrite(15, HIGH);
  digitalWrite(16, HIGH);
  digitalWrite(17, HIGH);
  digitalWrite(18, HIGH);
  digitalWrite(19, HIGH);
*/

  pinMode(led, OUTPUT);  // define led pin as output
  digitalWrite(led, HIGH); // turn the led pin on when setup is ready
  
  pinMode(10, OUTPUT); //sets digital pin 10 to output. pin10 can also do PWM
 
 //sets serial communication baudrate
  beginSerial(9600); 
} 


void loop () { 
  
 if (Serial.available() > 0) //it sends out data only if serial communication is available.
  {  
    value0 = analogRead(0);
    value1 = analogRead(1);
    value2 = analogRead(2);
    value3 = analogRead(3);
    value4 = analogRead(4);
    value5 = analogRead(5);

//example1: turn on/off the LED on pin10 when value0 (analog0 input) reaches certain value---------------
/*
if (value0>516) // if the value0 is bigger than 516, you can change this number to set different threshold.
{
    digitalWrite(10, HIGH); //set the digital pin10 high. (turn on the LED)
}
else 
digitalWrite(10, LOW); //if not, set the digital pin10 low. (turn off the LED)
*/
//--------------------------------------------------------------------------------------------------------




//example2: change the light intensity of the LED on pin10 according to value0 (analog0 input)------------
//pin10 outputs the PWM (pulse with modulation) according to the analog 0 input value.
/*
analogWrite(10, value0);
//analogWrite(10, value0/2); //half the value if full amount is too intence
*/
//--------------------------------------------------------------------------------------------------------



//sending analog input value to computer------------------------------------------------------------------

    printByte(0); // sensor input number indicator
    printInteger(value0); // sensor input data
    printByte(20); //breaker
    
    printByte(1); 
    printInteger(value1); 
    printByte(20); 
    
    printByte(2); 
    printInteger(value2); 
    printByte(20); 
    
    printByte(3); 
    printInteger(value3); 
    printByte(20); 

    printByte(4); 
    printInteger(value4); 
    printByte(20); 

    printByte(5); 
    printInteger(value5); 
    printByte(20);     
//--------------------------------------------------------------------------------------------------------
    delay (10);
  }
}
