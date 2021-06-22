function [sband,cband,normband,tband,fband]=mcrbands(m,c,s,t0,cknown,sknown,ispec)
% function [sband,cband,normband,tband,foptim]=mcrbands(m,c,s,t0,cknown,sknown,ispec);
% m data matrix; c proposed concn. profiles; s proposed spectra profiles; 
% t0 initial proposed rotation matrix (optional); default is t=eye(nsign) where c(nrow,nsign)
% m = c(old)*s'(old)= c(new)*s'(new) = [c(old)/t]*[t*s(old)]
% cknown and sknown are optional matrices to introduce equality/selectivity constraints (known values)
% ispec is an optional input to give speciation when multiple data matrices are simultaneously analyzed (three-way data)
% the following m-functions are needed
% m function fmaxmin defining optimization function
% m function mycons  defining constraints
% m function unimodg defyning unimodality constraints
% m function lofr evaluating data fitting
% m function fmincon (from Optimization Toolbox 
% MATLAB Optimization Toolbox (Mathworks Inc) is needed to run this function

global g
global nconstr

tband=[];tbandsvd=[];sband=[];cband=[];optband=[];lofband=[];fband=[];detcbands=[];detsbands=[];
foptim=[];iknown=0;iclos=0;iunimod=0;clos=[];ineg=2;nexp=1;itil=0;
nconstr=0;g=[];
tnorm=norm(c*s,'fro');normband=[];


[nrow,nsign]=size(c);
[nsign,ncol]=size(s);

if nargin<3,disp('input fambig(m,c,s,[cknown,sknown,ispec]) minimum 3 arguments'),return,end
if nargin<4,t0=eye(nsign);end
if nargin<5,cknown=[];end
if nargin<6,sknown=[];end
if nargin<7,ispec=[1:nsign];end

close all			% close previous figures

% evaluation of initial determinants
detcbands=det(c'*c);
detsbands=det(s*s');

% old initial values and options
% options=foptions;
% options(1)=1;         % display minimization values
% options(2)=1e-3;		% termination tolerance for t values
% options(3)=1e-4;		% termination tolerance for f(t) values = cnew*snew
% options(4)=1e-4;		% termination criterion on constraint violation
% options(7)=0;			% Line Search Algorithm. (Default 0)
% options(13)=0;		% number of equality constraints
% options(14)=100*nsign	% maximum number of iterations
% options(16)=0.001;  	% minimum change in variables for finite difference gradients
% options(17)=0.1;		% maximum change in variables for finite difference gradients
% options(18)=1;		% step length
% optband=[options];
% options=optimset('Display','iter','Diagnostics','on','TolCon',1e-4,'TolFun',1e-4,'Tolx',1e-4,'DiffMinChange',0.001,'DiffMaxChange',0.1);
options=optimset('Display','iter','Diagnostics','on','TolCon',1e-4,'TolFun',1e-5,'Tolx',1e-4,'DiffMinChange',0.000001,'DiffMaxChange',0.1,'MaxFunEvals',3000);


vlb=ones(size(t0)).*-10;
vub=ones(size(t0)).*10;
% pause

% Noise threshold
nres=lof(m,c,s);
% lofband=nres;
lofband=[lofband;nres];

% definition of constraints ig

% normalization constraints: closure or spectra normalization
disp(' ')
disp('apply closure normalization (1)');
disp('spectra normalization (2)');
disp('spectra normalization using only off-diagonal T values (3)');
disp('or no closure nor normalization (0)');

iclos=input('enter one option 0,1,2,3? ');
ig(1,1)=iclos;

if iclos==1,
   clos=sum(c');clos=clos'; 	% closure constants as defined in input concentrations
end

% non-negativity constraints (inequality constraints)
disp(' ')
disp('apply non-negativity constraints in conc (1)');
disp('non-negativity constraints in spec and conc (2)');
disp('non-negativity constraints only in spec (3)');
disp('or do not apply non-negativity constraints (0)');
ineg=input('enter one option 0,1,2,3? ');
ig(1,2)=ineg;


% equality constraints in cknown (implemented)
disp(' ')
disp('apply equality constraints (1)');
disp('selectivity constraints (<=) (2)');
disp('or do not appply equality constraints (0) ');
iknown=input('enter one option 0,1,2? ');
ig(1,3)=iknown;

% equality constraints in sknown (not implemented for the moment) 

if iknown==1,
icknown=find(finite(cknown));
ncknown=length(icknown);
end

if iknown==2,
icknown=find(finite(cknown));
ncknown=length(icknown);
end

% unimodality constraints in concentrations
disp(' ')
disp('apply unimodality in concn (1)');
disp('unimodality in spectra (2)');
disp('unimodality in both (3)'); 
disp('or do not apply unimodality (0)');
iunimod=input('enter one option 0,1? ');
ig(1,4)=iunimod;

% trilinearity constraints
disp(' ')
disp('multiple data sets = three-way data');
disp('three-way non-trilinear data (1)');
disp('three-way trilinear data (2)');
disp('single data matrix = no three-way data (0)');
itril=input('enter one option 0,1,2? ');
ig(1,5)=itril;

if itril>0,
   nexp=input('number of experiments/data matrices simultaneously analyzed? ');
end 

% ************************************************************
% constrained maximization/minimization  of resolution bands *
% performed separately for each species                      *
% ************************************************************

noptim=length(ispec);

% evaluation of t values from svd
disp('evaluation of t values from svd')
[u,l,v]=svd(c*s);
ul=u(:,1:nsign)*l(1:nsign,1:nsign);


for i=1:noptim;
    disp('estimation of feasible range for species profiles: '); disp(i);
    ioptim=ispec(i);
   
%****************************************************************************************

    if ig(1,1)==3,
        index=0;
        for ii=1:nsign
            for jj=1:nsign
                if ii==jj,dummy=t0(ii,jj);else,index=index+1;tt(1,index)=t0(ii,jj);end
            end
        end
        vlb=[];    
        vub=[];
        % disp(t0)
        % pause
    else
        tt=t0;
    end

    % calculation of the maximum/outer band

    [tmax,fbandmax,exitflag]=fmincon('fmaxmin0',tt,[],[],[],[],[],[],'mycons0',options,c,s,m,1,ioptim,ig,clos,cknown,nexp);
    % function tconv makes the diagonal elements equal to 1
    if ig(1,1)==3,tmax=tconv(tmax,nsign);end; 
    fbandmax=-fbandmax;
    
    % calculation of the minimum/inner band
           
    [tmin,fbandmin,exitflag]=fmincon('fmaxmin0',tt,[],[],[],[],[],[],'mycons0',options,c,s,m,2,ioptim,ig,clos,cknown,nexp);
    % function tconv makes the diagonal elements equal to 1
    if ig(1,1)==3,tmin=tconv(tmin,nsign);end; 
   
    disp('***************************************************')
    disp('OPTIMAL VALUES FOR MAXIMUM CONTRIBUTION OF SPECIES: ');
    disp(ioptim);
    disp('optimal T values (max)');disp(tmax);
    disp('optimal values of the function f(T) at the maximum');disp(-fbandmax);
    disp('termination > 0 (convergence), = 0 (max.number of iterations), < 0 (divergence) :');disp(exitflag);
    disp('****************************************************')
    disp('OPTIMAL VALUES FOR MINIMUM CONTRIBUTION OF SPECIES: ')
    disp(ioptim);
    disp('optimal T values (min)');disp(tmin);
    disp('optimal values of the function f(T) at the minimum');disp(fbandmin);
    disp('termination > 0 (convergence), = 0 (max.number of iterations), < 0 (divergence) :');disp(exitflag);
    disp('***************************************************')
      
    %**************************************************************************************** 
  
  
    % values to keep for the optimization of each species band  

    smax=tmax*s;
    cmax=c/tmax;
    smin=tmin*s;
    cmin=c/tmin;
%     norm(smax(1,:)')
%     norm(smax(2,:)')
%     norm(cmax(:,1))
%     norm(cmax(:,2))
%     norm(smin(1,:)')
%     norm(smin(2,:)')
%     norm(cmin(:,1))
%     norm(cmin(:,2))
%     pause
    tmaxsvd=smax*v(:,1:nsign);
    tminsvd=smin*v(:,1:nsign);
   for i=1:nsign
        tmaxsvd(i,:)=tmaxsvd(i,:)./tmaxsvd(i,i);
        tminsvd(i,:)=tminsvd(i,:)./tminsvd(i,i);
   end
    
    tband=[tband;tmax;tmin];
    tbandsvd=[tbandsvd;tmaxsvd;tminsvd];
    sband=[sband;smax(ioptim,:);smin(ioptim,:)];
    cband=[cband,cmax(:,ioptim),cmin(:,ioptim)];
    fband=[fband;fbandmax;fbandmin];
    lofmax=lofr(m,cmax,smax);
    lofmin=lofr(m,cmin,smin);
    lofband=[lofband;lofmax;lofmin];
    
    % pause
    
    % plot band profiles
    disp('plot of band profiles for species: '),disp(ioptim);
    figure
    subplot(2,1,1),plot(cmax(:,ioptim))
    hold on
    plot(c(:,ioptim),'r:');
    % testclosmax=[sum(cmax')]'
    subplot(2,1,1),plot(c)
    % hold on
    subplot(2,1,2),plot(smax(ioptim,:)')
    hold on
    plot(s(ioptim,:),'r:');
    subplot(2,1,2),plot(smin(ioptim,:)')
    % hold on
    hold off
    % testclosmin=[sum(cmin')]'

    % final evaluation of species contribution for each solution
    
    %for ii=1:nsign
        normmin(ioptim)=norm(cmin(:,ioptim)*smin(ioptim,:),'fro')/tnorm;
        normmax(ioptim)=norm(cmax(:,ioptim)*smax(ioptim,:),'fro')/tnorm;
    %end
    % detcmin=det(cmin'*cmin);
    % detcmax=det(cmax'*cmax);
    % detsmin=det(smin*smin');
    % detsmax=det(smax*smax');
    normband=[normband;normmax(ioptim);normmin(ioptim)];
    % detcbands=[detcbands;detcmin;detcmax];
    % detsbands=[detsbands;detsmin;detsmax];

    %disp('species max and min contribution for the species '); disp(ioptim)
    %disp([normmax(ioptim);normmin(ioptim)])
    % disp('max and min determinant of conc species '); disp(ioptim)
    
    
    pause

end

% hold off
figure

disp('the number of applied constraints have been: ')
disp('norm, known, cneg, sneg, select, unimod, tril, clos1, clos2, total')
disp(nconstr)

subplot(2,1,2),plot(sband(1:2:nsign*2,:)');
hold;
plot(s(ispec,:)',':');
plot(sband(2:2:nsign*2,:)');

subplot(2,1,1),plot(cband(:,1:2:nsign*2));
hold;
plot(c(:,ispec),':');
plot(cband(:,2:2:nsign*2));

disp(' ');disp(' ');
% disp('final evaluation of determinants of band solutions, detcbands and detsbands:')
% disp('by order: initial determinant, outer (max norm) and inner (min norm)determinant for each species optimization')
% disp(lofband)
% disp(detcbands)
% disp(detsbands)

format short e

% [detcbands,detsbands]

disp('termination > 0 (convergence), = 0 (max.number of iterations), < 0 (divergence) :');disp(exitflag)

pause
ij=1;ik=1;il=1;

for i=1:nsign*2,
    disp('mcr and svd t values and corrsponding f optim value for species'),disp(il);
    if mod(i,2)==0, disp('min');il=il+1;else disp('max'), end
    disp(tband(ij:ij+nsign-1,:));disp(tbandsvd(ij:ij+nsign-1,:));disp(fband(ik));
    ij=ij+nsign;ik=ik+1;
end
        
    
%disp('tbands from mcr');disp(tband)

%disp('tbands from svd');disp(tbandsvd)

%disp('optimal balues of the function in the band')
% disp(fband)
