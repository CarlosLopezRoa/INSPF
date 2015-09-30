// DANGER: The BMP08 accepts 1.8 to 3.6 Volts – so no chance to connect it directly to 5 Volts.

/*  BMP08
 SDA            A4. 
 SCL            A5, 
 XCLR           --
 EOC            D2
 GND            GND
 VCC            VCC
 
 MMA8452 Breakout -------- Arduino
 3.3V --------------------- 3.3V
 SDA ----------------------- A4
 SCL ----------------------- A5
 INT2 ---------------------- D3
 INT1 ---------------------- D2
 GND ---------------------- GND
 */

#include "i2c.h"
#include <Wire.h>
//#include "types.h"
//#include "defs.h"

#define SA0 1 
#if SA0
#define MMA8452_ADDRESS 0x1D  //1D
#else
#define MMA8452_ADDRESS 0x1C // 1C
#endif

#define I2C_ADDRESS 0x77
#define BMP085_ADDRESS 0x77  // I2C address of BMP085

const unsigned char OSS = 0;  // Oversampling Setting

// Calibration values
int ac1;
int ac2; 
int ac3; 
unsigned int ac4;
unsigned int ac5;
unsigned int ac6;
int b1; 
int b2;
int mb;
int mc;
int md;

// b5 is calculated in bmp085GetTemperature(...), this variable is also used in bmp085GetPressure(...)
// so ...Temperature(...) must be called before ...Pressure(...).
long b5; 

short temperature;
long pressure;
///

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
int i;
////


//

void setup(){
    Serial.begin(9600); // start serial for output
   mma8452setup();
    bmp08setup();
    
}// Fin de Setup

void loop(){
    mma8452loop();
   bmp08loop();
   // Serial.print("\t");
    Serial.println();
    //i++;
    //if (i>100)
    //i=0;
    delay(t);
    
}//Fin de loop

void bmp08setup(){
    //Wire.begin();
    bmp085Calibration();
    Serial.println("BMP085 Encontrado");
    
}// Fin de bmp08setup

void mma8452setup(){
    byte c;
    
    // Serial.begin(115200);
    
    pinMode(int1Pin, INPUT);
    digitalWrite(int1Pin, LOW);
    pinMode(int2Pin, INPUT);
    digitalWrite(int2Pin, LOW);
    
    c = readRegister(0x0D);  
    if (c == 0x2A) //0x2A
    {  
        initMMA8452(scale, dataRate);  
        Serial.println("MMA8452Q encontrado");
    }
    else
    {
        Serial.print("No se puede conectar a MMA8452Q: 0x");
        Serial.println(c, HEX);
    }
}//Fin de mma8452setup

void bmp08loop(){
    temperature = bmp085GetTemperature(bmp085ReadUT());
    pressure = bmp085GetPressure(bmp085ReadUP());
    // Serial.print("Temperatura: ");
    Serial.print(temperature, DEC);
    Serial.print("\t");
    //Serial.print(" *0.1 deg C");
    // Serial.print("Presion: ");
    Serial.print(pressure, DEC);
    //   Serial.print(" Pa");
    //    delay(100);
}//Fin de bmp08loop

void mma8452loop(){  
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
            // a+=pow(accel[i],2);
        }
        //a=sqrt(a);
        //a-=0.976735;
        //an+=a*t;
        // Serial.print(a,10);
        // Serial.print(',');
        // Serial.print(",");
        //  Serial.print(an,10);
        
    }//Fin de interrupcion 1
    
   /*  if (digitalRead(int2Pin))
     {
     source = readRegister(0x0C);  
     if ((source & 0x10)==0x10)  
     portraitLandscapeHandler();
     else if ((source & 0x08)==0x08) 
     tapHandler();
     }//Fin de interrupcion 2*/
    
}//Fin de mma8452loop

void bmp085Calibration(){
    // Stores all of the bmp085's calibration values into global variables
    // Calibration values are required to calculate temp and pressure
    // This function should be called at the beginning of the program
    ac1 = bmp085ReadInt(0xAA);
    ac2 = bmp085ReadInt(0xAC);
    ac3 = bmp085ReadInt(0xAE);
    ac4 = bmp085ReadInt(0xB0);
    ac5 = bmp085ReadInt(0xB2);
    ac6 = bmp085ReadInt(0xB4);
    b1 = bmp085ReadInt(0xB6);
    b2 = bmp085ReadInt(0xB8);
    mb = bmp085ReadInt(0xBA);
    mc = bmp085ReadInt(0xBC);
    md = bmp085ReadInt(0xBE);
} //Fin de bmp085Calibration

