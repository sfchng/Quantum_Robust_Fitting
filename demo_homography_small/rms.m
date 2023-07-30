function tmp=rms(s,m,imseq,v);
% RMS(s,m,imseq,v) reproject structure s
%  with motion m and calculate Root Mean Square (RMS) error for points in images
% INPUT:
%  s - 3d points
%  m - motion (cameras)
%  imseq - cell list of imagedata
%  v - view . If not specified, the whole sequence is displayed
%

if nargin <=3 | isempty(v),
  vs = 1:length(m);
else
  vs = v;
end
nbrvs=length(vs);
rm=zeros(1,nbrvs);
nbr=zeros(1,nbrvs);
res=[];
maxerr=0;
for i=vs;
  repts=pflat(m{i}*s);
  pts=imseq{i};
  pindex=find(~isnan(pts(1,:)) & ~isnan(repts(1,:)));
  nbrpts=length(pindex);
  err=repts(1:2,pindex)-pts(1:2,pindex);
  res=[res;err(:)];

  tmp=sum(err.^2);
  rm(i)=sum(tmp);
  maxerr=max([maxerr,tmp]);
  tmp=sqrt(rm(i)/(2*nbrpts));
  if nargout==0,
    disp(['View ',num2str(i),', RMS ',num2str(tmp),' --- Number of points: ',num2str(nbrpts)]);
  end
  nbr(i)=nbrpts;
end
tmp=sqrt(sum(rm)/(2*sum(nbr)));
if nargout ==0,
  disp(['Total RMS ',num2str(tmp),' --- Number of points: ',num2str(sum(nbr))]);
  disp(['L-infinity error: ',num2str(sqrt(maxerr)),' pixels']);
  clf;plot(res,'.');
end
