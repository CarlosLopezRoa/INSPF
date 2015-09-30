import processing.serial.*; 
Serial arduino; 

String stringGyroX;
String stringGyroY;

String stringAccX;
String stringAccY;

String stringCompX;
String stringCompY;

String stringKalmanX;
String stringKalmanY;

int[] gyroX = new int[600];
float inGyroX;
int[] gyroY = new int[600];
float inGyroY;

int[] accX = new int[600];
float inAccX;
int[] accY = new int[600];
float inAccY;

int[] compX = new int[600];
float inCompX;
int[] compY = new int[600];
float inCompY;

int[] kalmanX = new int[600];
float inKalmanX;
int[] kalmanY = new int[600];
float inKalmanY;

void setup()
{
  size(600,400);
  //println(arduino.list());
  arduino = new Serial(this, Serial.list()[0], 115200);
  arduino.bufferUntil('\n');
  
  for(int i=0;i<600;i++)//center all variables
  {
   gyroX[i] = height/2;
   gyroY[i] = height/2;
   accX[i] = height/2;
   accY[i] = height/2;
   compX[i] = height/2; 
   compY[i] = height/2; 
   kalmanX[i] = height/2; 
   kalmanY[i] = height/2;
  } 
}

void draw()
{ 
  //GraphPaper
  background(255);
  for(int i = 0 ;i<=width/10;i++)
  {
    stroke(200);
    line((-frameCount%10)+i*10,0,(-frameCount%10)+i*10,height);
    line(0,i*10,width,i*10);
  }
  convert();
  drawAxisX();
  //drawAxisY();
}

void serialEvent (Serial arduino)
{
 //get the ASCII strings:
 stringGyroX = arduino.readStringUntil('\t');
 stringGyroY = arduino.readStringUntil('\t');
 
 stringAccX = arduino.readStringUntil('\t');
 stringAccY = arduino.readStringUntil('\t');

 stringCompX = arduino.readStringUntil('\t');
 stringCompY = arduino.readStringUntil('\t'); 

 stringKalmanX = arduino.readStringUntil('\t');
 stringKalmanY = arduino.readStringUntil('\t');

  //printAxis();//slows down the process and can result in error readings - use for debugging
}

