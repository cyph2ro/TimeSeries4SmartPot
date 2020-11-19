function [rst,P,Q] = Fit(p,q,i,data)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
test=[];
%确定pq变化范围
if p==1
    p_range=[p,p+1];
else
    p_range=[p-1,p,p+1];
end

if q==1
    q_range=[q,q+1];
else
    q_range=[q-1,q,q+1];
end
%pq优化
for p=p_range
    for q=q_range
        try
            mdl=arima(p,i,q);
            estmdl=estimate(mdl,data');
            [res,~,logL]=infer(estmdl,data');
            diffRes0=diff(res);
            SSE0=res'*res;
            DW0=(diffRes0'*diffRes0)/SSE0;
            temp=abs(DW0-2);
            test=[test;p q temp];
        catch
            continue
        end
    end
end

for k=1:size(test,1)
    if test(k,3)==min(test(:,3))
        p=test(k,1);
        q=test(k,2);
        break
    end
end

mdl=arima(p,i,q);
estmdl=estimate(mdl,data');
[res,~,logL]=infer(estmdl,data');%res为残差
%{
stdr=res/sqrt(estmdl.Variance);%残差标准化
figure('Name','拟合检验')
%自相关函数ACF
subplot(2,2,1)
autocorr(stdr)
%偏自相关函数PACF
subplot(2,2,2)
parcorr(stdr)
%残差分布
subplot(2,2,3)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,2,4)
qqplot(stdr)
%}
diffRes0=diff(res);
SSE0=res'*res;
DW0=(diffRes0'*diffRes0)/SSE0;
rst=DW0;
P=p;
Q=q;
end