short bmp085GetTemperature(unsigned int ut){
    // Calculate temperature given ut.
    // Value returned will be in units of 0.1 deg C
    long x1, x2;
    
    x1 = (((long)ut - (long)ac6)*(long)ac5) >> 15;
    x2 = ((long)mc << 11)/(x1 + md);
    b5 = x1 + x2;
    
    return ((b5 + 8)>>4);  
}//Fin de bmp085GetTemperature

long bmp085GetPressure(unsigned long up){
    // Calculate pressure given up
    // calibration values must be known
    // b5 is also required so bmp085GetTemperature(...) must be called first.
    // Value returned will be pressure in units of Pa.
    long x1, x2, x3, b3, b6, p;
    unsigned long b4, b7;
    
    b6 = b5 - 4000;
    // Calculate B3
    x1 = (b2 * (b6 * b6)>>12)>>11;
    x2 = (ac2 * b6)>>11;
    x3 = x1 + x2;
    b3 = (((((long)ac1)*4 + x3)<<OSS) + 2)>>2;
    
    // Calculate B4
    x1 = (ac3 * b6)>>13;
    x2 = (b1 * ((b6 * b6)>>12))>>16;
    x3 = ((x1 + x2) + 2)>>2;
    b4 = (ac4 * (unsigned long)(x3 + 32768))>>15;
    
    b7 = ((unsigned long)(up - b3) * (50000>>OSS));
    if (b7 < 0x80000000)
        p = (b7<<1)/b4;
    else
        p = (b7/b4)<<1;
    
    x1 = (p>>8) * (p>>8);
    x1 = (x1 * 3038)>>16;
    x2 = (-7357 * p)>>16;
    p += (x1 + x2 + 3791)>>4;
    
    return p;
} //Fin de bmp085GetPressure

char bmp085Read(unsigned char address){
    // Read 1 byte from the BMP085 at 'address'

    unsigned char data;
    
    Wire.beginTransmission(BMP085_ADDRESS);
    Wire.write(address);
    Wire.endTransmission();
    
    Wire.requestFrom(BMP085_ADDRESS, 1);
    while(!Wire.available())
        ;
    
    return Wire.read();
} //Fin de bmp085Read

int bmp085ReadInt(unsigned char address){
    // Read 2 bytes from the BMP085
    // First byte will be from 'address'
    // Second byte will be from 'address'+1
    unsigned char msb, lsb;
    
    Wire.beginTransmission(BMP085_ADDRESS);
    Wire.write(address);
    Wire.endTransmission();
    
    Wire.requestFrom(BMP085_ADDRESS, 2);
    while(Wire.available()<2)
        ;
    msb = Wire.read();
    lsb = Wire.read();
    
    return (int) msb<<8 | lsb;
}//Fin de bmp085ReadInt

unsigned int bmp085ReadUT(){
    // Read the uncompensated temperature value

    unsigned int ut;
    
    // Write 0x2E into Register 0xF4
    // This requests a temperature reading
    Wire.beginTransmission(BMP085_ADDRESS);
    Wire.write(0xF4);
    Wire.write(0x2E);
    Wire.endTransmission();
    
    // Wait at least 4.5ms
    delay(5);
    
    // Read two bytes from registers 0xF6 and 0xF7
    ut = bmp085ReadInt(0xF6);
    return ut;
}//Fin de bmp085ReadUT

