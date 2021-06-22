function [f]=fmaxmin(t,c,s,imaxmin,ioptim,ig,clos,cknown,sknown,nexp);
% function [f,g]=fmaxmin0(t,c,s,imaxmin,ioptim,ig,clos,cknown,nexp);

[nrow,nsign]=size(c);
f=0;
if ig(1,1)==3,t=tconv(t,nsign);end

snew=t*s;
cnew=c/t;
tnorm=norm(cnew*snew,'fro');

% scalar funtion to be optimimized

if imaxmin==1,
    f=f-norm(cnew(:,ioptim)*snew(ioptim,:),'fro')/tnorm; %maximum band
end
if imaxmin==2,
 	f=f+norm(cnew(:,ioptim)*snew(ioptim,:),'fro')/tnorm; %minimum band
end