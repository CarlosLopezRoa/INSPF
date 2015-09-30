//This is pretty simple. It takes 100 readings and calculate the average.

//gyros
int inputGyroX[100];//x-axis
long resultGyroX;

int inputGyroY[100];//y-axis
long resultGyroY;

int inputGyroZ[100];//z-axis
long resultGyroZ;

//accelerometers
int inputAccX[100];//x-axis
long resultAccX;

int inputAccY[100];//y-axis
long resultAccY;

int inputAccZ[100];//z-axis
long resultAccZ;

//gyros
int calibrateGyroX()
{
  for(int i=0;i<100;i++)
  {
    inputGyroX[i] = analogRead(gX);
  }
  for(int i=0;i<100;i++)
  {
    resultGyroX += inputGyroX[i];
  }
  resultGyroX = resultGyroX/100;
  return resultGyroX;
}

int calibrateGyroY()
{
  for(int i=0;i<100;i++)
  {
    inputGyroY[i] = analogRead(gY);
  }
  for(int i=0;i<100;i++)
  {
    resultGyroY += inputGyroY[i];
  }
  resultGyroY = resultGyroY/100;
  return resultGyroY;
}

int calibrateGyroZ()
{
  for(int i=0;i<100;i++)
  {
    inputGyroZ[i] = analogRead(gZ);
  }
  for(int i=0;i<100;i++)
  {
    resultGyroZ += inputGyroZ[i];
  }
  resultGyroZ = resultGyroZ/100;
  return resultGyroZ;
}

//accelerometers
int calibrateAccX()
{
  for(int i=0;i<100;i++)
  {
    inputAccX[i] = analogRead(aX);
  }
  for(int i=0;i<100;i++)
  {
    resultAccX += inputAccX[i];
  }
  resultAccX = resultAccX/100;
  return resultAccX;
}
 
int calibrateAccY()
{
  for(int i=0;i<100;i++)
  {
    inputAccY[i] = analogRead(aY);
  }
  for(int i=0;i<100;i++)
  {
    resultAccY += inputAccY[i];
  }
  resultAccY = resultAccY/100;
  return resultAccY;
}

int calibrateAccZ()
{
  for(int i=0;i<100;i++)
  {
    inputAccZ[i] = analogRead(aZ);
  }
  for(int i=0;i<100;i++)
  {
    resultAccZ += inputAccZ[i];
  }
  resultAccZ = resultAccZ/100;
  return resultAccZ;
}
