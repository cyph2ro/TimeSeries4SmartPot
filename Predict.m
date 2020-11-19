function [rst,frst] = Predict(data,p,q,step)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
z=iddata(data');
m=armax(z,[p q]);
pr=forecast(m,z,step);
po=pr.outputdata();
fpr=predict(m,z,step);
fpo=fpr.outputdata();
rst=po';
frst=fpo';
end

