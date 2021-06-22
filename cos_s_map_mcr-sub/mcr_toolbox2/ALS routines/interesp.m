function [conckin]=interesp(conc2,Ccol);

% Script for the incelation of coloured/non-coloured species arxiu 
% function [conckin]=interesp(conc2,Ccol);
%
% where:
% - conc2 ===> matrix  of ALS concentrations - coloured species
% - Ccol ====> matrix of 1(coloured) and 0(non-coloured)
% - conckin => matrix of concentrations with the non-coloured species
%

conckin=zeros(size(conc2,1),length(Ccol));  
Ccolflag=1;
zz=1;
Ccolini=Ccol(zz);
Ccolmar=0;
resta=0;

for zz=1:length(Ccol);
    
    if Ccol(1)==0
        
        if Ccolini==0
            yy=zz+1;
            Ccolini=1;
            Ccolmar=1;
        else
            yy=zz;
        end
        
        if Ccolflag==0;
            resta=resta+1
            yy=yy-resta;
        end
        
        if (Ccolmar==1 & Ccolflag==1)
            yy=yy-resta;
        end
        
        Ccolzz=zeros(1,length(Ccol));
        Ccolnum=Ccol(zz);
        Ccolzz(1,zz)=Ccolnum;
        
        if Ccolnum==0
            yy=1;
        end
        
        conckinaux=conc2(:,yy)*Ccolzz;
        conckin=conckin+conckinaux;
        Ccolflag=Ccolnum;
        
    else
        
        yy=zz;
        
        if Ccolflag==0;
            resta=resta+1;
            yy=yy-resta;
            Ccolmar=1;
        elseif ( Ccolmar==1 & Ccolflag==1)
            yy=yy-resta;
        end
        
        Ccolzz=zeros(1,length(Ccol));
        Ccolnum=Ccol(zz);
        Ccolzz(1,zz)=Ccolnum;
        
        if Ccolnum==0
            yy=1;
        end
        
        conckinaux=conc2(:,yy)*Ccolzz;
        conckin=conckin+conckinaux;
        Ccolflag=Ccolnum;
        
    end
    
end