unsigned long bmp085ReadUP(){
    // Read the uncompensated pressure value

    unsigned char msb, lsb, xlsb;
    unsigned long up = 0;
    
    // Write 0x34+(OSS<<6) into register 0xF4
    // Request a pressure reading w/ oversampling setting
    Wire.beginTransmission(BMP085_ADDRESS);
    Wire.write(0xF4);
    Wire.write(0x34 + (OSS<<6));
    Wire.endTransmission();
    
    // Wait for conversion, delay time dependent on OSS
    delay(2 + (3<<OSS));
    
    // Read register 0xF6 (MSB), 0xF7 (LSB), and 0xF8 (XLSB)
    Wire.beginTransmission(BMP085_ADDRESS);
    Wire.write(0xF6);
    Wire.endTransmission();
    Wire.requestFrom(BMP085_ADDRESS, 3);
    
    // Wait for data to become available
    while(Wire.available() < 3)
        ;
    msb = Wire.read();
    lsb = Wire.read();
    xlsb = Wire.read();
    
    up = (((unsigned long) msb << 16) | ((unsigned long) lsb << 8) | (unsigned long) xlsb) >> (8-OSS);
    
    return up;
}// Fin de bmp085ReadUP

void initMMA8452(byte fsr, byte dataRate){
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
} // Fin de initMMA8452

void MMA8452Standby(){
    /* Sets the MMA8452 to standby mode.
     It must be in standby to change most register settings */

    byte c = readRegister(0x2A);
    writeRegister(0x2A, c & ~(0x01));
} //Fin de MMA8452Standby

void MMA8452Active(){
    /* Sets the MMA8452 to active mode.
     Needs to be in this mode to output data */

    byte c = readRegister(0x2A);
    writeRegister(0x2A, c | 0x01);
} // Fin de MMA8452Active

void readRegisters(byte address, int i, byte * dest){
    /* Read i registers sequentially, starting at address 
     into the dest byte arra */
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
} //Fin de readRegisters

byte readRegister(uint8_t address){
    /* read a single byte from address and return it as a byte */

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
} //Fin de readRegister

void writeRegister(unsigned char address, unsigned char data){
    /* Writes a single byte (data) into address */

    i2cSendStart();
    i2cWaitForComplete();
    
    i2cSendByte((MMA8452_ADDRESS<<1));// write 0xB4
    i2cWaitForComplete();
    
    i2cSendByte(address);	// write register address
    i2cWaitForComplete();
    
    i2cSendByte(data);
    i2cWaitForComplete();
    
    i2cSendStop();
} //Fin de writeRegister

void portraitLandscapeHandler(){
    /* This function will read the p/l source register and
     print what direction the sensor is now facing */
    byte pl = readRegister(0x10);  // Reads the PL_STATUS register
    switch((pl&0x06)>>1)  // Check on the LAPO[1:0] bits
    {
        case 0:
            Serial.print("Portrait up, ");
            break;
        case 1:
            Serial.print("Portrait Down, ");
            break;
        case 2:
            Serial.print("Landscape Right, ");
            break;
        case 3:
            Serial.print("Landscape Left, ");
            break;
    }
    if (pl&0x01)  // Check the BAFRO bit
        Serial.print("Back");
    else
        Serial.print("Front");
    if (pl&0x40)  // Check the LO bit
        Serial.print(", Z-tilt!");
    Serial.println();
} // Fin de portraitLandscapeHandler

void tapHandler(){
    /* This function will read the status of the tap source register.
     And print if there's been a single or double tap, and on what
     axis. */
    byte source = readRegister(0x22);  // Reads the PULSE_SRC register
    
    if ((source & 0x10)==0x10)  // If AxX bit is set
    {
        if ((source & 0x08)==0x08)  // If DPE (double puls) bit is set
            Serial.print("    2 X");
        else
            Serial.print("1 X");
        
        if ((source & 0x01)==0x01)  // If PoIX is set
            Serial.println(" +");
        else
            Serial.println(" -");
    }
    if ((source & 0x20)==0x20)  // If AxY bit is set
    {
        if ((source & 0x08)==0x08)  // If DPE (double puls) bit is set
            Serial.print("    2 Y");
        else
            Serial.print("1 Y");
        
        if ((source & 0x02)==0x02)  // If PoIY is set
            Serial.println(" +");
        else
            Serial.println(" -");
    }
    if ((source & 0x40)==0x40)  // If AxZ bit is set
    {
        if ((source & 0x08)==0x08)  // If DPE (double puls) bit is set
            Serial.print("    2 Z");
        else
            Serial.print("1 Z");
        if ((source & 0x04)==0x04)  // If PoIZ is set
            Serial.println(" +");
        else
            Serial.println(" -");
    }
}//Fin de tapHandler





