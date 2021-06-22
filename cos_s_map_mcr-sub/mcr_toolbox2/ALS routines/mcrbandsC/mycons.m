function [g_ineq,g_eq]=mycons(t,c,s,imaxmin,ioptim,ig,clos,cknown,sknown,nexp);
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
    % aquí pensar en el nou closure
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

% known row (concentration) values as equality constraints

if ig(1,3)==1,
    icknown=isfinite(cknown);
    ncknown=find(icknown);
    gknown=[gknown;[cnew(ncknown)-cknown(ncknown)]]; % ncknown known values equality constraints
end

% selectivity row (concentration) values as inequality constraints (lower than) 

if ig(1,3)==2,
    icknown=isfinite(cknown);
    ncknown=find(icknown);
    for ii=1:length(ncknown)
        if cnew(ncknown(ii))>cknown(ncknown(ii))
            gsel=[gsel;[cnew(ncknown(ii))-cknown(ncknown(ii))]];
        else
            gsel=[gsel;0];
        end
    end
end

% known column (spectra) values as equality constraints

if ig(1,4)==1,
    isknown=isfinite(sknown);
    nsknown=find(isknown);
    gknown=[gknown;[snew(nsknown)-sknown(nsknown)]]; % nsknown known spectra values equality constraints
end

% selectivity column (spectra) values as inequality constraints (lower than) 

if ig(1,4)==2,
    isknown=isfinite(sknown);
    nsknown=find(isknown);
    for ii=1:length(nsknown)
        if snew(nsknown(ii))>sknown(nsknown(ii))
            gsel=[gsel;[snew(nsknown(ii))-sknown(nsknown(ii))]];
        else
            gsel=[gsel;0];
        end
    end
end


% unimodality constraints; ig(1,5)=1,2, as inequality constraints, lower than
% current implementation of unimodality is with unimodality control parameter 
% rmod equal to 1.1
if ig(1,5)==1,    
    if ig(1,6)>0,
        nsp=nrow/nexp;
        ninic=1;
        for i=1:nexp,
            nfin=ninic-1+nsp;
            gunimodu=unimodg(cnew(ninic:nfin,:),1.1);
            ninic=nfin+1;
            % if isempty(gunimodu),gunimod=0;end
            [gunimod]=[gunimod;gunimodu];            
        end
    else
        [gunimod]=[gunimod;unimodg(cnew,1.1)];
    end
end

% trilinearity constraint; ig(1,6)=2, as inequality constraints, lower than
if ig(1,6)==2,
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
