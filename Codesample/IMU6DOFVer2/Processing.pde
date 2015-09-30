//print data to processing
void processing()
{
  Serial.print(gyroXangle);Serial.print("\t");
  Serial.print(gyroYangle);Serial.print("\t");
  
  Serial.print(accXangle);Serial.print("\t");
  Serial.print(accYangle);Serial.print("\t");  
  
  Serial.print(compAngleX);Serial.print("\t");  
  Serial.print(compAngleY); Serial.print("\t"); 
  
  Serial.print(xAngle);Serial.print("\t");
  Serial.print(yAngle);Serial.print("\t");
   
  Serial.print("\n");
}
