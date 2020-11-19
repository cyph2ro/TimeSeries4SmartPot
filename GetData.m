function Data = GetData()
clear;
s = serial('/dev/ttyACM0');  %定义串口对象
set(s,'BaudRate',9600);  %设置波特率s


fopen(s);  %打开串口对象s


interval = 45;%采集时间
%time=9;%中间时间
passo = 1;%相邻信号时间间隔
t = 0;
x = [];
figure();
ttime=0;
tdelt=9;
for i=0:4
    ttime=ttime+tdelt;

    while(t<=ttime)
        b = str2num(fgetl(s));  %用函数fget(s)从缓冲区读取串口数据，当出现终止符（换行符）停止。LD,
        x = [x,b]; %所以在Arduino程序里要使用Serial.println()
        plot(x);
        grid
        t = t+passo;
        drawnow;
    end
    fclose(s);
    zf=input('Go on?');    
    if zf==0
        pause;
    end
    fopen(s);
end
%{
while(t<interval)
    b = str2num(fgetl(s));  %用函数fget(s)从缓冲区读取串口数据，当出现终止符（换行符）停止。LD,
    x = [x,b]; %所以在Arduino程序里要使用Serial.println()
    plot(x);
    grid
    t = t+passo;
    drawnow;
end
%}
fclose(s);
fclose(instrfind);
delete(instrfind);
delete(s);
Data=x;
end