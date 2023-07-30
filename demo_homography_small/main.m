% This demo is to evaluate the exact influence function of each point
% consider all possible combinations of (d+1) subset
clc;clear;close all;

% path
dataset_name = 'keble';

load (strcat('data/', dataset_name, '/matches.mat'));

% original image points
num_orig_pts=size(data.matches.X1,2);
num_orig_inliers=size(data.inlrs,2);
num_orig_outliers=data.num_outlrs;

% test configuration
N=20;
dim=8;
num_outliers=5;
epsilon = 0.1;  % normalised inlier threshold

v=1:1:N;
C=nchoosek(v,dim+1);

figure(1), clf;
X = [ data.matches.X1; data.matches.X2];
plot_match(data.matches, X, [1:num_orig_pts], 1);
title('Tentative correspondences');
hold off;
set(gcf,'color','w');


% ---------------------------------------------------------------
%% Subsampled points

% groundtruth inliers
inlrs_ind = data.inlrs;
olrs_ind = data.outlrs;

subsampled_inlrs = randsample(num_orig_inliers,N-num_outliers);
subsampled_olrs = randsample(num_orig_outliers, num_outliers);

subsampled_inlrs_ind = inlrs_ind(subsampled_inlrs);
subsampled_olrs_ind = olrs_ind(subsampled_olrs);
subsampled_ind = [subsampled_inlrs_ind, subsampled_olrs_ind];
subsampled_ind = sort(subsampled_ind);

subsampled_data.matches.im1 = data.matches.im1;
subsampled_data.matches.im2 = data.matches.im2;
subsampled_data.matches.X1 = data.matches.X1(1:3, subsampled_ind);
subsampled_data.matches.X2 = data.matches.X2(1:3, subsampled_ind);
X = [ subsampled_data.matches.X1; subsampled_data.matches.X2];
figure(2), clf;
plot_match( subsampled_data.matches, X, [1:N], 1);
title('Subsampled tentative correspondences');
hold off;
set(gcf,'color','w');

[xA, T1] = normalise2dpts(data.matches.X1);
[xB, T2] = normalise2dpts(data.matches.X2);

total_samples = zeros(N,1);
violation_cnt = zeros(N,1);

XA = xA(1:3, subsampled_ind);
XB = xB(1:3, subsampled_ind);
[Hinf_G, Hinf_res_G] = estimate_homography(XA, XB);


% warp image 1 to the reference mosaic frame (image 2) 
figure(3); clf;
HA = T2\Hinf_G*T1;
bbox=[-300 750 -100 600];    % image space for mosaic
iwc = vgg_warp_H(data.matches.im2, eye(3), 'linear', bbox); % image b is chosen as the reference image
iwa = vgg_warp_H(data.matches.im1, HA, 'linear', bbox);  % warp image a to the mosaic image
imshow(iwa); axis image;
imagesc(double(max(iwc,iwa))); % combine images into a common mosaic (take maximum value of the two images)
set(gca, 'XTick', [], 'YTick', []);
title('Own fit Homography');


% extract N pts
for i=1:N
    fprintf('Finding the influence function of point %d\n', i);
    
    for j=1:size(C,1)

        % (d+1) subset
        ind = C(j,:);
        % check if i is in the coverage set
        LIC = ismember(i,ind);

        if LIC == 1
            continue;
        else
          XA = xA(1:3, subsampled_ind(ind));
          XB = xB(1:3, subsampled_ind(ind));
          [Hinf, Hinf_res, gamma] = estimate_homography(XA, XB);
          total_samples(i)=total_samples(i)+1;
       
          
          if Hinf_res <= epsilon
              feasible = 1;
          else
              feasible = 0;
          end
                   
          S = union(ind, i);
          S = sort(S);
          XA = xA(1:3, subsampled_ind(S));
          XB = xB(1:3, subsampled_ind(S));
          [Hinf_S, Hinf_res_S,gamma_S] = estimate_homography(XA, XB);
            
          if Hinf_res_S <= epsilon
             feasible_S = 1;
          else
             feasible_S = 0;
          end
          
          if feasible ~= feasible_S
             violation_cnt(i) = violation_cnt(i)+1;
          end
        end

    
    end
end


hist(res);

