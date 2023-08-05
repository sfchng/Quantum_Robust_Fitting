%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Args
%      N (int): Total number of correspondences
%      dim (int): Dimension of the problem
%      xA  (array [3xN]): correspondences in imageA
%      xB  (array [3xN]): correspondences in imageB
%      th  (float)      : inlier threshold
%      outer_loop_idx (int)      : sampling index
%      output_folder  (str)      : output folder
%      inner_loop     (int)      : total number of iteration for inner loop
%                               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function run_feasibility_test(N, dim, xA, xB, th, outer_loop_idx, output_folder, inner_loop)
    for i=1:inner_loop  
        fprintf('Running outer index: %d iteration %d\n', outer_loop_idx, i);
        run_feasibility_test_each_point(N, dim, xA, xB, th, outer_loop_idx, i, output_folder);   
    end
end