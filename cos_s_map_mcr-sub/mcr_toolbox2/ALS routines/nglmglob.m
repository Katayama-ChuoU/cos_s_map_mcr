function [k,C,ssq,J]=nglm(fname,k0,A_0,t,Y,choose,O,R,Ccol)

ssq_old=1e50;
mp=10;
mu=1e-4;													% factor related to convergence limit
delta=0.0001;												% step size for numerical diff
k=k0';
iter=1;

while iter<10
    [r0,C]=feval(fname,k,A_0,t,Y,choose,O,R,Ccol);			% call calc of residuals
    iter=iter+1;
    ssq=sum(r0.*r0);
    disp(['Sum of squares nº',num2str(iter),'= ', num2str(ssq)]);
    conv_crit=(ssq_old-ssq)/ssq_old;
    if conv_crit >= 0 & abs(conv_crit) >= mu	            % convergence !
        mp=mp/3;
        ssq_old=ssq;
        r0_old=r0;
        for i=1:length(k)
            k(i)=(1+delta)*k(i);
            r=feval(fname,k,A_0,t,Y,choose,O,R,Ccol);	    % slice-wise numerical
            J(:,i)=(r-r0)/(delta*k(i));			            % differentiation to
            k(i)=k(i)/(1+delta);						    % form the Jacobian
        end
    elseif conv_crit < 0								    % divergence !
        mp=mp*5;
        k=k-delta_k;									    % and take shifts back
    elseif abs(conv_crit) < mu								% minimum reached !
        if mp==0
            break											% if Marquardt par zero, stop
        else												% otherwise
            mp=0;											% set to 0 , another iteration
            r0_old=r0;
        end
        
    end
    
    % setting k as a col vector for multiple matrices analysis
    [km,kn]=size(k);                                        % k as col vector
    if kn>1;k=k';end;
    
    J_mp=[J;mp*eye(length(k))];					            % augment Jacobian matrix
    r0_mp=[r0_old;zeros(size(k))];				            % augment residual vector
    delta_k=-J_mp\r0_mp;								    % calculate parameter shifts
    k=k+delta_k;										    % add parameter shifts
    
end
