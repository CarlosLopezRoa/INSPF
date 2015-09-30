#include "i2c.h"
/*
  MMA8452 Breakout ------------ Arduino
       3.3V --------------------- 3.3V
       SDA ----------------------- A4
       SCL ----------------------- A5
       INT2 ---------------------- D3
       INT1 ---------------------- D2
       GND ---------------------- GND
   */
   
#define SA0 1 
#if SA0
  #define MMA8452_ADDRESS 0x1D 
#else
  #define MMA8452_ADDRESS 0x1C
#endif

const byte scale = 2;
const byte dataRate = 0;

int int1Pin = 2; 
int int2Pin = 3;

byte data[6];  
int accelCount[3];  
float accel[3];  
float a;
float an = 0;
int t = 100;
  
void setup()
{
  byte c;
  
  Serial.begin(115200);
  
  pinMode(int1Pin, INPUT);
  digitalWrite(int1Pin, LOW);
  pinMode(int2Pin, INPUT);
  digitalWrite(int2Pin, LOW);
  
  c = readRegister(0x0D);  
  if (c == 0x2A) 
  {  
    initMMA8452(scale, dataRate);  
    Serial.println("MMA8452Q encontrado");
  }
  else
  {
    Serial.print("No se puede conectar a MMA8452Q: 0x");
    Serial.println(c, HEX);
    while (1)  
      ;
  }
}//Fin de setup


void loop()
{  
  static byte source;
  
  if (digitalRead(int1Pin))  
  {
    readRegisters(0x01, 6, &data[0]);  
    
    for (int i=0; i<6; i+=2)
    {
      accelCount[i/2] = ((data[i] << 8) | data[i+1]) >> 4; 
      if (data[i] > 0x7F)
      {  
        accelCount[i/2] = ~accelCount[i/2] + 1;
        accelCount[i/2] *= -1;  
      }
      accel[i/2] = (float) accelCount[i/2]/((1<<12)/(2*scale));  
    }
    a=0;
   for (int i=0; i<3; i++)
    {
     Serial.print(accel[i],10);
     Serial.print('\t');
    a+=pow(accel[i],2);
    }
   a=sqrt(a);
  a-=0.976735;
   an+=a*t;
    Serial.print(a,10);
   // Serial.print(",");
  //  Serial.print(an,10);

    Serial.println();
  }//Fin de interrupcin 1

 /* if (digitalRead(int2Pin))
  {
    source = readRegister(0x0C);  
    if ((source & 0x10)==0x10)  
      portraitLandscapeHandler();
    else if ((source & 0x08)==0x08) 
      tapHandler();
  }*/
      delay(t);  

}//Fin de loop

void initMMA8452(byte fsr, byte dataRate)
{
  MMA8452Standby();  // Must be in standby to change registers
  
  /* Set up the full scale range to 2, 4, or 8g. */
  if ((fsr==2)||(fsr==4)||(fsr==8))
    writeRegister(0x0E, fsr >> 2);  
  else
    writeRegister(0x0E, 0);
  /* Setup the 3 data rate bits, from 0 to 7 */
  writeRegister(0x2A, readRegister(0x2A) & ~(0x38));
  if (dataRate <= 7)
    writeRegister(0x2A, readRegister(0x2A) | (dataRate << 3));  
  /* Set up portrait/landscap registers */
  writeRegister(0x11, 0x40);  // Enable P/L
  writeRegister(0x13, 0x14);  // 29deg z-lock, 
  writeRegister(0x14, 0x84);  // 45deg thresh, 14deg hyst
  writeRegister(0x12, 0x05);  // debounce counter at 100ms 
  /* Set up single and double tap */
  writeRegister(0x21, 0x7F);  // enable single/double taps on all axes
  writeRegister(0x23, 0x20);  // x thresh at 2g
  writeRegister(0x24, 0x20);  // y thresh at 2g
  writeRegister(0x25, 0x8);  // z thresh at .5g
  writeRegister(0x26, 0x30);  // 60ms time limit, the min/max here is very dependent on output data rate
  writeRegister(0x27, 0x28);  // 200ms between taps min
  writeRegister(0x28, 0xFF);  // 1.275s (max value) between taps max
  /* Set up interrupt 1 and 2 */
  writeRegister(0x2C, 0x02);  // Active high, push-pull
  writeRegister(0x2D, 0x19);  // DRDY int enabled, P/L enabled
  writeRegister(0x2E, 0x01);  // DRDY on INT1, P/L on INT2
  
  MMA8452Active();  // Set to active to start reading
}

/* Sets the MMA8452 to standby mode.
   It must be in standby to change most register settings */
void MMA8452Standby()
{
  byte c = readRegister(0x2A);
  writeRegister(0x2A, c & ~(0x01));
}

/* Sets the MMA8452 to active mode.
   Needs to be in this mode to output data */
void MMA8452Active()
{
  byte c = readRegister(0x2A);
  writeRegister(0x2A, c | 0x01);
}

/* Read i registers sequentially, starting at address 
   into the dest byte arra */
void readRegisters(byte address, int i, byte * dest)
{
  i2cSendStart();
  i2cWaitForComplete();
  
  i2cSendByte((MMA8452_ADDRESS<<1));	// write 0xB4
  i2cWaitForComplete();
  
  i2cSendByte(address);	// write register address
  i2cWaitForComplete();
  
  i2cSendStart();
  i2cSendByte((MMA8452_ADDRESS<<1)|0x01);	// write 0xB5
  i2cWaitForComplete();
  for (int j=0; j<i; j++)
  {
    i2cReceiveByte(TRUE);
    i2cWaitForComplete();
    dest[j] = i2cGetReceivedByte();	// Get MSB result
  }
  i2cWaitForComplete();
  i2cSendStop();
  
  cbi(TWCR, TWEN);	// Disable TWI
  sbi(TWCR, TWEN);	// Enable TWI
}

/* read a single byte from address and return it as a byte */
byte readRegister(uint8_t address)
{
  byte data;
  
  i2cSendStart();
  i2cWaitForComplete();
  
  i2cSendByte((MMA8452_ADDRESS<<1));	// write 0xB4
  i2cWaitForComplete();
  
  i2cSendByte(address);	// write register address
  i2cWaitForComplete();
  
  i2cSendStart();
  
  i2cSendByte((MMA8452_ADDRESS<<1)|0x01);	// write 0xB5
  i2cWaitForComplete();
  i2cReceiveByte(TRUE);
  i2cWaitForComplete();
  
  data = i2cGetReceivedByte();	// Get MSB result
  i2cWaitForComplete();
  i2cSendStop();
  
  cbi(TWCR, TWEN);	// Disable TWI
  sbi(TWCR, TWEN);	// Enable TWI
  
  return data;
}

/* Writes a single byte (data) into address */
void writeRegister(unsigned char address, unsigned char data)
{
  i2cSendStart();
  i2cWaitForComplete();
  
  i2cSendByte((MMA8452_ADDRESS<<1));// write 0xB4
  i2cWaitForComplete();
  
  i2cSendByte(address);	// write register address
  i2cWaitForComplete();
  
  i2cSendByte(data);
  i2cWaitForComplete();
  
  i2cSendStop();
}


