mermaid:true

# 适用于智能花盆的时间序列算法[TimeSeries4SmartPot]

## 程序结构

总体程序结构如下图所示：

```mermaid
graph LR
A(GetData)-->B(Stationarity_Test)
B(Stationarity_Test)-->C(Get_P_Q)
C(Get_P_Q)-->D(Fit)
D(Fit)-->E(Predict)
E(Predict)-->F(Recover)
F(Recover)--新一轮循环-->A(GetData)
F(Recover)-->G(判断预测值是否低于设定阈值?)
G(判断预测值是否低于设定阈值?)-->H(Arduino控制程序)
```

## 流程简介

上位机为PC，下位机为Arduino UNO，下位机连接土壤湿度传感器与水泵。

主程序为`Robot.m`，首先是获取数据`GetData.m`，通过土壤湿度传感器获取到湿度值，并通过串口上传至上位机的Matlab中，Matlab将读取到土壤湿度值实时绘制曲线图。

然后，对一轮循环湿度序列进行序列平稳性判断，如果平稳，进入下一阶段，否则将序列通过不断差分运算转换为平稳序列。

采用ARMA自回归滑动平均时间序列模型，首先要在保证模型合理的情况下对AR模型的阶数P和MA模型的阶数Q进行组合，寻求最优组合。

根据获取到的PQ，进行时间序列模型的拟合，并给定指定步长，使用该时间序列模型进行预测。

**！！！**

注意，如果序列平稳性转换时进行了差分运算，要对此时预测出来的序列进行迭代恢复操作，否则得到的都是平稳序列的预测值，对观测没有指导意义

## 原理介绍

ARMA是AR和MA的结合

AR模型定义：
![1](http://latex.codecogs.com/svg.latex?X_t=\sum_{i=1}^p\alpha_iX_{t-i}+\varepsilon_t)

该模型描述预测值与历史值的关系

MA模型定义：
![2](http://latex.codecogs.com/svg.latex?Y_t=\sum_{i=1}^q\beta_i\varepsilon_{t-i}+\varepsilon_t)

该模型描述白噪声

两个模型结合，就需要确定每个模型的多项式阶数，记为P和Q。这里采用AIC函数来量化模型，取AIC值最小时对应的P和Q

## 参数设置

`Robot.m`中第21行`[p,q]=Get_P_Q(10,10,data)`，10为PQ的选取范围，可自行调整。第25行`step=15`，15为预测步长，可自行调整。第38行`if temp(len)<=20`，20为设置的湿度阈值，可自行调整。

另外，本项目由于便于演示，在`Robot.m`和`GetData.m`中，加入了暂停代码段：

```matlab
x = input('Go on?');
if x == 0
	pause;
end
```

当按下0时，暂停程序

`GetData.m`中，由于要调用串口读入，需要设置如下代码段：

```matlab
s = serial('/dev/ttyACM0');%括号中的信息要与Arduino接入计算机采用的端口保持一致
set(s,'BaudRate',9600);%波特率要与Arduino程序中设置的一致
```

同时，在初次使用时，如果报错，可在该程序的4到7行之间的空白处添加如下代码段（参见于`explaination.txt`）：

```matlab
if ~isempty(instrfind)
	fclose(instrfind);
	delete(instrfind);
end
```

第10行`interval=45`中的45为采集数据步长，可自行调整；如若调整，需要对后续的暂停程序进行修改





