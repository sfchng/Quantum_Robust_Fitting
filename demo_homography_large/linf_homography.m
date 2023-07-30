function H=linf_homography(u,U,iter,upper);
%L-infinity homography from n points
%H = LINF_HOMOGRAPHY(u,U,iter,upper);
%
%u is a 2-by-n matrix of measured image coordinates.
%U is a 3-by-n matrix of homogeneous plane coordinates.
%iter (optional) is the number of bisection iterations. Default is 15.
%upper (optional) is the upper bound in pixels for initial interval. Default is 1.
%H is a 3-by-3 homography matrix.
%
% (C) 2005 Fredrik Kahl.

if nargin<3 | isempty(iter),
    iter=15;
end
if nargin<4 | isempty(upper),
    upper=1;
end

low=0;
high=upper;

if size(u,1)~=2,
    error('wrong size on image coordinate matrix');
end
if size(U,1)~=3,
    error('wrong size on plane coordinate matrix');
end

%number of views
nbrpoints=min(size(u,2),size(U,2));
if nbrpoints<4,
    error('too few points');
end

%parametrization: H=[h1,h2,h3;h4,h5,h6;h7,h8,1]

feasible=0; %found a feasible solution?

gamma=high;

vars=8;

%sedumi matrices
At=sparse(zeros(0,vars));
b=sparse(zeros(vars,1));
c=sparse(zeros(0,1));

clear K;
K.q=[];
for ii=1:nbrpoints,
    Atmp=sparse(zeros(3,vars));
    ctmp=sparse(zeros(3,1));
    
    Utmp=U(:,ii); %current points
    utmp=u(:,ii);
    
    %radius of cone constraint
    ctmp(1)=gamma*Utmp(3);
    Atmp(1,7:8)=-gamma*Utmp(1:2)';
    
    %coefficients of cone constraint
    ctmp(2:3)=-utmp*Utmp(3);
    Atmp(2,1:3)=-Utmp';
    Atmp(3,4:6)=-Utmp';
    Atmp(2:3,7:8)=utmp*Utmp(1:2)';

    %store in Sedumi matrices
    At=[At;Atmp];
    c=[c;ctmp];
    K.q=[K.q,3];
end

pars=[];
pars.fid=0;

qq=0;
while qq<iter & high-low>1e-8,
    qq=qq+1;
    
    [x,y,info]=sedumi(At,b,c,K,pars);
    gammaold = gamma;

    infeasible=1;
    if info.dinf==0,
        %evaluate estimated point
        Hetmp=ones(3,3);
        Hetmp(1:8)=real(y);
        Hetmp=Hetmp';
        
        tmp=pflat(Hetmp*U);
        res=sum((u(1:2,:)-tmp(1:2,:)).^2);
        maxres=sqrt(max(res));
        
        if maxres<=gamma,
            high=maxres;
            H=Hetmp;
            feasible=1;
            infeasible=0;
        end
    end
    if infeasible,
        %'infeasible' -> make interval larger
        low=gamma;
        if feasible==0,
            high=high*2;
        end
    end
    
    gamma=(high+low)/2;
    
    if qq<iter, %more iterations
        %apply new gamma to c and At
        gfactor=gamma/gammaold;
        index=1:3:3*nbrpoints;
        c(index)=c(index)*gfactor;
        At(index,:)=At(index,:)*gfactor;
    end
end %gamma iteration


if feasible==0,
    H=[];
end


