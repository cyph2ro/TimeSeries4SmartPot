//库
#include <Wire.h>

//BH1750光照传感器参数、端口配置
#define BH1750Address 0x23//BH1750光照传感器地址配置:GND ADD->GND;VCC->5V;SCL->A5;SDA->A4
#define ONE_TIME_H_RESOLUTION_MODE 0x20//BH1750光照传感器模式设置
byte highByte = 0;
byte lowByte = 0;
unsigned int sensorOut = 0;
unsigned int illuminance = 0;//光照度
//LED灯参数、端口配置
//采用带PWM输出的DO接口
int ledPin = 11;
//土壤湿度传感器参数、端口配置
float value1 = 0;
float value2 = 0;
float sdvalue1 = 0;
float sdvalue2 = 0;
float rstvalue = 0;
int incomedate;//指令信号
int sdpin1 = A1;
int sdpin2 = A2;
//继电器信号端口配置
int relayPin=10;

//设置函数
void setup() 
{
  //BH1750光照传感器、土壤湿度传感器数据传输设置
  Wire.begin();//启动Wire库
  Serial.begin(9600);//设置波特率9600
  //LED设置
  pinMode(ledPin,OUTPUT);
  digitalWrite(ledPin,LOW);
  //土壤湿度传感器设置
  pinMode(sdpin1,INPUT);
  pinMode(sdpin2,INPUT);
  //继电器设置
  pinMode(relayPin,OUTPUT);
}

//主函数
void loop() 
{
  //光照传感器部分
  Wire.beginTransmission(BH1750Address);//启动BH1750采集数据传输
  Wire.write(ONE_TIME_H_RESOLUTION_MODE);//设置BH1750操作模式
  Wire.endTransmission();
  delay(180);
  Wire.requestFrom(BH1750Address,2);
  highByte = Wire.read();
  lowByte = Wire.read();
  sensorOut = (highByte<<8)|lowByte;
  illuminance = sensorOut/1.2;
  Serial.print(illuminance);
  Serial.println("lux");
  controlLED(illuminance,ledPin);
  //水泵控制部分
  digitalWrite(relayPin,LOW);//关闭继电器
  if (Serial.available() > 0)//串口是否可用
  {
    incomedate = Serial.read();
    if (incomedate == '0')
    {
      Serial.println("pump stop!");
      digitalWrite(relayPin,LOW);
    } 
    else if (incomedate == '1')
    {
      Serial.println("pump start!");
      digitalWrite(relayPin, HIGH);
      delay(100);
    }
  }
  //土壤湿度传感器部分
  value1 = analogRead(sdpin1);
  sdvalue1 = transSD(value1);
  value2 = analogRead(sdpin2);
  sdvalue2 = transSD(value2);
  rstvalue=(sdvalue1+sdvalue2)/2.0;
  Serial.println(rstvalue);
  delay(1000);
}

float transSD(float value)
{
  float rst = 0;
  rst = (1023.0 - value) * 100.0 /1023.0;
  return rst;
}

void controlLED(unsigned int illuminance,int ledPin)
{
  float MAX=255;//PWM最大值
  float outIllum;//PWM输出值
  float transIllum;//转换后的光照强度
  transIllum=illuminance/2500.0*255.0;
  Serial.print(transIllum);
  Serial.println("lux");
  if(transIllum<=MAX)
  {
    outIllum=int(MAX-transIllum);
    Serial.print(outIllum);
    Serial.println("lux");
    analogWrite(ledPin,outIllum); 
  }
  else
  {
    analogWrite(ledPin,0); 
  }
}
