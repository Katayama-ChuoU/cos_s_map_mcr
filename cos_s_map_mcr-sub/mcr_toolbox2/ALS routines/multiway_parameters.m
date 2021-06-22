% Multiway parameters before loading/resetting multiwayC
% *************************************************************************
evalin('base','mcr_als.alsOptions.trilin.trildir=1;');
evalin('base','mcr_als.alsOptions.trilin.nway=3;');
nway=3;
trildir=1;
evalin('base','mcr_als.alsOptions.trilin.nway=3;');
evalin('base','mcr_als.alsOptions.trilin.ne=[0 0 0];'); % only used in quadril models

evalin('base','mcr_als.alsOptions.trilin.aux.Mactiu=1;');
evalin('base','mcr_als.alsOptions.trilin.aux.Iactiu=1;');

nsign=evalin('base','mcr_als.CompNumb.nc;');
spetric=zeros(1,nsign);
assignin('base','spetric',spetric);
evalin('base','mcr_als.alsOptions.trilin.spetric=spetric;');
% spetris=zeros(1,nsign);
modeltuckc=ones(1,nway).*nsign;
assignin('base','modeltuckc',modeltuckc);
evalin('base','mcr_als.alsOptions.trilin.modeltuckc=modeltuckc;');
% modeltucks=ones(1,nway).*nsign;
spetuckc=ones(nway,1)*[1:nsign];
assignin('base','spetuckc',spetuckc);
evalin('base','mcr_als.alsOptions.trilin.spetuckc=spetuckc;');
% spetucks=ones(nway,1)*[1:nsign];
evalin('base','clear spetric modeltuckc spetuckc');