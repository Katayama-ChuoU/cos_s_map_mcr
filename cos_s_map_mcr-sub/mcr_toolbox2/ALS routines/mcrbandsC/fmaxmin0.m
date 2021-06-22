function [f]=fmaxmin0(t,c,s,m,imaxmin,ioptim,ig,clos,cknown,nexp);
% function [f,g]=fmaxmin0(t,c,s,m,imaxmin,ioptim,ig,clos,cknown,nexp);

[nrow,nsign]=size(c);
f=0;
if ig(1,1)==3,t=tconv(t,nsign);end

snew=t*s;
% detsnew=det(snew*snew');
% disp('determinant of the new spectra estimation');disp(detsnew);pause
cnew=c/t;
tnorm=norm(cnew*snew,'fro');
tarea=sum(sum(cnew*snew));


% scalar funtion to be optimimized

if imaxmin==1,
    f=f-norm(cnew(:,ioptim)*snew(ioptim,:),'fro')/tnorm; %maximum band
   % f=f-sum(sum(cnew(:,ioptim)*snew(ioptim,:)))/tarea; %maximum band
   % if abs(f) < 0.1, f=f-sum(sum(cnew(:,ioptim)*snew(ioptim,:)));end
end

if imaxmin==2,
 	f=f+norm(cnew(:,ioptim)*snew(ioptim,:),'fro')/tnorm; %minimum band
 	% f=f+sum(sum(cnew(:,ioptim)*snew(ioptim,:)))/tarea; %minimum band
 	% if abs(f)<0.1, f=f+sum(sum(cnew(:,ioptim)*snew(ioptim,:))); end
end

% disp(t);disp(f);
% pause