// DANGER: The BMP08 accepts 1.8 to 3.6 Volts – so no chance to connect it directly to 5 Volts.

#define SA0 1 
#if SA0
#define MMA8452_ADDRESS 0x1D 
#else
#define MMA8452_ADDRESS 0x1C
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

////


//



