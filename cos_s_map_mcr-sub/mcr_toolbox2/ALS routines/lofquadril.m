function [r2t2,loft]=lofquadril(dq,u1,u2,u3,u4)
% function [r2t2,loft]=lofquadril(dq,u1,u2,u3,u4)
% dq should be entered as a 4-way hypercube dq(ne1,ne2,ne3,ne4)
% u1(ne1,ns), u2(ne2,ns), u3(ne3,ns), u4(ne4,ns) loading matrices in the four modes 
% entered as column matrices!!!

[ne1,ne2,ne3,ne4]=size(dq);
[ne4v,n]=size(u4);

% check for dimensions of v
if ne4v==ne4, 
    disp('lof and R2 of the quadrilinear model')
else
    disp('check dimensions of u4, they should entered as a column matrixbe (nvariables,ncomponents)')
end

% lofquadril (dq,u1,u2,u3,v')


for i=1:ne1
    for j=1:ne2
        for k=1:ne3
            for l=1:ne4
                if isfinite(dq(i,j,k,l))==1,
                    dqc(i,j,k,l)=0;
                    for ls=1:n
                        dqc(i,j,k,l)=dqc(i,j,k,l)+u1(i,ls)*u2(j,ls)*u3(k,ls)*u4(l,ls);
                    end
                end
            end
        end
    end
end


ifn=find(isfinite(dq)==1);
res=dq(ifn)-dqc(ifn);
sumdt=sum(sum(sum(sum(dq(ifn).*dq(ifn)))));
sumdtc=sum(sum(sum(sum(dqc(ifn).*dqc(ifn)))));
sumres=sum(sum(sum(sum((res.*res)))));
% disp(['sstot,sscalc and ssres = ',num2str([sumdt,sumdtc,sumres])]);
loft=(sqrt(sumres/sumdt))*100;
r2t1=((sumdtc)/sumdt)*100;
r2t2=((sumdt-sumres)/sumdt)*100;
disp(['lof (%) = ',num2str(loft)]);
% disp(['fit (%) = ',num2str(100-loft)]);
% disp(['R square is = ',num2str(r2)]);
% fprintf(1,'Rsquare is %15.12f\n',r2t1',r2t2)
% disp(['expl.var (unique)% = ',num2str(r2t1)]);
disp(['R2 % = ',num2str(r2t2)]);

end


