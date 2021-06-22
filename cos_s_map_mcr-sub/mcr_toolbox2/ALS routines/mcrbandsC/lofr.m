function [sigma]=lofr(de,c,s)
% function [sigma]=lof(de,c,s)

[nr,nc]=size(de);
[nr,ns]=size(c);
dr=c*s;
res=de-dr;
sst1=sum(sum(res.*res));
sst2=sum(sum(de.*de));
sigma=(sqrt(sst1/sst2))*100;
r2=(sst2-sst1)/sst2;
disp([ ])

