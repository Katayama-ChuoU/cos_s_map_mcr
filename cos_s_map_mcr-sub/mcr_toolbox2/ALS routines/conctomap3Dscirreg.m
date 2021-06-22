% function [mdis,quantc]=conctomap(copt,sopt,x,y,z,long,pixin,pixout);
% x pixels in x direction (a single number if all images are equally sized,
% a vector if images have different sizes)
% y pixels in y direction (a single number if all images are equally sized,
% a vector if images have different sizes)
% z number of images in multiset
% long wavelength axis for spectra (optional)
% pixin indexes of pixels in resolution (all unless there is background)
% pixout indexes of background pixels (not considered for resolution)
% if only 5 arguments, pixin is generated automatically
% Distribution maps are scaled in the same way, with the minimum c value and
% maximum in all layers and compounds.

function [mdis,quantc]=conctomap3Dscirreg(copt,sopt,x,y,z,long,pixin,pixout);

[m,n]=size(copt);
[rs,cs]=size(sopt);
minc=min(min(copt));
maxc=max(max(copt));
if nargin <=4
    z=1;
end
if nargin <=5
    long=[1:cs];
end
if nargin <=6
    pixout=0;
    pixin=[1:m];
end
close all
[m,n]=size(copt);
mdis=cell(z,n);
quantc=zeros(z,n);
ctot=zeros(m,n);
ctot(pixin,:)=copt;
if pixout~=0
    ctot(pixout,:)=min(min(copt));
end
% reshaping conc profiles into maps frommultisets with images equally sized
if length(x)==1 & length(y)==1
    for j=0:z-1
        clayer=ctot((x*y)*j+1:(x*y)*(j+1),:);
        for i=1:n
            quantc(j+1,i)=100*(sum(sum(clayer(:,i)*sopt(i,:))))/(sum(sum(clayer*sopt)));
            mdis{j+1,i}=reshape(clayer(:,i),x,y);
            figure(j+1),subplot(n,1,i),imagesc(mdis{j+1,i},[minc maxc]),axis('square')
        end
    end
end
% reshaping conc profiles into maps from multisets with images with different sizes
if length(x)>1 & length(y)>1
    ptot=0;
    for j=0:z-1
        clayer=ctot(ptot+1:ptot+x(j+1)*y(j+1),:);
        ptot=sum([ptot x(j+1)*y(j+1)]);
        for i=1:n
            quantc(j+1,i)=100*(sum(sum(clayer(:,i)*sopt(i,:))))/(sum(sum(clayer*sopt)));
            mdis{j+1,i}=reshape(clayer(:,i),x(j+1),y(j+1));
            figure(j+1),subplot(n,1,i),imagesc(mdis{j+1,i},[minc maxc]),axis('square')
        end
    end
end

figure,plot(long,sopt)