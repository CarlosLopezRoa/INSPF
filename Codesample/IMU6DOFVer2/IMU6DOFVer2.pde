//made by Kristian Lauszus - see http://arduino.cc/forum/index.php/topic,58048.0.html for information
#define gX A0
#define gY A1
#define gZ A2

#define aX A3
#define aY A4
#define aZ A5

#define RAD_TO_DEG 57.295779513082320876798154814105

//gyros
int gyroZeroX;//x-axis
float gyroXadc;
float gyroXrate;
float gyroXangle;

int gyroZeroY;//y-axis
float gyroYadc;
float gyroYrate;
float gyroYangle;

int gyroZeroZ;//z-axis
float gyroZadc;
float gyroZrate;
float gyroZangle;


//accelerometers
int accZeroX;//x-axis
float accXadc;
float accXval;
float accXangle;

int accZeroY;//y-axis
float accYadc;
float accYval;
float accYangle;

int accZeroZ;//z-axis
float accZadc;
float accZval;
float accZangle;

//Results
float xAngle;
float yAngle;
float compAngleX;
float compAngleY;

float R;//force vector
//Used for timing
unsigned long timer=0;
unsigned long dtime=0;

void setup()
{
  analogReference(EXTERNAL); //3.3V
  Serial.begin(115200);
  delay(100);//wait for the sensor to get ready
  
  //calibrate all sensors in horizontal position
  gyroZeroX = calibrateGyroX();
  gyroZeroY = calibrateGyroY();  
  gyroZeroZ = calibrateGyroZ();
  
  accZeroX = calibrateAccX();
  accZeroY = calibrateAccY();
  accZeroZ = calibrateAccZ();
  
  timer=millis();//start timing
}

void loop()
{
  gyroXadc = analogRead(gX);
  gyroXrate = (gyroXadc-gyroZeroX)/1.0323;//(gyroXadc-gryoZeroX)/Sensitivity - in quids              Sensitivity = 0.00333/3.3*1023=1.0323
  gyroXangle=gyroXangle+gyroXrate*dtime/1000;//Without any filter
  
  gyroYadc = analogRead(gY);
  gyroYrate = (gyroYadc-gyroZeroY)/1.0323;//(gyroYadc-gryoZeroX)/Sensitivity - in quids              Sensitivity = 0.00333/3.3*1023=1.0323
  gyroYangle=gyroYangle+gyroYrate*dtime/1000;//Without any filter
  
  gyroZadc = analogRead(gZ);
  gyroZrate = (gyroZadc-gyroZeroZ)/1.0323;//(gyroZadc-gryoZeroX)/Sensitivity - in quids              Sensitivity = 0.00333/3.3*1023=1.0323
  //gyroZangle=gyroZangle+gyroZrate*dtime/1000;//Without any filter
  
  accXadc = analogRead(aX);
  accXval = (accXadc-accZeroX)/102,3;//(accXadc-accZeroX)/Sensitivity - in quids              Sensitivity = 0.33/3.3*1023=102,3
  
  accYadc = analogRead(aY);
  accYval = (accYadc-accZeroY)/102,3;//(accXadc-accZeroX)/Sensitivity - in quids              Sensitivity = 0.33/3.3*1023=102,3
  
  accZadc = analogRead(aZ);
  accZval = (accZadc-accZeroZ)/102,3;//(accXadc-accZeroX)/Sensitivity - in quids              Sensitivity = 0.33/3.3*1023=102,3
  accZval++;//1g in horizontal position
  
  R = sqrt(pow(accXval,2)+pow(accYval,2)+pow(accZval,2));//the force vector
  accXangle = acos(accXval/R)*RAD_TO_DEG-90;
  accYangle = acos(accYval/R)*RAD_TO_DEG-90;
  //accZangle = acos(accZval/R)*RAD_TO_DEG;
  
/*  //used for debugging
  Serial.print(gyroZrate,0);Serial.print("\t");
  Serial.print(gyroZrate,0);Serial.print("\t");
  Serial.print(gyroZrate,0);Serial.print("\t");

  Serial.print(gyroXangle,0);Serial.print("\t");
  Serial.print(gyroYangle,0);Serial.print("\t");
  Serial.print(gyroZangle,0);Serial.print("\t");

  Serial.print(accXval,2);Serial.print("\t");
  Serial.print(accYval,2);Serial.print("\t");
  Serial.print(accZval,2);Serial.print("\t");

  Serial.print(accXangle,0);Serial.print("\t");
  Serial.print(accYangle,0);Serial.print("\t");
  //Serial.print(accZangle,0);Serial.print("\t");
*/
  
  dtime = millis()-timer;
  timer = millis();
  
  compAngleX = (0.98*(compAngleX+(gyroXrate*dtime/1000)))+(0.02*(accXangle));
  compAngleY = (0.98*(compAngleY+(gyroYrate*dtime/1000)))+(0.02*(accYangle));
  xAngle = kalmanCalculateX(accXangle, gyroXrate, dtime);
  yAngle = kalmanCalculateY(accYangle, gyroYrate, dtime);

  /*Serial.print(compAngleX,0);Serial.print("\t");
  Serial.print(compAngleY,0);Serial.print("\t");
  Serial.print(xAngle,0);Serial.print("\t");
  Serial.print(yAngle,0);Serial.print("\t");
  Serial.println("");*/
  
  processing();  
}
