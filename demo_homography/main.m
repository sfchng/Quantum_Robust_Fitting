clear; clc;
close all;

dataset_name = 'church';

% test parameters
dim = 8;
th = 0.1;
num_samples = 10;  % sample 50 times
disp('Running approximate influence: Homography estimation');

% load unnormalised image 
load (strcat('data/',dataset_name, '/matches.mat'));

[xA, T1] = normalise2dpts(matches.X1);
[xB, T2] = normalise2dpts(matches.X2);

N=size(xA,2);

tic;
for i=1:num_samples
    fprintf('Running sample index: %d\n', i);
    
    % randomly sample
    run_feasibility_test(N, dim, xA, xB, th, i);
end
toc;