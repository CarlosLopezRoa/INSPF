//convert all axis
int maxAngle = 90;

void convert()
{
//convert the gyro x-axis
 if(stringGyroX != null) 
 {
   //trim off any whitespace:
   stringGyroX = trim(stringGyroX);
   //convert to an float and map to the screen height:
   inGyroX = float(stringGyroX);
   inGyroX = map(inGyroX, maxAngle, -maxAngle, 0, height);
   gyroX[gyroX.length-1] = int(inGyroX);
 }
 
 //convert the gyro y-axis
 if (stringGyroY != null) 
 {
   //trim off any whitespace:
   stringGyroY = trim(stringGyroY);
   //convert to an float and map to the screen height:
   inGyroY = float(stringGyroY);
   inGyroY = map(inGyroY, maxAngle, -maxAngle, 0, height);
   gyroY[gyroY.length-1] = int(inGyroY);
 }
 //convert the accelerometer x-axis
 if (stringAccX != null) 
 {
   //trim off any whitespace:
   stringAccX = trim(stringAccX);
   //convert to an float and map to the screen height:
   inAccX = float(stringAccX);
   inAccX = map(inAccX, maxAngle, -maxAngle, 0, height);
   accX[accX.length-1] = int(inAccX);
 }
 //convert the accelerometer y-axis
 if (stringAccY != null) 
 {
   //trim off any whitespace:
   stringAccY = trim(stringAccY);
   //convert to an float and map to the screen height:
   inAccY = float(stringAccY);
   inAccY = map(inAccY, maxAngle, -maxAngle, 0, height);
   accY[accY.length-1] = int(inAccY);
 }
 
 //convert the complementary filter x-axis
 if (stringCompX != null) 
 {
   //trim off any whitespace:
   stringCompX = trim(stringCompX);
   //convert to an float and map to the screen height:
   inCompX = float(stringCompX);
   inCompX = map(inCompX, maxAngle, -maxAngle, 0, height);
   compX[compX.length-1] = int(inCompX);
 }
  //convert the complementary filter x-axis
 if (stringCompY != null) 
 {
   //trim off any whitespace:
   stringCompY = trim(stringCompY);
   //convert to an float and map to the screen height:
   inCompY = float(stringCompY);
   inCompY = map(inCompY, maxAngle, -maxAngle, 0, height);
   compY[compY.length-1] = int(inCompY);
 }
 //convert the kalman filter x-axis
 if (stringKalmanX != null) 
 {
   //trim off any whitespace:
   stringKalmanX = trim(stringKalmanX);
   //convert to an float and map to the screen height:
   inKalmanX = float(stringKalmanX);
   inKalmanX = map(inKalmanX, maxAngle, -maxAngle, 0, height);
   kalmanX[kalmanX.length-1] = int(inKalmanX);
 }
  //convert the kalman filter y-axis
 if (stringKalmanY != null) 
 {
   //trim off any whitespace:
   stringKalmanY = trim(stringKalmanY);
   //convert to an float and map to the screen height:
   inKalmanY = float(stringKalmanY);
   inKalmanY = map(inKalmanY, maxAngle, -maxAngle, 0, height);
   kalmanY[kalmanY.length-1] = int(inKalmanY);
 }
}
