function [D,I,ZDATA] = Stationarity_Test(data)
zdata=[data];
data_adf=adftest(data);
i=0;
if data_adf==1%序列平稳
    D=data;
    I=i;
else%序列非平稳
    while 1
        data=diff(data);
        data_adf=adftest(data);
        i=i+1;
        data_temp=[zeros(1,i) data];
        zdata=[zdata;data_temp];
        if data_adf==1
            break
        end
    end
end
D=data;
I=i;
ZDATA=zdata;
end

