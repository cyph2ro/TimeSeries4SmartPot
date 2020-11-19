function [DATA,temp,ftemp] = Recover(zdata,temp,ftemp,i,step)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
rdata=[];
frdata=[];

rdata(i+1,:)=[zdata(i+1,:) temp];
frdata(i+1,:)=[zdata(i+1,:) ftemp];

len=size(rdata,2);
flen=size(frdata,2);
dl=size(ftemp,2);

for k=i:-1:1
    rdata(k,1:k)=zdata(k,1:k);
    for j=k+1:1:len
        rdata(k,j)=rdata(k,j-1)+rdata(k+1,j);
    end
end

for k=i:-1:1
    frdata(k,1:k)=zdata(k,1:k);
    for j=k+1:1:flen
        frdata(k,j)=frdata(k,j-1)+frdata(k+1,j);
    end
end

DATA=rdata(1,1:(len-step));
temp=rdata(1,(len-step+1):len);
ftemp=frdata(1,(flen-dl+1):flen);
end

