function [P,Q] = Get_P_Q(p_range,q_range,data)
test=[];
data=iddata(data');
for p=1:p_range
    for q=1:q_range
        m=armax(data,[p q]);
        AIC=aic(m);
        test=[test;p q AIC];
    end
end
for k=1:size(test,1)
    if test(k,3)==min(test(:,3))
        P=test(k,1);
        Q=test(k,2);
        break
    end
end
end

