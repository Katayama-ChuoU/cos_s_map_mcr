function D=equations(t,C,m,O,R,kinit1,choose)

[nrowO,ncolO]=size(O);

for can1=1:nrowO;
    
    for can2=1:ncolO;
        X(:,can2)=C(can2).^O(can1,can2);
        piat=prod(X);
        [can2,can3]=size(kinit1);
        
        if can2>can3
            kinitd=kinit1';
        else
            kinitd=kinit1;
        end
        
        p(1,can1)=piat.*kinitd(1,can1);
        
    end
    
end

for can1=1:nrowO;
    
    for m=1:ncolO;
        
        aux(m,can1)=p(can1)*R(m,can1);
        D(m,1)=sum(aux(m,:));
        
    end
    
end

