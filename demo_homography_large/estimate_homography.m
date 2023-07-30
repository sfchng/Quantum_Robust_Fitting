function [Hinf, maxres, gamma] = estimate_homography(XA, XB)
    
    
    %% Initialisation
    [A, b, c, d] = genQuasiHomo(XA, XB);
    h1 = size(A,2);
    h_init = rand(h1,1);

    [hOpt, ~, ~, gamma] = linf_homo(A,b,c,d,h_init);
    
    
    %% Evaluate residual with current estimated H   
    p = size(A,1)/numel(d);
    AxPb = reshape(A*hOpt, p, numel(d))+b;
    Sqrt_AxPb = sqrt(sum(AxPb.^2,1));
    CxPd = (hOpt'*c + d);
    resn = zeros(1, p);
    resn = Sqrt_AxPb./CxPd;   
    maxres = max(resn);

    hOpt(end+1) = 1;
    Hinf = reshape(hOpt, [3,3]);
    Hinf = Hinf';
    
   

    %% Warp and composite images
    %{
    HA = TB\Hinf * TA;
    bbox=[-300 750 -100 600];    % image space for mosaic
    
    % warp image 1 to the reference image 2
    figure; clf;
    iwa = vgg_warp_H(matches.ib, HA, 'linear', 'img');
    imshow(iwa); axis image;
    %}

end