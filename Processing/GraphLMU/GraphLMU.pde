import processing.serial.*; 
Serial arduino; 

String stringAccX;
String stringAccY;
String stringAccZ;
String stringTemp;
String stringPres;

int[] accX = new int[600];
float inAccX;
int[] accY = new int[600];
float inAccY;
int[] accZ = new int[600];
float inAccZ;
int[] Temp = new int[600];
float inTemp;
int[] Pres = new int[600];
float inPres;


void setup()
{
  size(1280,600);
  println(arduino.list());
  arduino = new Serial(this, Serial.list()[0], 9600);
  arduino.bufferUntil('\n');
  
  for(int i=0;i<600;i++)//center all variables
  {
   accX[i] = height/2;
   accY[i] = height/2;
   accZ[i] = height/2;
   Temp[i] = height/2;
   Pres[i] = height/2;
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
  drawAxisY();
  drawAxisZ();
  drawAxisT();
  drawAxisP();
}


void serialEvent (Serial arduino)
{
 //get the ASCII strings: 
 stringAccX = arduino.readStringUntil('\t');
 stringAccY = arduino.readStringUntil('\t');
 stringAccZ = arduino.readStringUntil('\t');
 stringTemp = arduino.readStringUntil('\t');
 stringPres = arduino.readStringUntil('\n');

  printAxis();//slows down the process and can result in error readings - use for debugging
  // printConvert();

}

//convert all axis
int maxAngle = 90;
int maxG = 2;
int maxTemp = 400;
int minTemp = 200;
int maxPres = 110000;
int minPres = 300;

void convert()
{
 //convert the accelerometer x-axis
 if (stringAccX != null) 
 {
   //trim off any whitespace:
   stringAccX = trim(stringAccX);
   //convert to an float and map to the screen height:
   inAccX = float(stringAccX);
   inAccX = map(inAccX, maxG, -maxG, 0, height);
   accX[accX.length-1] = int(inAccX);
 }
 //convert the accelerometer y-axis
 if (stringAccY != null) 
 {
   //trim off any whitespace:
   stringAccY = trim(stringAccY);
   //convert to an float and map to the screen height:
   inAccY = float(stringAccY);
   inAccY = map(inAccY, maxG, -maxG, 0, height);
   accY[accY.length-1] = int(inAccY);
 }
 if (stringAccZ != null) 
 {
   //trim off any whitespace:
   stringAccZ = trim(stringAccZ);
   //convert to an float and map to the screen height:
   inAccZ = float(stringAccZ);
   inAccZ = map(inAccZ, maxG, -maxG, 0, height);
   accZ[accZ.length-1] = int(inAccZ);
 }
  if (stringTemp != null) 
 {
   //trim off any whitespace:
   stringTemp = trim(stringTemp);
   //convert to an float and map to the screen height:
   inTemp = float(stringTemp);
   inTemp = map(inTemp, maxTemp, minTemp , 0, height);
   Temp[Temp.length-1] = int(inTemp);
 }
   if (stringPres != null) 
 {
   //trim off any whitespace:
   stringPres = trim(stringPres);
   //convert to an float and map to the screen height:
   inPres = float(stringPres);
   inPres = map(inPres, maxPres, minPres, 0, height);
   Pres[Pres.length-1] = int(inPres);
 }
}//Fin de Convert

void drawAxisX()
{
   //draw acceleromter x-axis
  noFill();
  stroke(129,129,230);//light blue
  //redraw everything
  beginShape();
  for(int i = 0; i<accX.length;i++){
    vertex(i,accX[i]);
  }
  endShape();
  //put all data one array back
  for(int i = 1; i<accX.length;i++){
   accX[i-1] = accX[i];
   }
}
   
void drawAxisY()
{
  //draw acceleromter y-axis
  noFill();
  stroke(127,34,255);//purple
  //redraw everything
  beginShape();
  for(int i = 0; i<accY.length;i++){
    vertex(i,accY[i]);
  }
  endShape();
  //put all data one array back
  for(int i = 1; i<accY.length;i++){
   accY[i-1] = accY[i];
   }
   
}//Fin de drawAxisY

void drawAxisZ()
{
  //draw acceleromter y-axis
  noFill();
  stroke(255,0,0);//Red
  //redraw everything
  beginShape();
  for(int i = 0; i<accZ.length;i++){
    vertex(i,accZ[i]);
  }
  endShape();
  //put all data one array back
  for(int i = 1; i<accZ.length;i++){
   accZ[i-1] = accZ[i];
   }
   
}//Fin de drawAxisZ

void drawAxisT()
{
  //draw acceleromter y-axis
  noFill();
  stroke(0,255,0);//
  //redraw everything
  beginShape();
  for(int i = 0; i<Temp.length;i++){
    vertex(i,Temp[i]);
  }
  endShape();
  //put all data one array back
  for(int i = 1; i<Temp.length;i++){
   Temp[i-1] = Temp[i];
   }
   
}//Fin de drawAxisT

void drawAxisP()
{
  //draw acceleromter y-axis
  noFill();
  stroke(0,255,255);//
  //redraw everything
  beginShape();
  for(int i = 0; i<Pres.length;i++){
    vertex(i,Pres[i]);
  }
  endShape();
  //put all data one array back
  for(int i = 1; i<Pres.length;i++){
   Pres[i-1] = Pres[i];
   }
   
}//Fin de drawAxisP

void printAxis()
{
 print(stringAccX);
 print(stringAccY);
 print(stringAccZ);
 print(stringTemp);
 print(stringPres);
}



void printConvert()
{
  print(accX[accX.length-1]);
  print(",");
  print(accY[accY.length-1]);
    print(",");

  print(accZ[accZ.length-1]);
    print(",");

  print(Temp[Temp.length-1]);
    print(",");

  print(Pres[Pres.length-1]);
  println();
}
