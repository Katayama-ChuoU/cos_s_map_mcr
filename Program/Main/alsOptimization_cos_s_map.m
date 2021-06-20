% alsOptimization_cos_s_map
% in 2 the only first component seems to be optimized, so revise it and
% strict peak outcoming against the initial estimation
% Perfoms the ALS optimization using the constraints defined in the GUI
% steps

%  Parameter & initialization
mcr_als = CalcPara_ALS.Opt.mcr_als;
mcr_als.data = AugData';
nit = CalcPara_ALS.Opt.NumIter;
mcr_als.alsOptions.opt.tolsigma = LOF;
mcr_weight.limit = CalcPara_ALS.Opt.Weight.limit;
mcr_weight.freeline = CalcPara_ALS.Opt.Weight.freeline;
mcr_weight.allowance = CalcPara_ALS.Opt.Weight.allowance;

mcr_als.alsOptions.resultats.optim_niter = evalin('base','nit');
mcr_als.alsOptions.opt.nit = evalin('base','nit');


% x_d = evalin('base','x_d');
% raw_data = evalin('base','y_d');
% inispec(end,:)=[];
rng(1582);%1093
const = CalcPara_ALS.Opt.Weight.FreeWeight ;
inispec(end+1,:) = const * randn(1,size(inispec,2));
mcr_als.alsOptions.iniesta = inispec;

nc = min(size(inispec));
mcr_als.alsOptions.nonegC.cneg = ones(1,nc);
mcr_als.alsOptions.nonegS.spneg = ones(nc,1);
weight = evalin('base','WeightMatrix');
weight(end+1,:) = 1;



%**************************************************************************
% MCR ALS OPTIMIZATION,
%**************************************************************************

% A) DATA PREPARATION AND INPUT

% INITIALIZATIONS

matdad=evalin('base','mcr_als.data');
nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
iniesta=evalin('base','mcr_als.alsOptions.iniesta');
nexp=evalin('base','mcr_als.alsOptions.nexp');
[nrow,ncol]=size(matdad);
[nrow2,ncol2]=size(iniesta);
ils=2; % need to add
if nexp==1
    isp=ones(nsign,1);
else
    matc=evalin('base','mcr_als.alsOptions.multi.matc');
    matr=evalin('base','mcr_als.alsOptions.multi.matr');
    isp=evalin('base','mcr_als.alsOptions.multi.isp');
    nrinic=evalin('base','mcr_als.alsOptions.multi.nrinic');
    nrfin=evalin('base','mcr_als.alsOptions.multi.nrfin');
    nrsol=evalin('base','mcr_als.alsOptions.multi.nrsol');
    ncinic=evalin('base','mcr_als.alsOptions.multi.ncinic');
    ncfin=evalin('base','mcr_als.alsOptions.multi.ncfin');
end

plot_lof=[];
plot_R2=[];
plot_sigmaC=[];
plot_sigmaN=[];
plot_specs=[];
plot_concs=[];
% kinetic constraint
save_kopt=[];
save_sigK=[];
save_ssq=[];
% correlation constraint
save_yout=[];
save_ycal=[];
save_stats=[];


if nrow2==nrow,	nsign=ncol2; ils=1;end
if ncol2==nrow, nsign=nrow2; iniesta=iniesta'; ils=1; end

if ncol2==ncol, nsign=nrow2; ils=2;end
if nrow2==ncol, nsign=ncol2; iniesta=iniesta'; ils=2; end

if ils==1,
    conc=iniesta;
    [nrow,nsign]=size(conc);
    abss=conc\matdad;
end

% this is the initial for Nagai data
if ils==2,
    abss=iniesta;
    [nsign,ncol]=size(abss);
    conc=matdad/abss;
end

if nexp==1,
    ncinic(nexp)=1;
    ncfin(nexp)=ncol;
    nrinic(nexp)=1;
    nrfin(nexp)=nrow;
end

niter=0;% iterations counter
idev=0;% divergence counter
idevmax=10;% maximum number of diverging iterations
answer='n'; % default answer
ineg=0;% used for non-negativity constraints
imod=0;% used for unimodality constraints
iclos0=0;% used for closure constraints
iassim=0;% used for shape constraints
datamod=99;% in three-way type of matrix augmentation (1=row,2=column)
vclos1n=0;% used for closure constraints
vclos2n=0;% used for closure constraints
inorm=0;% no normalizatio (when closurfe is applied)
type_csel=[]; %no equality/lower than constraints in concentrations
type_ssel=[]; %no equality/lower than constraints in spectra

%***************************
% DEFINITION OF THE DATA SET
%***************************

totalconc(1:nsign,1:nexp)=ones(nsign,nexp);

% WHEN ONLY ONE EXPERIMENT IS PRESENT EVERYTHING IS CLEAR

if nexp==1
    nrsol(1)=nrow;
    nrinic(1)=1;
    nrfin(1)=nrsol(1);
    nesp(1)=nsign;
    matr = 1;
    matc = 1;
    isp(1,1:nsign)=ones(1,nsign);
end
ishape=0;

% ***********************************************************
% B) REPRODUCTION OF THE ORIGINAL DATA MATRIX BY PCA
% ***********************************************************

% dn is the experimental matrix and d is the PCA reproduced matrix
d=evalin('base','mcr_als.data');
dn=d;
[u,s,v,d,sd]=pcarep(dn,nsign);

sstn=sum(sum(dn.*dn));
sst=sum(sum(d.*d));
sigma2=sqrt(sstn);

save('temp.mat');
% **************************************************************
% C) STARTING ALTERNATING CONSTRAINED LEAST SQUARES OPTIMIZATION
% **************************************************************

