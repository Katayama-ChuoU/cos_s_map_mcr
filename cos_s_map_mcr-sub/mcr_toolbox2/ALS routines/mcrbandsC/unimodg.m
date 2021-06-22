function [gunimod]=unimodg(conc,rmod)
% function [gunimod]=unimodg(conc,rmod)

[ns,nc]=size(conc);
nmdf=0;
gunimodu=[];
gunimod=[0];

% 1) look for the maximum

for j=1:nc,
   [y,imax(j)]=max(conc(:,j));
end

% 2) look for unimodality shape

for j=1:nc,

    rmax=conc(imax(j),j);
    k=imax(j);

    % disp('maximum at point');disp(k)

    % 2a) look for non-unimodal shape at the left (tolerance rmod)

    while k>1,
        k=k-1;

        if conc(k,j)<=rmax,
            rmax=conc(k,j);
        else
            rmax2=rmax*rmod;
            if conc(k,j)>rmax2,
                gunimodu=[gunimodu;conc(k,j)-rmax2];
                rmax=conc(k,j);
                nmdf=nmdf+1;
            end
        end
    end


    % 2b) look for non-unimodal shape at the right (tolerance rmod)


    rmax=conc(imax(j),j);
    k=imax(j);

    while k<ns-1,
        k=k+1;

        if conc(k,j)<=rmax,
            rmax=conc(k,j);
        else
            rmax2=rmax*rmod;
            if conc(k,j)>rmax2,
                gunimodu=[gunimodu;conc(k,j)-rmax2];
                nmdf=nmdf+1;
                rmax=conc(k,j);
            end

        end
    end
    if isempty(gunimodu),
        gunimodu(j,1)=0;
    else,
        gunimod(j,1)=max(gunimodu);
    end

end

