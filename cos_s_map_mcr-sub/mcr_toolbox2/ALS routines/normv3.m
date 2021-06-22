function [sn]=normv3(s);

% function [vn]=normv3(v,inorm)
% if inorm=1, columns divided by Frobenius norm 
% if inorm=2, rows divides by Frobenius norm 
% if inorm=3, columns divided by total sum norm
% if inorm=4, rows divided by total sum norm

[m,n]=size(s);
sn=zeros(m,n);

for i=1:m,
    sr=sum(abs(s(i,:)));
    sn(i,:)=abs(s(i,:))./sr;
end

