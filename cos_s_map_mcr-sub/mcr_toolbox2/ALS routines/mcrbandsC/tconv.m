function toutput=tconv(tinput,n);
index=0;
% disp(n)
for i=1:n,
    for j=1:n,
        if i==j,
            toutput(i,j)=1;
        else
            index=index+1;
            toutput(i,j)=tinput(1,index);
        end
    end
end
% disp(toutput)

            