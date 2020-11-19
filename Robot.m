%{
0.湿度测试与浇水实验，6.4首要任务！！！！！！！！！！！
1.真实测湿度时，应该采取3次/min，并采集15分钟，这样湿度会有可观的下降，但是这样演示极不方便；
2.为了演示，我们可能会提高测试频率并缩短测试时间，为了让湿度有可观的下降，可采用吹风机；
3.不需要做训练数据，首次使用的采集数据即可作为训练数据；
4.真实湿度预测，采取了预测5分钟，也可以根据实验结果调整；
5.每次预测的时间较长，大概20s?左右?，那么至少要保证这20s内不会出现缺水情况，不过这没问题，因为预测式浇水，5min远大于20s；
6.在预测时间内，虽然湿度计仍在读数，但因程序执行的问题，不会读到这20s的数据，这是我们可忽略的量，并不影响时间序列分析；
7.写流量控制函数；
%}
%数据准备data
data=[];
while 1
    %数据准备
    data=[];
    data1=GetData();%根据实验结果判定是否需要更改采集实验和采集频率，且需要更改对应硬件程序
    data=[data data1];
    %平稳性检验
    [data,i,zdata]=Stationarity_Test(data);
    %确定AR和MA的阶数
    [p,q]=Get_P_Q(10,10,data);
    %拟合并优化pq
    [fitst,p,q]=Fit(p,q,i,data);
    %预测
    step=15;%根据实验结果再次判定预测步长是否需要修改
    [temp,ftemp]=Predict(data,p,q,step);
    %数据还原
    [data,temp,ftemp]=Recover(zdata,temp,ftemp,i,step);
    figure();
    %all=[data temp];
    len=size(temp,2);
    %flen=size(ftemp,2);
    plot([data temp],'b');
    x=input('Go on?');    
    if x==0
        pause;
    end
    if temp(len)<=20%阈值
        %连接硬件，启动浇水
        clear;
        s = serial('/dev/ttyACM0');
        fopen(s);
        set(s,'BaudRate',9600);
        fwrite(s,'1');
        pause(0.5);
        fwrite(s,'1');
        pause(0.5);
        fwrite(s,'1');
        pause(0.5);
        fwrite(s,'1');
        pause(0.5);
        fwrite(s,'1');
        pause(0.5);
        fwrite(s,'1');
        pause(0.5);
        fclose(s);
        %加一个延时程序，来使水充分扩散
    end
end