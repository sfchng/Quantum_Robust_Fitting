clc;
clear;
close all;

% Path
addpath 'lib/';


% Input parameters
N = 100;
th = 0.2;
dim = 2;
outlier_percentage = 30;
BigM = 10000;
num_iterations = 200;

% Load data
fprintf('Status: Loading 2D points\n');
%load ('./data/x.mat'); 
%load ('./data/y.mat');
load ('./data/data.mat');
%load ('./data/line_fitting.mat');

%% Uncomment if you wish to generate your own points
% fprintf('Status: Generating 2D points\n');
% [x,y] = linear_regression_demo(N, dim, th, outlier_percentage);


%% Uncomment to run MIP
% Run Mixed Integer Programming to obtain a global solution
% Requires gurobi to run 
[xgurobi, Igurobi, inlier_size] = maxcon_MIP(x,y,th,dim,BigM);
vgurobi = find(xgurobi(dim+1:end) >= 0.99999);
fprintf("Consensus size of MIP solutions: %d\n", inlier_size);

figure;
plot(x(:,1), y, 'bo', 'MarkerFaceColor', 'b');
hold on;
plot(x(vgurobi,1), y(vgurobi), 'ro', 'MarkerSize', 10);


approximate_influence(num_iterations, N, x, y, dim, th, vgurobi);



