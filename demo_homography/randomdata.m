function [U,P,u,u0]=randomdata(nbrimages,nbrpoints,option)
% RANDOMDATA creates a random scene and images with random camera positions
% [str,mot,imseq,imseq0]=randomscene(nbrimages,nbrpoints,option)
% INPUT:
%   nbrimages - number of images
%   nbrpoints - number of points
%   option:
%    'affine' - use the affine camera model
%    'constant' - constant intrinsic parameters
%    'zeroprincipal' - principal point at zero
%    'skew' - varying intrinsic parameters, except skew is zero
%    'distance=X' - set nominal camera distance to 'X'
%    'cube=X' - set nominal cube to [-X,X]
%    'noise=X' - add noise to image-points with std 'X'
%    'calibrated' - calibration matrices equal to identity
%    'norotation' - no relative rotation, hence translating cameras
%    'conics' - Quadrics are rank 3 disk-quadrics, i.e. conics in a plane
%    'closecameras' - cameras are close to previous camera
%    'planar' - points will be on z=0-plane
% OUTPUT:
%   U - structure
%   P - motion
%   u - cell list of imagedata
%   u0 - unperturbated version of imseq
%    
% Default option is perspective camera with skew 0 and aspect ratio 1,
% with focal lengths around 1000, and 3D-features within the (half) cube [-500,500] (Z>=0)
% and camera distance around 1000 to origo.

if nargin<1
  nbrimages=5;
end
if nargin<2
  nbrpoints=10;
end

planar=0;
distance = 1000;
cube = 500;
noise = 0;
norotation=0;
affinecamera=0;
camidentity=0;
diskquads=0;
zeroprincipal=0;
constantinternals=0;

closecameras=0;

if nargin>=3 %option set?
  if strmatch('planar',option)
    planar=1;
  end
  if strmatch('closecameras',option)
    closecameras=1;
  end
  if strmatch('affine',option)
    affinecamera=1;
  end
  if strmatch('constant',option)
    constantinternals=1;
  end
  if strmatch('norotation',option)
    norotation=1;
  end
  if strmatch('zeroprincipal',option)
    zeroprincipal=1;
  end
  if strmatch('skew',option)
    disp('skew option not implemented. PLEASE do!');
    keyboard;
  end
  if strmatch('distance',option)
    q=strmatch('distance=',option);
    strdist = option{q}(10:length(option{q}));
    distance=str2num(strdist);
  end
  if strmatch('cube',option)
    q=strmatch('cube=',option);
    strcube = option{q}(6:length(option{q}));
    cube=str2num(strcube);
  end
  if strmatch('noise',option)
    q=strmatch('noise=',option);
    strnoise = option{q}(7:length(option{q}));
    noise=str2num(strnoise);
  end
  if strmatch('calibrated',option)
    camidentity=1;
  end
  if strmatch('conics',option)
    diskquads=1;
  end
end

%create random points
U=[2*cube*(rand(3,nbrpoints)-0.5);ones(1,nbrpoints)];
U(3,:)=U(3,:).*sign(U(3,:));
if planar
    U(3,:)=0;
end

P={};
%mot=motion;
%str=structure(point3d,line3d,quadric);
u={};
u0={};

% generate camera positions
for l=1:nbrimages
  t=distance*[randn(1,1)*0.1 randn(1,1)*0.1 (1+randn(1,1)*0.1)]';
  if norotation,
      R=eye(3);
  elseif l>1 & closecameras,
      R=R*expm(skew(randn(3,1)/5));
  else
      R=randrot;
  end
  if affinecamera,
    R(3,:)=0;
  end
  f=1000;
  if camidentity
    K = eye(3);
  elseif zeroprincipal
    K=[f 0 0;
     0 f 0;
     0 0 1];
  else
    K=[f 0 20*randn;
     0 f 20*randn;
     0 0 1];
  end

  if constantinternals
    if l==1
      Kfirst=K;
    else
      K=Kfirst;
    end
  end
  
  pcam=K*[R t];
  if affinecamera
    pcam=pcam/pcam(3,4);
    [tmp1,tmp2]=rq(pcam(1:2,1:2));
    if det(tmp2)==-1
      [tmp3,tmp4]=eig(tmp2);
      pcam(1:2,1:2)=tmp1*tmp3;
    end
  end
  P{end+1}=pcam;
  
%  mot=addcameras(mot,pcam);
  pts = pflat(pcam*U);
  pts(3,:)=[];
  u0{end+1}=pts;

  % perturbate points
  if nbrpoints>0
    pts=pts+noise*randn(2,size(pts,2));
  end
  u{end+1}=pts;
end
