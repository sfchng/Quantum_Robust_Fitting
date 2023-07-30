clc;
clear;
close all;

num_runs = 8;
num_sample_size = 100;
num_pts = 516; % church dataset
run_index = [1,2,3,4,5,6,7,8];  % DONT REMOVE! ORIGINAL ONE!
delta_threshold = 0.3;

result_path = '/Users/shinfang/Documents/PhD/Boolean_Function/MVG/Homography_Approx_Church/result_church/';
dataset_path = '/Users/shinfang/Documents/PhD/Boolean_Function/MVG/Homography_Approx_Church/data/groundtruth/';

% influence variable
% column: sample size; row: ith point

cumulative_vc = zeros(num_pts,1);
cumulative_A = zeros(num_pts,1);
influence = zeros(num_pts, num_runs);

% vc saves all N pts
%% Nx1 variable for a sample

% load file
load (strcat(dataset_path, 'church_matches.mat'));

for i=1:size(run_index,2)
    for j=1:num_sample_size
        % load .mat file
        load (strcat(result_path,'vc_sample_size_', num2str(run_index(i)), '_loop_index_', num2str(j),'.mat'));
        %fprintf('%d %d\n',i,j);
        
        % save point (264 pts)
        cumulative_vc(:,1) = cumulative_vc(:,1) + vc(:,1);
        cumulative_A(:,1) = cumulative_A(:,1) + 1;
    end
    assert(cumulative_A(1,1) == (num_sample_size*i));
    influence(1:num_pts,i) = (influence(1:num_pts,i)+ cumulative_vc(:,1))./ cumulative_A(:,1);    
end



final_influence = influence(:,end);
potential_outlier = find(final_influence>delta_threshold);
den = max(final_influence) - min(final_influence);
for i=1:size(final_influence,1)
    final_influence_n(i) = (final_influence(i) - min(final_influence))/den;
end
potential_outlier = find(final_influence_n>delta_threshold);

iv_n = sort(final_influence_n,'descend');
figure;
hold on;
plot(iv_n, 'bo');
red_ind = find(iv_n > 0.3);
plot(red_ind, iv_n(red_ind), 'ro');
set(gcf, 'color', 'w');
set(gcf, 'color','w');
xlabel('Point Index i','Fontsize',14); ylabel('Influence','Fontsize',14);
xlim([1 num_pts]);
yline(0.3, 'g--', 'LineWidth', 2);

figure;
sample_size = 200;
inlrs = 1:num_pts;
inlrs(potential_outlier) = [];
%matches_sub.im1 = matches.im1;
%matches_sub.im2 = matches.im2;
%matches_sub.X1 = matches.X1;
%matches_sub.X2 = matches.X2;
plot_match(matches, [matches.X1; matches.X2], inlrs, 1);


figure;
t = tiledlayout(2,1,'TileSpacing','Compact','Padding','Compact');
nexttile
inlrs = 1:num_pts;
inlrs(potential_outlier) = [];
plot_match_sf(matches, [matches.X1; matches.X2],inlrs, 1); 

nexttile
inlrs = 1:num_pts;
inlrs(potential_outlier) = [];
plot_match_sf(matches, [matches.X1; matches.X2],inlrs, 0); 
set(gcf,'color', 'w');


%% Warp and composite image
%{
[x1, T1] = normalise2dpts(matches.X1);
[x2, T2] = normalise2dpts(matches.X2);

Happ = homography2d(x1(:, inlrs), x2(:,inlrs));
HR = T2\Happ*T1;
% figure(5); clf;
bbox=[-400 1400 -200 700];    % image space for mosaic
% warp image b to mosaic image using an identity homogrpahy
% Image b is chosen as the reference frame
iwc = vgg_warp_H(matches.im2, eye(3), 'linear', bbox);
% imshow(iwc); axis image;
% warp image 1 to the reference mosaic frame (image 2) 
figure(6); clf;
iwa = vgg_warp_H(matches.im1, HR, 'linear', bbox);  % warp image a to the mosaic image
imshow(iwa); axis image;
imagesc(double(max(iwc,iwa))); % combine images into a common mosaic (take maximum value of the two images)
title('Happ fit Homography');
%}



