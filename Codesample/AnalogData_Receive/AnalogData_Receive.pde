
// importing the processing serial class
import processing.serial.*;


/*
*  this code is based on pa_Potentiometer copyleft 2005 by Melvin Ochsmann for Malm? University
 *  
 *  This sketch receives 6 analog input data from Arduino via serial port and displays it.
 *  made by www.kobakant.at
 */


// the display item draws background and grid
DisplayItems di;

// attributes of the display
boolean bck = true;
boolean grid = true;
boolean g_vert = true;
boolean g_horiz = false;
boolean g_values = true;
boolean output = true;


// variables for serial connection, portname and baudrate have to be set 
Serial port;
 
int i = 0;
int val = 0; 
String buf=""; 
int value=0; 
//prefix is the indicator for the sensor number
int prefix = 1;
//flag for the end of the signal
boolean myCatch = true;
//array to store the incoming sensor data
int[] xPosArr= new int [6];  
   

void setup(){
  // set size and framerate
  size(1028, 480);

  // create DisplayItems object
  di = new DisplayItems();
  
  println(Serial.list());
  
  // establish serial port connection, put the usb number to the [] 
  port = new Serial(this, Serial.list()[0], 9600);

 // initializing the array. xPosArr[] stores the X position of data
  for(int i=0; i < xPosArr.length; i++) xPosArr[i]=0;
}


void drawInputs(){
  for (i = 0; i < xPosArr.length; i++) {
   
//giving different colors to the each rectangles that shows the input value
    noStroke();
    if (i == 0) fill(0, 0, 255);
    if (i == 1) fill(80, 80, 168);
    if (i == 2) fill(0, 255, 0);
    if (i == 3) fill(0, 128, 0);
    if (i == 4) fill(255, 0, 0);
    if (i == 5) fill(128, 0, 0);
    if (i == 6) fill(0, 0, 255);
    if (i == 7) fill(80, 80, 168);
    if (i == 8) fill(0, 255, 0);
    if (i == 9) fill(0, 128, 0);
    if (i == 10) fill(255, 0, 0);
    if (i == 11) fill(128, 0, 0);

    // draw rectangle at data position
    rect(xPosArr[i], i*40, 40, 40);
    fill(0);
    //display the data value at the rectangle
    text(""+xPosArr[i] , xPosArr[i], i*40+20);   
  }
}

void serialEvent(int serial){
  if (myCatch) {
    if(serial!=20) {        
      // add event to buffer
      buf += char(serial);          
    } 
    else {
      // if serial is line break(20) set value to buff and clear it
      value = int(buf);
      xPosArr[(prefix-1)] = value; 
      myCatch = false;     
      buf="";
    }
  }
  
  //myCatch is the beginging of the each sended number used to define the port
  // myCatch gets true if serial is less than 20. 20 is a line break that Arduino is programed to send
  if (!myCatch && serial < 20) { 
    myCatch = true;
    prefix = int(serial);
  }
}



// listens to serial port
void draw(){
  
  // listen to serial port and trigger serial event  
  while(port.available() > 0){
    val = port.read();
    serialEvent(val);  
  }

  // draw background, then PushButtonState and finally rest of DisplayItems   
  di.drawBack();
  drawInputs();
  di.drawItems(); 
 
}
