clear; clc;
close all;


%%%%%%%%%%%%%%%%%%%%%%%%% Demo parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataset_name = 'christ_church';
dim = 8;
th = 0.1;

% M = outer_loop*inner_loop 
outer_loop = 8;         
inner_loop = 100;
disp('Running approximate influence: Homography estimation');


%% load unnormalised image 
load (strcat('data/',dataset_name, '/matches.mat'));

[xA, T1] = normalise2dpts(matches.X1);
[xB, T2] = normalise2dpts(matches.X2);

N=size(xA,2);

%%%%%%%%%%%%%%%%%%%%%%%% Create a new folder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the current date and time
current_DateTime = datetime('now', 'Format', 'yyyyMMdd_HHmmss');

% Convert the date and time to a string
folder_name = char(current_DateTime);

% Create the new folder
new_folder = fullfile('output', folder_name);

% Check if the folder already exists, and create if not
if ~isfolder(new_folder)
    mkdir(new_folder);
    fprintf('Folder "%s" created.\n', new_folder);
else
    fprintf('Folder "%s" already exists.\n', new_folder);
end

%%%%%%%%%%%%%%%%%%%%%%%% Main demo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
for i=1:outer_loop
    fprintf('Running outer loop >>>>>>>>>> Iteration: %d\n', i);
    
    % randomly sample
    run_feasibility_test(N, dim, xA, xB, th, i, new_folder, inner_loop);
end
toc;