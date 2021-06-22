function [g_ineq,g_eq]=mycons0(t,c,s,m,imaxmin,ioptim,ig,clos,cknown,nexp);
% function [g_ineq,g_eq]=mycons0(t,c,s,m,imaxmin,ioptim,ig,clos,cknown,nexp);

global g
global nconstr

[nrow,nsign]=size(c);
f=0;

gnorm=[];gcloseq=[];gclosineq=[];gknown=[];
gcneg=[];gsneg=[];gsel=[];gunimod=[];gtril=[];

if ig(1,1)==3,t=tconv(t,nsign);end

snew=t*s;
cnew=c/t;

% evaluation of constraints

% closure constraints; ig(1,1)=1; as equality constraint

if ig(1,1)==1,
    closnew=sum(cnew');closnew=closnew';
    gclosineq=abs(clos-closnew);
    gcloseq=abs(clos-closnew);
    % pause
end

% normalization constraints;  ig(1,1)=2; as equality constraint (this constraint is not compatible with closure)

if ig(1,1)==2,
   for i=1:nsign,
      gnorm=[gnorm;1-norm(snew(i,:),'fro')];	% nsign spectra normalization constraints
   end   
end   



% non-negative constraints, ig(1,2)=1,2,3; always applied as an inequality constraint 

for i=1:nsign,
   % nsign*nrow nonnegativity concentration non-equility constraints
   if ig(1,2)==1 gcneg=[gcneg;-cnew(:,i)]; end     
   % nsign*ncol non-negativity spectra non-equality constraints
   if ig(1,2)==3,gsneg=[gsneg;-snew(i,:)'];end 
   % nsign*nrow + nsign*ncol concentration + spectra non-negativity constraints
   if ig(1,2)==2 gcneg=[gcneg;-cnew(:,i)];gsneg=[gsneg;-snew(i,:)'];end   
   
end

% known values as equality constraints

if ig(1,3)==1,
   icknown=find(finite(cknown));
   gknown=[gknown;[cnew(icknown)-cknown(icknown)]]; % icknown known values equality constraints
end

% selectivity values as inequality constraints (lower than) 

if ig(1,3)==2,
   icknown=find(finite(cknown));
   % icknown non-equality (lower than) selectivity constraints
   for ii=1:length(icknown)
      if cnew(icknown(ii))>cknown(icknown(ii))
         gsel=[gsel;[cnew(icknown(ii))-cknown(icknown(ii))]];         
      else
         gsel=[gsel;0];
      end
   end
% disp('selectivity'),disp(gknown),pause   
end

% unimodality constraints; ig(1,4)=1,2, as inequality constraints, lower than
if ig(1,4)==1,
   [gunimod]=unimodg(cnew,1.001);
end

% trilinearity constraint; ig(1,5)=2, as inequality constraints, lower than
if ig(1,5)==2,
   nsp=nrow/nexp;
   
   for i=1:nsign,
   ctril=[];
   ninic=1;
   
      for ii=1:nexp
         nfin=ninic-1+nsp;
         ctril=[[ctril],[cnew(ninic:nfin,i)]];
         ninic=nfin+1;
      end
   
   lsvd=svd(ctril);
   ls=lsvd(2)/lsvd(1);
   gtril=[gtril;ls];
   end
end        

% set final vector of constraints
g_eq=[gnorm;gknown];
g_ineq=[gcneg;gsneg;gclosineq;gsel;gunimod;gtril];
nconstr=[length(gnorm),length(gknown),length(gcneg),length(gsneg),length(gsel),length(gunimod),length(gtril),length(gclosineq),length(g)];
g=[g_eq;g_ineq];
%  pause
