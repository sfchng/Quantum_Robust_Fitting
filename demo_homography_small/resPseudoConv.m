function r = resPseudoConv(A,b,c,d,x)

    dim1 = size(A,1)/numel(d);
    AxPb = reshape(A*x(1:end-1), dim1, numel(d))+b;
    Sqrt_AxPb = sqrt(sum(AxPb.^2,1));
    CxPd = x(1:end-1)'*c + d;
    
    r = Sqrt_AxPb - (x(end)*CxPd);
  
end