while niter < evalin('base','mcr_als.alsOptions.opt.nit');
    
    niter=niter+1;
    
    % ******************************************
    % D) ESTIMATE CONCENTRATIONS (ALS solutions)
    % ******************************************
    
    conc=d/abss;
    
    % ******************************************
    % CONSTRAIN APPROPRIATELY THE CONCENTRATIONS
    % ******************************************
    
    % ****************
    % non-negativity
    % ****************
    
    if evalin('base','mcr_als.alsOptions.nonegC.noneg')==1;
        ineg=evalin('base','mcr_als.alsOptions.nonegC.noneg');
        if ineg ==1;
            
            ialg=evalin('base','mcr_als.alsOptions.nonegC.ialg');
            ncneg=evalin('base','mcr_als.alsOptions.nonegC.ncneg');
            cneg=evalin('base','mcr_als.alsOptions.nonegC.cneg');
            
            for i=1:matc
                kinic=nrinic(i);
                kfin=nrfin(i);
                conc2=conc(kinic:kfin,:);
                
                if ialg==0
                    for k=1:nsign,
                        if cneg(i,k) ==1
                            for j=1:kfin+1-kinic,
                                if conc2(j,k)<0.0,
                                    conc2(j,k)=0.0;
                                end
                            end
                        end
                    end
                end
                
                if ialg==1
                    for j=kinic:kfin
                        if cneg(i,:) == ones(1,size(isp,2))
                            x=lsqnonneg(abss',d(j,:)');
                            conc2(j-kinic+1,:)=x';
                        end
                    end
                end
                
                if ialg==2
                    for j=kinic:kfin
                        if cneg(i,:) == ones(1,size(isp,2))
                            x=fnnls(abss*abss',abss*d(j,:)');
                            conc2(j-kinic+1,:)=x';
                        end
                    end
                end
                
                conc(kinic:kfin,:) = conc2;
            end
        end
    end
    
    % ************
    % trilinear models
    % ************
    
    if evalin('base','mcr_als.alsOptions.trilin.appTril')==1
        
        ishape=evalin('base','mcr_als.alsOptions.trilin.ishape');
        
        if ishape>0 & ishape < 4
            
            trildir=evalin('base','mcr_als.alsOptions.trilin.trildir');
            spetric=evalin('base','mcr_als.alsOptions.trilin.spetric');
            iquadril=evalin('base','mcr_als.alsOptions.trilin.iquadril');
            ne=evalin('base','mcr_als.alsOptions.trilin.ne');
            %             spetris=evalin('base','mcr_als.alsOptions.trilin.spetris');
            
            if trildir==1|trildir==3 % now, only trildir=1
                for j=1:nsign,
                    if spetric(j)==1,
                        if iquadril==0
                            [conc(:,j),t]=trilin(conc(:,j),matc,ishape);
                            totalconc(j,1:matc)=t;
                            if totalconc(j,1)>0,
                                rt(j,1:matc)=totalconc(j,1:matc)./totalconc(j,1);
                            else
                                rt(j,1:matc)=totalconc(j,1:matc);
                            end
                        end
                        if iquadril==1
                            [conc(:,j),u1,u2,u3]=quadril(conc(:,j),ne(1),ne(2),ne(3),ishape);
                        end
                        
                    end
                end
            end
            
            
        end
    end
    
    
    % *****************
    % INTERACTION MODELS
    % *****************
    
    if evalin('base','mcr_als.alsOptions.trilin.appTril')==1
        
        ishape=evalin('base','mcr_als.alsOptions.trilin.ishape');
        
        if ishape == 4
            concold=conc;
            trildir=evalin('base','mcr_als.alsOptions.trilin.trildir');
            
            if trildir==1
                nway=evalin('base','mcr_als.alsOptions.trilin.nway');
                for ituck=1:nway,
                    
                    nsign=evalin('base','mcr_als.CompNumb.nc');
                    modeltuckc=evalin('base','mcr_als.alsOptions.trilin.modeltuckc');
                    spetuckc=evalin('base','mcr_als.alsOptions.trilin.spetuckc');
                    
                    if modeltuckc(1,ituck) < nsign
                        % disp('for mode'),ituck
                        for j=1:nsign,
                            jcommon=find(spetuckc(ituck,:)==j);
                            if length(jcommon)>1
                                % disp('interacting componnets'),jcommon
                                conctuck=conc(:,jcommon);
                                [conctuck,t]=tuck2(conctuck,matc,ishape,ituck);
                                conc(:,jcommon)=conctuck;
                            elseif length(jcommon)==1
                                % disp('non-interanting component'),jcommon
                                conctuck=conc(:,jcommon);
                                [conctuck,t]=tuck2(conctuck,matc,ishape,ituck);
                                conc(:,jcommon)=conctuck;
                            end
                        end
                        % disp('new profiles svd')
                        % svd(conc)
                        %                         figure('name','tucker model'),plot(conc);hold;figure(2),plot(concold,'--'),hold;
                        % pause
                        
                    end
                end
            end
            
        end
    end
    % **************************
    % zero concentration species
    % **************************
    
    if matc>1
        for i=1:matc,
            for j=1:nsign,
                if isp(i,j)==0,
                    conc(nrinic(i):nrfin(i),j)=zeros(nrsol(i),1);
                end
            end
        end
    end
    
    
    % ***********
    % unimodality
    % ***********
    
    if evalin('base','mcr_als.alsOptions.unimodC.unimodal')==1
        
        for i = 1:matc
            
            kinic=nrinic(i);
            kfin=nrfin(i);
            conc2=conc(kinic:kfin,:);
            imod=evalin('base','mcr_als.alsOptions.unimodC.unimodal');
            
            if imod==1|imod==3,
                
                spmod=evalin('base','mcr_als.alsOptions.unimodC.spmod');
                cmod=evalin('base','mcr_als.alsOptions.unimodC.cmod');
                rmod=evalin('base','mcr_als.alsOptions.unimodC.rmod');
                
                for ii=1:nsign,
                    if spmod(i,ii)==1,
                        conc2(:,ii)=unimod(conc2(:,ii),rmod,cmod);
                    end
                end
                
            end
            
            conc(kinic:kfin,:)=conc2;
        end
    end
    
    
    % ********
    % closure
    % ********
    
    if evalin('base','mcr_als.alsOptions.closure.closure')==1;
        
        dc=evalin('base','mcr_als.alsOptions.closure.dc');
        vc=evalin('base','mcr_als.alsOptions.closure.vc');
        iclos=evalin('base','mcr_als.alsOptions.closure.iclos');
        tclos1(1:matc)=zeros(1,matc);
        tclos2(1:matc)=zeros(1,matc);
        sclos1(1:matc,1:nsign)=zeros(matc,nsign);
        sclos2(1:matc,1:nsign)=zeros(matc,nsign);
        iclos1(1:matc)=zeros(1,matc);
        iclos2(1:matc)=zeros(1,matc);
        vclos1=0;
        vclos2=0;
        
        if iclos==1
            
            iclos1=evalin('base','mcr_als.alsOptions.closure.iclos1');
            sclos1=evalin('base','mcr_als.alsOptions.closure.sclos1');
            
            if vc==0
                tclos1=evalin('base','mcr_als.alsOptions.closure.tclos1');
            else
                vclos1=evalin('base','mcr_als.alsOptions.closure.vclos1');
            end
            
        elseif iclos==2
            
            iclos1=evalin('base','mcr_als.alsOptions.closure.iclos1');
            iclos2=evalin('base','mcr_als.alsOptions.closure.iclos2');
            sclos1=evalin('base','mcr_als.alsOptions.closure.sclos1');
            sclos2=aevalin('base','mcr_als.alsOptions.closure.sclos2');
            
            if vc==0
                tclos1=evalin('base','mcr_als.alsOptions.closure.tclos1');
                tclos2=evalin('base','mcr_als.alsOptions.closure.tclos2');
            else
                vclos1=evalin('base','mcr_als.alsOptions.closure.vclos1');
                vclos2=evalin('base','mcr_als.alsOptions.closure.vclos2');
            end
            
        end
        
        
        if dc == 1
            for i = 1:matc
                kinic=nrinic(i);
                kfin=nrfin(i);
                conc2=conc(kinic:kfin,:);
                
                if iclos(i)==1 | iclos(i)==2,
                    if tclos1(i) == 0
                        vclos1n=vclos1(kinic:kfin,1);
                    end
                    
                    if iclos(i) ==2 & tclos2(i)==0
                        vclos2n=vclos2(kinic:kfin,1);
                    end
                    
                    [conc2]=closure(conc2,iclos(i),sclos1(i,:),iclos1(i),tclos1(i),tclos2(i),sclos2(i,:),iclos2(i),vclos1n,vclos2n);
                end
                conc(kinic:kfin,:)=conc2;
            end
        end
    end
    
    % *************************************
    % EQUALITY CONSTRAINTS IN CONC PROFILES
    % *************************************
    
    if evalin('base','mcr_als.alsOptions.cselcC.cselcon')==1
        
        csel=evalin('base','mcr_als.alsOptions.cselcC.csel');
        type_csel=evalin('base','mcr_als.alsOptions.cselcC.type_csel');
        iisel=evalin('base','mcr_als.alsOptions.cselcC.iisel');
        
        if type_csel==0,
            conc(iisel)=csel(iisel);
        end
        
        if type_csel==1
            for ii=1:size(iisel),
                if conc(iisel(ii))>csel(iisel(ii)),
                    conc(iisel(ii))=csel(iisel(ii));
                end
            end
        end
        
    end
    
    
    % *************************************
    % CORRELATION
    % *************************************
    
    if evalin('base','mcr_als.alsOptions.correlation.appCorrelation')==1
        
        % iisel
        iisel=evalin('base','mcr_als.alsOptions.correlation.iisel');
        % compreg
        compreg=evalin('base','mcr_als.alsOptions.correlation.compreg');
        % csel
        csel=evalin('base','mcr_als.alsOptions.correlation.csel_variable');
        % regmodel
        regmodel=evalin('base','mcr_als.alsOptions.correlation.regmodel');
        % mateffect
        mateffect=evalin('base','mcr_als.alsOptions.correlation.mateffect');
        
        if nexp==1
            [yout,ycal,stats]=yregrnew(conc,csel,compreg);
            conc=yout;
            conc(iisel)=csel(iisel);
        end
        if nexp>1
            if regmodel==0
                [yout,ycal,stats]=yregrnew(conc,csel,compreg);
                conc=yout;
                conc(iisel)=csel(iisel);
            end
            if regmodel==1 & mateffect==0
                ycal=[];
                stats=[];
                for i=1:matc
                    kinic=nrinic(i);
                    kfin=nrfin(i);
                    conc2=conc(kinic:kfin,:);
                    csel2=csel(kinic:kfin,:);
                    [yout,ycalind,statind]=yregrnew(conc2,csel2,compreg);
                    conc(kinic:kfin,:)=yout;
                    ycal=[ycal;ycalind];
                    stats=[stats;statind];
                end
                conc(iisel)=csel(iisel);
            end
            if regmodel==1 & mateffect==1
                ycal=[];
                stats=[];
                for i=1:matc
                    kinic=nrinic(i);
                    kfin=nrfin(i);
                    conc2=conc(kinic:kfin,:);
                    csel2=csel(kinic:kfin,:);
                    [yout,ycalind,statind]=yregrnew(conc2,csel2,compreg);
                    ycal=[ycal;ycalind];
                    stats=[stats;statind];
                end
                %Rescaling ALS concentrations according to matrix
                %effect (1st matrix taken as reference).
                for i=2:matc
                    for j=1:nsign
                        if ~isempty(stats{i,j})
                            conc(kinic:kfin,j)=((yout(:,j)*stats{i,j}.slope+stats{i,j}.offset)-stats{1,j}.offset)/stats{1,j}.slope;
                        else
                            conc(kinic:kfin,j)=yout(:,j);
                        end
                    end
                end
                zerosel=find(csel==0);
                conc(zerosel)=0;
            end
            
        end
    end
    
    
    % **********************
    % KINETIC MODEL
    % **********************
    
    if evalin('base','mcr_als.alsOptions.kinetic.appKinetic')==1
        
        nexp=evalin('base','mcr_als.alsOptions.nexp;')';
        % single matrix
        
        if nexp==1
            
            nmodel=evalin('base','mcr_als.alsOptions.kinetic.nModels;')';;
            
            for i=1:nmodel
                expkin=1; % 1 experiment in the model
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.model.model.N;'];
                modelN=transpose(evalin('base',expressionX));
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.model.model.R;'];
                modelR=evalin('base',expressionX);
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.constants.ki;'];
                Constants=evalin('base',expressionX);
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.concMCR.corrMCR;'];
                kclos=(evalin('base',expressionX))';
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.concs.col;'];
                Ccol=evalin('base',expressionX);
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.concs.ci;'];
                Cinicials=evalin('base',expressionX);
                
                time=cell(length(expkin),1);
                conckin=cell(length(expkin),1);
                xaxis1=evalin('base','mcr_als.alsOptions.kinetic.time_axis;');
                
                for j=1:length(expkin)
                    timein=nrinic(expkin(j));
                    timefin=nrfin(expkin(j));
                    time{j,1}=xaxis1(timein:timefin);
                    conc2=conc(timein:timefin,:);
                    
                    conckinunsorted=conc2(:,find(kclos~=0));
                    %                     conckinunsorted=conc2(:,kclos(find(kclos~=0))); % modified
                    modelorder=kclos(find(kclos~=0));
                    conckin{j,1}=conckinunsorted(:,modelorder);
                    conckin{j,1}=interesp(conckin{j,1},Ccol);
                end
                if niter ==1
                    [ktemp,concktemp,ssq_nglm,J_nglm] = opt_kinglob(conckin,modelN,modelR,Cinicials,Constants',time,kclos,Ccol);
                    eval((['J_nglm',num2str(i) ' = J_nglm;']));
                    eval((['ssq_nglm',num2str(i) ' = ssq_nglm;']));
                    eval((['conck',num2str(i) ' = concktemp;']));
                    eval((['kfin',num2str(i) ' = ktemp;']));
                else
                    [ktemp,concktemp,ssq_nglm,J_nglm] = opt_kinglob(conckin,modelN,modelR,Cinicials,kout{i,1},time,kclos,Ccol);
                    eval((['J_nglm',num2str(i) ' = J_nglm;']));
                    eval((['ssq_nglm',num2str(i) ' = ssq_nglm;']));
                    eval((['conck',num2str(i) ' = concktemp;']));
                    eval((['kfin',num2str(i) ' = ktemp;']));
                end
                
                disp(ktemp);
                
                figure(3)
                for k=1:length(expkin)
                    plot(time{k,1},concktemp{k,1},'.',time{k,1},conckin{k,1},'-')
                    pause(1)
                end
                
                [rowconckout,colconckout]=size(concktemp);
                [rowconckin,colconckin]=size(conc2);
                
                kout{i,1}=ktemp;
                
                % For each data matrix (one loop similar to the one done for building time and
                % conckin)
                
                for j=1:length(expkin)
                    timein=nrinic(expkin(j));
                    timefin=nrfin(expkin(j));
                    conckout{expkin(j),1}=concktemp{j,1};
                    ckallspecies=concktemp{j,1};
                    conckfin=ckallspecies(:,logical(Ccol));
                    modelorder=kclos(find(kclos~=0));
                    conc(timein:timefin,find(kclos~=0))=conckfin(:,modelorder);
                end
                conckoutx{i,1}=eval(['conckout']);
                assignin('base','conckxout',conckoutx);
                evalin('base','mcr_als.alsOptions.kinetic.results.conckout=conckxout;');
                evalin('base','clear conckxout');
                
                ssqx{i,1}=eval(['ssq_nglm',num2str(i)]);
                assignin('base','ssqx',ssqx);
                evalin('base','mcr_als.alsOptions.kinetic.results.ssq=ssqx;');
                evalin('base','clear ssqx');
                
                dfconc=0;
                copt=conckout{1};
                
                for k=1:length(nexp)
                    prodconc=prod(size(copt(nrinic(nexp(k)):nrfin(nexp(k)),:)));
                    dfconc=dfconc+prodconc;
                end
                df=dfconc-length(kout{i,1});
                eval(['sig_ynglm',num2str(i),' = sqrt([ssq_nglm',num2str(i),'/df]);']);
                eval(['sig_knglm{',num2str(i),',1} = sig_ynglm',num2str(i),'*sqrt(diag(inv([(J_nglm',num2str(i),')''*J_nglm',num2str(i),'])));']);
                
                assignin('base','kxout',kout);
                evalin('base','mcr_als.alsOptions.kinetic.results.kopt=kxout;');
                evalin('base','clear kxout');
                
                % sigy is needed
                
                assignin('base','sig_knglm',sig_knglm);
                evalin('base','mcr_als.alsOptions.kinetic.results.sig_knglm=sig_knglm;');
                evalin('base','clear sig_knglm');
                
                %***********************************
                
            end
            
            % multiple matrices
        else
            
            nmodel=evalin('base','mcr_als.alsOptions.kinetic.nModels;')';;
            
            for i=1:nmodel
                %expkin=1; % 1 experiment al model  /  /   *   /  /
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.expFitted;'];
                expFitted=evalin('base',expressionX);
                expkin=find(expFitted);
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.model.model.N;'];
                modelN=transpose(evalin('base',expressionX));
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.model.model.R;'];
                modelR=evalin('base',expressionX);
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.constants.ki;'];
                Constants=evalin('base',expressionX);
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.concMCR.corrMCR;'];
                kclos=(evalin('base',expressionX))';
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.concs.col;'];
                Ccol=evalin('base',expressionX);
                
                expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(i),'.concs.ci;'];
                Cinicials=evalin('base',expressionX);
                
                time=cell(length(expkin),1);
                conckin=cell(length(expkin),1);
                xaxis1=evalin('base','mcr_als.alsOptions.kinetic.time_axis;');
                
                for j=1:length(expkin)
                    timein=nrinic(expkin(j));
                    timefin=nrfin(expkin(j));
                    time{j,1}=xaxis1(timein:timefin);
                    conc2=conc(timein:timefin,:);
                    conckinunsorted=conc2(:,find(kclos~=0));
                    modelorder=kclos(find(kclos~=0));
                    conckin{j,1}=conckinunsorted(:,modelorder);
                    conckin{j,1}=interesp(conckin{j,1},Ccol);
                end
                
                if niter ==1
                    [ktemp,concktemp,ssq_nglm,J_nglm] = opt_kinglob(conckin,modelN,modelR,Cinicials,Constants,time,kclos,Ccol);
                    eval((['J_nglm',num2str(i) ' = J_nglm;']));
                    eval((['ssq_nglm',num2str(i) ' = ssq_nglm;']));
                    eval((['conck',num2str(i) ' = concktemp;']));
                    eval((['kfin',num2str(i) ' = ktemp;']));
                else
                    [ktemp,concktemp,ssq_nglm,J_nglm] = opt_kinglob(conckin,modelN,modelR,Cinicials,kout{i,1},time,kclos,Ccol);
                    eval((['J_nglm',num2str(i) ' = J_nglm;']));
                    eval((['ssq_nglm',num2str(i) ' = ssq_nglm;']));
                    eval((['conck',num2str(i) ' = concktemp;']));
                    eval((['kfin',num2str(i) ' = ktemp;']));
                end
                
                disp(ktemp);
                
                figure(3)
                for k=1:length(expkin)
                    plot(time{k,1},concktemp{k,1},'.',time{k,1},conckin{k,1},'-')
                    pause(1)
                end
                
                [rowconckout,colconckout]=size(concktemp);
                [rowconckin,colconckin]=size(conc2);
                
                kout{i,1}=ktemp;
                
                % For each data matrix (one loop similar to the one done for building time and
                % conckin)
                
                for j=1:length(expkin)
                    timein=nrinic(expkin(j));
                    timefin=nrfin(expkin(j));
                    conckout{expkin(j),1}=concktemp{j,1};
                    ckallspecies=concktemp{j,1};
                    conckfin=ckallspecies(:,logical(Ccol));
                    modelorder=kclos(find(kclos~=0));
                    conc(timein:timefin,find(kclos~=0))=conckfin(:,modelorder);
                end
                
                conckoutx{i,1}=eval(['conckout']);
                conckoutx{i,1}=eval(['conckout']);
                assignin('base','conckxout',conckoutx);
                evalin('base','mcr_als.alsOptions.kinetic.results.conckout=conckxout;');
                evalin('base','clear conckxout');
                
                ssqx{i,1}=eval(['ssq_nglm',num2str(i)]);
                assignin('base','ssqx',ssqx);
                evalin('base','mcr_als.alsOptions.kinetic.results.ssq=ssqx;');
                evalin('base','clear ssqx');
                
                dfconc=0;
                
                copt=[];
                for m=1:length(expkin)
                    copt0=conckout{m};
                    copt=[copt;copt0];
                end
                
                for k=1:length(expkin)
                    prodconc=prod(size(copt(nrinic(expkin(k)):nrfin(expkin(k)),:)));
                    dfconc=dfconc+prodconc;
                end
                df=dfconc-length(kout{i,1});
                eval(['sig_ynglm',num2str(i),' = sqrt([ssq_nglm',num2str(i),'/df]);']);
                eval(['sig_knglm{',num2str(i),',1} = sig_ynglm',num2str(i),'*sqrt(diag(inv([(J_nglm',num2str(i),')''*J_nglm',num2str(i),'])));']);
                
                assignin('base','kxout',kout);
                evalin('base','mcr_als.alsOptions.kinetic.results.kopt=kxout;');
                evalin('base','clear kxout');
                
                % sigy is needed
                
                assignin('base','sig_knglm',sig_knglm);
                evalin('base','mcr_als.alsOptions.kinetic.results.sig_knglm=sig_knglm;');
                evalin('base','clear sig_knglm');
                
            end
            
        end
        
    end
    
    
    % ************************************************
    % QUANTITATIVE INFORMATION FOR THREE-WAY DATA SETS
    % ************************************************
    
    if evalin('base','mcr_als.alsOptions.trilin.appTril')==1
        ishape=evalin('base','mcr_als.alsOptions.trilin.ishape');
    else
        ishape=0;
    end
    
    if ishape==0 | niter==1,
        for j=1:nsign,
            for inexp=1:matc,
                totalconc(j,inexp)=sum(conc(nrinic(inexp):nrfin(inexp),j));
            end
            if totalconc(j,1)>0,
                rt(j,1:matc)=totalconc(j,1:matc)./totalconc(j,1);
            else
                rt(j,1:matc)=totalconc(j,1:matc);
            end
        end
    end
    
    % areas under concentration profiles
    area=totalconc;
    
    % ********************************
    % ESTIMATE SPECTRA (ALS solution)
    % ********************************
    
    abss=conc\d;
    
    
    % ********************
    % non-negative spectra
    % ********************
    
    ineg=evalin('base','mcr_als.alsOptions.nonegS.noneg');
    if ineg==1,
        
        ialgs=evalin('base','mcr_als.alsOptions.nonegS.ialgs');
        nspneg=evalin('base','mcr_als.alsOptions.nonegS.nspneg');
        spneg=evalin('base','mcr_als.alsOptions.nonegS.spneg');
        if matr>1
            ncinic=evalin('base','mcr_als.alsOptions.multi.ncinic');
            ncfin=evalin('base','mcr_als.alsOptions.multi.ncfin');
        end
        
        for i = 1:matr
            kinic = ncinic(i);
            kfin = ncfin(i);
            abss2 = abss(:,kinic:kfin);
            
            if ialgs==0,
                for k=1:nsign,
                    if spneg(k,i)==1
                        for j=1:kfin+1-kinic,
                            if abss2(k,j)<0.0,
                                abss2(k,j)=0.0;
                            end
                        end
                    end
                end
            end
            
            if ialgs==1,
                for j=kinic:kfin,
                    if spneg(:,i)== ones(size(isp,2),1)
                        abss2(:,j-kinic+1)=lsqnonneg(conc,d(:,j));
                    end
                end
            end
            
            if ialgs==2,
                for j=kinic:kfin,
                    if spneg(:,i)== ones(size(isp,2),1)
                        abss2(:,j-kinic+1)=fnnls(conc'*conc,conc'*d(:,j));
                    end
                end
            end
            abss(:,kinic:kfin)=abss2;
        end
    end
    
    %%%%%%%%%%%%%
    %Weight constratints 
    
    if isempty(evalin('base','CalcPara_ALS.Opt.Weight'))==0
        abss_original = iniesta;
        
        if idev > NumIterDivergence
            clear
            idstrgrest='on';
            load('temp.mat')
            continue
        end
        
        if exist('idstrgrest')==1
            
            freeline = mcr_weight.freeline;
            allowance = mcr_weight.allowance;
            size_abss = size(abss);
            if mcr_weight.limit == "on"
                
                abss =weight.*abss;
                area=sum(abss,2);
                area_ini=sum(inispec,2);
                
                if any(area < Area_Constraints(1) * area_ini) || any(area > Area_Constraints(2) * area_ini)
                    Locs_A=find(area < Area_Constraints(1) * area_ini | area > Area_Constraints(2) * area_ini );
                    abss(Locs_A,:)=inispec(Locs_A,:);
                end
            end
            
        else
            abss=weight.*abss;
            
        end
        
    end
    
    
    
    
    % ************
    % trilinearity
    % ************
    
    if evalin('base','mcr_als.alsOptions.trilin.appTril')==1
        
        ishape=evalin('base','mcr_als.alsOptions.trilin.ishape');
        
        if ishape>=1,
            
            trildir=evalin('base','mcr_als.alsOptions.trilin.trildir');
            spetric=evalin('base','mcr_als.alsOptions.trilin.spetric');
            %             spetris=evalin('base','mcr_als.alsOptions.trilin.spetris');
            
            if trildir==2|trildir==3
                for j=1:nsign,
                    if spetris(j)==1,
                        [absst,t]=trilin(abss(j,:)',matr,ishape);
                        abss(j,:)=absst';
                    end
                end
            end
        end
        
    end
    
    % ************************************
    % constrain the unimodality of spectra
    % ************************************
    
    if evalin('base','mcr_als.alsOptions.unimodS.unimodal')==1
        
        imod=evalin('base','mcr_als.alsOptions.unimodS.unimodal');
        
        
        for i = 1:matr
            kinic = ncinic(i);
            kfin = ncfin(i);
            abss2 = abss(:,kinic:kfin);
            
            if imod==2|imod==3,
                spsmod=evalin('base','mcr_als.alsOptions.unimodS.spsmod');
                cmod=evalin('base','mcr_als.alsOptions.unimodS.cmod');
                smod=evalin('base','mcr_als.alsOptions.unimodS.smod');
                
                
                for j=1:nsign,
                    if spsmod(i,j)==1
                        dummy=unimod(abss2(j,:)',smod,cmod);
                        abss2(j,:)=dummy';
                    end
                end
            end
            abss(:,kinic:kfin)=abss2;
        end
        
    end
    
    % ********************************
    % EQUALITY CONSTRAINTS FOR SPECTRA
    % **************************
    
    
    if evalin('base','mcr_als.alsOptions.sselcS.sselcon')==1
        
        ssel=evalin('base','mcr_als.alsOptions.sselcS.ssel');
        type_ssel=evalin('base','mcr_als.alsOptions.sselcS.type_ssel');
        jjsel=evalin('base','mcr_als.alsOptions.sselcS.jjsel');
        
        if type_ssel==0,
            abss(jjsel)=ssel(jjsel);
        end
        
        if type_ssel==1
            for jj=1:size(jjsel),
                if abss(jjsel(jj))>ssel(jjsel(jj)),
                    abss(jjsel(jj))=ssel(jjsel(jj));
                end
            end
        end
        
    end
    
    % *******************************************************
    % closure in spectra (in case of inverted analysis D'=SC)
    % *******************************************************
    
    if evalin('base','mcr_als.alsOptions.closure.closure')==1;
        
        dc=evalin('base','mcr_als.alsOptions.closure.dc');
        vc=evalin('base','mcr_als.alsOptions.closure.vc');
        iclos=evalin('base','mcr_als.alsOptions.closure.iclos');
        tclos1(1:matc)=zeros(1,matc);
        tclos2(1:matc)=zeros(1,matc);
        sclos1(1:matc,1:nsign)=zeros(matc,nsign);
        sclos2(1:matc,1:nsign)=zeros(matc,nsign);
        iclos1(1:matc)=zeros(1,matc);
        iclos2(1:matc)=zeros(1,matc);
        
        if dc==2
            
            for i = 1:matr
                kinic = ncinic(i);
                kfin = ncfin(i);
                abss2 = abss(:,kinic:kfin);
                
                if iclos(i)==1 | iclos(i)==2,
                    if tclos1(i) == 0
                        vclos1n=vclos1(kinic:kfin,1);
                    end
                    
                    if iclos(i) ==2 & tclos2(i)==0
                        vclos2n=vclos2(kinic:kfin,1);
                    end
                    
                    abst = closure(abss2',iclos(i),sclos1(i,:),iclos1(i),tclos1(i),tclos2(i),sclos2(i,:),iclos2(i),vclos1n,vclos2n);
                    abss2=abst';
                end
                abss(:,kinic:kfin) = abss2;
            end
        end
        
    end
    
    % ************************
    % NORMALIZATION OF SPECTRA
    % ************************
    
    
    if evalin('base','mcr_als.alsOptions.closure.closure')==0
        
        % equal height
        if evalin('base','mcr_als.alsOptions.correlation.checkSNorm')==0;
            inorm=evalin('base','mcr_als.alsOptions.closure.inorm');
            
            if inorm==1;
                maxabss=max(abss');
                for i=1:nsign,
                    abss(i,:)=abss(i,:)./maxabss(i);
                end
            end
            
            % equal length - divided by Frobenius Norm
            
            if inorm==2, abss=normv2(abss); end
            
            % equal length - divided by Total Sum Norm
            
            if inorm==3, abss=normv3(abss); end
            
            % in case of application of a correlation constraint,
            % spectra of non-correlated components can go out of scale
            % and produce rank deficiency situations
            % They should be in the same scale as the one with the correlation constraint
        elseif evalin('base','mcr_als.alsOptions.correlation.checkSNorm')==1;
            for i=1:nsign,
                if compreg(i)==1,
                    maxabss=max(abss(i,:)');
                    imax=i;
                end
            end
            for i=1:nsign,
                % if compreg(i)==0 | i~=imax,
                if compreg(i)==0,
                    scaleabss=maxabss/max(abss(i,:)');
                    abss(i,:)=abss(i,:).*scaleabss;
                end
            end
            
        end
        
        
    end
    
    
    
    % *******************************
    % CALCULATE RESIDUALS
    % *******************************
    
    res=d-conc*abss;
    resn=dn-conc*abss;
    
    % ********************************
    % OPTIMIZATION RESULTS
    % *********************************
    
    disp(' ' );disp(' ');disp(['ITERATION ',num2str(niter)]);
    u=sum(sum(res.*res));
    un=sum(sum(resn.*resn));
    disp(['Sum of squares respect PCA reprod. = ', num2str(u)]);
    sigma=sqrt(u/(nrow*ncol));
    sigman=sqrt(un/(nrow*ncol));
    disp(['Old sigma = ', num2str(sigma2),' -----> New sigma = ', num2str(sigma)]);
    disp(['Sigma respect experimental data = ', num2str(sigman)]);
    disp(' ');
    change=((sigma2-sigma)/sigma);
    
    if change < 0.0,
        disp(' ')
        disp('FITING IS NOT IMPROVING !!!')
        idev=idev+1;
    else,
        disp('FITING IS IMPROVING !!!')
        idev=0;
    end
    
    change=change*100;
    disp(['Change in sigma (%) = ', num2str(change)]);
    sstd(1)=sqrt(u/sst)*100;
    sstd(2)=sqrt(un/sstn)*100;
    disp(['Fitting error (lack of fit, lof) in % (PCA) = ', num2str(sstd(1))]);
    disp(['Fitting error (lack of fit, lof) in % (exp) = ', num2str(sstd(2))]);
    r2=(sstn-un)/sstn;
    disp(['Percent of variance explained (r2) is ',num2str(100*r2)]);
    
    % save parameters
    % ******************************************** used for plotting
    % optimization information
    % *****************************************************************
    
    plot_lof=[plot_lof;sstd(2)];
    plot_sigmaC=[plot_sigmaC;change];
    plot_sigmaN=[plot_sigmaN;sigman];
    plot_R2=[plot_R2;100*r2];
    plot_specs=[plot_specs;abss];
    plot_concs=[plot_concs conc];
    
    assignin('base','plot_lof',plot_lof);
    assignin('base','plot_R2',plot_R2);
    assignin('base','plot_sigmaC',plot_sigmaC);
    assignin('base','plot_sigmaN',plot_sigmaN);
    assignin('base','total_niter',niter);
    assignin('base','plot_specs',plot_specs);
    assignin('base','plot_concs',plot_concs);
    
    evalin('base','mcr_als.alsOptions.resultats.plot_lof=plot_lof;');
    evalin('base','mcr_als.alsOptions.resultats.plot_R2=plot_R2;');
    evalin('base','mcr_als.alsOptions.resultats.plot_sigmaC=plot_sigmaC;');
    evalin('base','mcr_als.alsOptions.resultats.plot_sigmaN=plot_sigmaN;');
    evalin('base','mcr_als.alsOptions.resultats.total_niter=total_niter;');
    evalin('base','mcr_als.alsOptions.resultats.plot_specs=plot_specs;');
    evalin('base','mcr_als.alsOptions.resultats.plot_concs=plot_concs;');
    
    %     evalin('base','clear plot_lof plot_R2 total_niter plot_specs plot_concs plot_sigmaC plot_sigmaN');
    
    appCinetic=evalin('base','mcr_als.alsOptions.kinetic.appKinetic');
    if appCinetic==1;
        
        kiter=evalin('base','mcr_als.alsOptions.kinetic.results.kopt;');
        sigKiter=evalin('base','mcr_als.alsOptions.kinetic.results.sig_knglm;');
        ssqx=evalin('base','mcr_als.alsOptions.kinetic.results.ssq;');
        
        save_ssq=[save_ssq;ssqx];
        save_kopt=[save_kopt;kiter];
        save_sigK=[save_sigK;sigKiter];
        
        assignin('base','save_kopt',save_kopt);
        assignin('base','save_sigK',save_sigK);
        assignin('base','save_ssq',save_ssq);
        
        evalin('base','mcr_als.alsOptions.kinetic.results.save_kopt=save_kopt;');
        evalin('base','mcr_als.alsOptions.kinetic.results.save_sigK=save_sigK;');
        evalin('base','mcr_als.alsOptions.kinetic.results.save_ssq=save_ssq;');
        
        evalin('base','clear save_kopt save_sigK save_ssq');
        
    end
    
    appCorrel=evalin('base','mcr_als.alsOptions.correlation.appCorrelation;');
    if appCorrel==1;
        
        % yout,ycal, stats available
        
        save_yout=[save_yout;yout];
        save_ycal=[save_ycal;ycal];
        save_stats=[save_stats;stats];
        
        assignin('base','save_yout',save_yout);
        assignin('base','save_ycal',save_ycal);
        assignin('base','save_stats',save_stats);
        
        evalin('base','mcr_als.alsOptions.correlation.results.save_yout=save_yout;');
        evalin('base','mcr_als.alsOptions.correlation.results.save_ycal=save_ycal;');
        evalin('base','mcr_als.alsOptions.correlation.results.save_stats=save_stats;');
        
        evalin('base','clear save_yout save_ycal save_stats');
        
        
    end
    
    
    % ********************
    % DISPLAY PURE SPECTRA
    % ********************
    
    if  evalin('base','mcr_als.alsOptions.opt.gr')=='y',
        
        als_end=0;
        
        assignin('base','cx_plot',conc);
        assignin('base','sx_plot',abss);
        assignin('base','niter_plot',niter);
        assignin('base','change_plot',change);
        assignin('base','sstd_plot',sstd);
        assignin('base','als_end',als_end);
        als_res;
        
        evalin('base','clear cx_plot sx_plot niter_plot change_plot sstd_plot als_end');
    end
    
    
    % *************************************************************
    % If change is positive, the optimization is working correctly
    % *************************************************************
    
    if change>0 | niter==1,
        
        sigma2=sigma;
        copt=conc;
        sopt=abss;
        sdopt=sstd;
        ropt=res;
        rtopt=rt';
        itopt=niter;
        areaopt=area;
        r2opt=r2;
    end
    
    % ******************************************************************
    % test for convergence within maximum number of iterations allowed
    % ******************************************************************
    
    if abs(change) < evalin('base','mcr_als.alsOptions.opt.tolsigma'),
        
        %  finish the iterative optimization because convergence is achieved
        
        disp(' ');disp(' ');
        disp('CONVERGENCE IS ACHIEVED !!!!')
        disp(' ')
        disp(['Fitting error (lack of fit, lof) in % at the optimum = ', num2str(sdopt(1,1)),'(PCA) ', num2str(sdopt(1,2)), '(exp)']);
        disp(['Percent of variance explained (r2)at the optimum is ',num2str(100*r2opt)]);
        disp('Relative species conc. areas respect matrix (sample) 1at the optimum'),disp(rtopt')
        disp(['Plots are at optimum in the iteration ', num2str(itopt)]);
        
        
        if isempty(evalin('base','mcr_als.alsOptions.out.out_conc'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_conc'),copt)
        end
        if isempty(evalin('base','mcr_als.alsOptions.out.out_spec'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_spec'),sopt)
        end
        if isempty(evalin('base','mcr_als.alsOptions.out.out_res'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_res'),ropt)
        end
        if isempty(evalin('base','mcr_als.alsOptions.out.out_std'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_std'),sdopt)
        end
        if isempty(evalin('base','mcr_als.alsOptions.out.out_area'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_area'),areaopt)
        end
        if isempty(evalin('base','mcr_als.alsOptions.out.out_rat'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_rat'),rtopt)
        end
        
        % save parameters
        assignin('base','plot_optim_lof',sdopt(1,2));
        assignin('base','plot_optim_R2',100*r2opt);
        assignin('base','optim_niter',itopt);
        assignin('base','optim_concs',copt);
        assignin('base','optim_specs',sopt);
        
        
        evalin('base','mcr_als.alsOptions.resultats.plot_optim_lof=plot_optim_lof;');
        evalin('base','mcr_als.alsOptions.resultats.plot_optim_R2=plot_optim_R2;');
        evalin('base','mcr_als.alsOptions.resultats.optim_niter=optim_niter;');
        evalin('base','mcr_als.alsOptions.resultats.optim_concs=optim_concs;');
        evalin('base','mcr_als.alsOptions.resultats.optim_specs=optim_specs;');
        
        evalin('base','clear plot_optim_lof plot_optim_R2 optim_niter optim_concs optim_specs');
        
        
        als_end=1;
        assignin('base','als_end',als_end);
        assignin('base','copt_xxx',copt);
        assignin('base','sopt_xxx',sopt);
        assignin('base','sdopt_xxx',sdopt);
        assignin('base','r2opt_xxx',r2opt);
        assignin('base','rtopt_xxx',rtopt);
        assignin('base','itopt_xxx',itopt);
        assignin('base','change_xxx',sigman); % for std dev res vs exp
        als_res;
        evalin('base','clear als_end copt_xxx sopt_xxx sdopt_xxx r2opt_xxx rtopt_xxx itopt_xxx change_xxx');
        
        %         appCorrelation=evalin('base','mcr_als.alsOptions.correlation.appCorrelation;');
        %         if appCorrelation==1;
        %             assignin('base','correl_yout',yout);
        %             assignin('base','correl_ycal',ycal);
        %             assignin('base','correl_stats',stats);
        %             evalin('base','mcr_als.alsOptions.resultats.correlation.yout=correl_yout;');
        %             evalin('base','mcr_als.alsOptions.resultats.correlation.ycal=correl_ycal;');
        %             evalin('base','mcr_als.alsOptions.resultats.correlation.stats=correl_stats;');
        %             evalin('base','clear correl_yout correl_ycal correl_stats');
        %         end
        
        return         % 1st return (end of the optimization, convergence)
    end
    
    %  finish the iterative optimization if divergence occurs 20 times consecutively
    if idev > 50,
        %     if idev > 20,  original
        disp(' ');disp(' ');
        disp('FIT NOT IMPROVING FOR 50 TMES CONSECUTIVELY (DIVERGENCE?), STOP!!!')
        disp(' ')
        disp(['Fitting error (lack of fit, lof) in % at the optimum = ', num2str(sdopt(1,1)),'(PCA) ', num2str(sdopt(1,2)), '(exp)']);
        disp(['Percent of variance explained (r2)at the optimum is ',num2str(100*r2opt)]);
        disp('Relative species conc. areas respect matrix (sample) 1 at the optimum'),disp(rtopt)
        disp(['Plots are at optimum in the iteration ', num2str(itopt)]);
        
        
        if isempty(evalin('base','mcr_als.alsOptions.out.out_conc'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_conc'),copt)
        end
        if isempty(evalin('base','mcr_als.alsOptions.out.out_spec'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_spec'),sopt)
        end
        if isempty(evalin('base','mcr_als.alsOptions.out.out_res'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_res'),ropt)
        end
        if isempty(evalin('base','mcr_als.alsOptions.out.out_std'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_std'),sdopt)
        end
        if isempty(evalin('base','mcr_als.alsOptions.out.out_area'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_area'),areaopt)
        end
        if isempty(evalin('base','mcr_als.alsOptions.out.out_rat'))==0
            assignin('base',evalin('base','mcr_als.alsOptions.out.out_rat'),rtopt)
        end
        
        % save parameters
        assignin('base','plot_optim_lof',sdopt(1,2));
        assignin('base','plot_optim_R2',100*r2opt);
        assignin('base','optim_niter',itopt);
        assignin('base','optim_concs',copt);
        assignin('base','optim_specs',sopt);
        
        evalin('base','mcr_als.alsOptions.resultats.plot_optim_lof=plot_optim_lof;');
        evalin('base','mcr_als.alsOptions.resultats.plot_optim_R2=plot_optim_R2;');
        evalin('base','mcr_als.alsOptions.resultats.optim_niter=optim_niter;');
        evalin('base','mcr_als.alsOptions.resultats.optim_concs=optim_concs;');
        evalin('base','mcr_als.alsOptions.resultats.optim_specs=optim_specs;');
        
        evalin('base','clear plot_optim_lof plot_optim_R2 optim_niter optim_concs optim_specs');
        
        als_end=2;
        assignin('base','als_end',als_end);
        assignin('base','copt_xxx',copt);
        assignin('base','sopt_xxx',sopt);
        assignin('base','sdopt_xxx',sdopt);
        assignin('base','r2opt_xxx',r2opt);
        assignin('base','rtopt_xxx',rtopt);
        assignin('base','itopt_xxx',itopt);
        assignin('base','change_xxx',sigman); % for std dev res vs exp
        als_res;
        evalin('base','clear als_end copt_xxx sopt_xxx sdopt_xxx r2opt_xxx rtopt_xxx itopt_xxx change_xxx');
        
        
        %         appCorrelation=evalin('base','mcr_als.alsOptions.correlation.appCorrelation;');
        %         if appCorrelation==1;
        %             assignin('base','correl_yout',yout);
        %             assignin('base','correl_ycal',ycal);
        %             assignin('base','correl_stats',stats);
        %             evalin('base','mcr_als.alsOptions.resultats.correlation.yout=correl_yout;');
        %             evalin('base','mcr_als.alsOptions.resultats.correlation.ycal=correl_ycal;');
        %             evalin('base','mcr_als.alsOptions.resultats.correlation.stats=correl_stats;');
        %             evalin('base','clear correl_yout correl_ycal correl_stats');
        %         end
        
        return          % 2nd return (end of optimization, divergence)
        
    end
    
    % this end refers to number of iterations initially proposed exceeded
    
end

% finish the iterative optimization if maximum number of allowed iterations is exceeded

disp(' ');disp(' ');
disp('NUMBER OF ITERATIONS EXCEEDED THE ALLOWED!')
disp(' ')
disp(['Fitting error (lack of fit, lof) in % at the optimum = ', num2str(sdopt(1,1)),'(PCA) ', num2str(sdopt(1,2)), '(exp)']);
disp(['Percent of variance explained (r2)at the optimum is ',num2str(100*r2opt)]);
disp('Relative species conc. areas respect matrix (sample) 1 at the optimum'),disp(rtopt)
disp(['Plots are at optimum in the iteration ', num2str(itopt)]);


if isempty(evalin('base','mcr_als.alsOptions.out.out_conc'))==0
    assignin('base',evalin('base','mcr_als.alsOptions.out.out_conc'),copt)
end
if isempty(evalin('base','mcr_als.alsOptions.out.out_spec'))==0
    assignin('base',evalin('base','mcr_als.alsOptions.out.out_spec'),sopt)
end
if isempty(evalin('base','mcr_als.alsOptions.out.out_res'))==0
    assignin('base',evalin('base','mcr_als.alsOptions.out.out_res'),ropt)
end
if isempty(evalin('base','mcr_als.alsOptions.out.out_std'))==0
    assignin('base',evalin('base','mcr_als.alsOptions.out.out_std'),sdopt)
end
if isempty(evalin('base','mcr_als.alsOptions.out.out_area'))==0
    assignin('base',evalin('base','mcr_als.alsOptions.out.out_area'),areaopt)
end
if isempty(evalin('base','mcr_als.alsOptions.out.out_rat'))==0
    assignin('base',evalin('base','mcr_als.alsOptions.out.out_rat'),rtopt)
end

% save parameters
assignin('base','plot_optim_lof',sdopt(1,2));
assignin('base','plot_optim_R2',100*r2opt);
assignin('base','optim_niter',itopt);
assignin('base','optim_concs',copt);
assignin('base','optim_specs',sopt);

evalin('base','mcr_als.alsOptions.resultats.plot_optim_lof=plot_optim_lof;');
evalin('base','mcr_als.alsOptions.resultats.plot_optim_R2=plot_optim_R2;');
evalin('base','mcr_als.alsOptions.resultats.optim_niter=optim_niter;');
evalin('base','mcr_als.alsOptions.resultats.optim_concs=optim_concs;');
evalin('base','mcr_als.alsOptions.resultats.optim_specs=optim_specs;');

evalin('base','clear plot_optim_lof plot_optim_R2 optim_niter optim_concs optim_specs');

als_end=3;
assignin('base','als_end',als_end);
assignin('base','copt_xxx',copt);
assignin('base','sopt_xxx',sopt);
assignin('base','sdopt_xxx',sdopt);
assignin('base','r2opt_xxx',r2opt);
assignin('base','rtopt_xxx',rtopt);
assignin('base','itopt_xxx',itopt);
assignin('base','change_xxx',sigman); % for std dev res vs exp
als_res;
evalin('base','clear als_end copt_xxx sopt_xxx sdopt_xxx r2opt_xxx rtopt_xxx itopt_xxx change_xxx');

% appCorrelation=evalin('base','mcr_als.alsOptions.correlation.appCorrelation;');
% if appCorrelation==1;
%     assignin('base','correl_yout',yout);
%     assignin('base','correl_ycal',ycal);
%     assignin('base','correl_stats',stats);
%     evalin('base','mcr_als.alsOptions.resultats.correlation.yout=correl_yout;');
%     evalin('base','mcr_als.alsOptions.resultats.correlation.ycal=correl_ycal;');
%     evalin('base','mcr_als.alsOptions.resultats.correlation.stats=correl_stats;');
%     evalin('base','clear correl_yout correl_ycal correl_stats');
% end
delete('temp.mat')
% if exist('funcname')==0
%     funcname='alsOptimization_fcm2_re';
% else
%     funcname(length(funcname)+1)='alsOptimization_fcm2_re';
% end
return      %3rd return (end of optimization, number of iterations exceeded)
