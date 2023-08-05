%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Args
%      N (int): Total number of correspondences
%      dim (int): Dimension of the problem
%      xA  (array [3xN]): correspondences in imageA
%      xB  (array [3xN]): correspondences in imageB
%      th  (float)      : inlier threshold
%      outer_loop_idx (int)      : sampling index
%      inner_loop     (int)      : total number of iteration for inner loop
%      output_folder  (str)      : output folder
                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function run_feasibility_test_each_point(N, dim, xA, xB, th, outer_index, inner_index, output_folder)

% for each iteration
  % sample (d+1) pts
    B=[1:N];
    ind = randsample(B, dim+1);
    ind = sort(ind);
    
    A = zeros(N,1);
    vc = zeros(N,1);

    % for each point
    for i=1:N
       A(i) = A(i)+1;
       
       % fit with l-infinity
       [Hinf, Hinf_res] = estimate_homography(xA(:,ind), xB(:,ind));  
       
       % check feasibility
        if Hinf_res <= th
            feasible=1;
        else
            feasible=0;
        end
        % Union jth pt
        S = union(ind, i);
        S = sort(S);
        
        [Hinf_S, Hinf_res_S] = estimate_homography(xA(:,S), xB(:,S));
        
        if Hinf_res_S <= th
           feasible_S=1; 
        else
           feasible_S=0;
        end
        
        if feasible ~= feasible_S
           % increase the violation cnt
           vc(i) = vc(i)+1;  
        end 
    end
    
    save(strcat(output_folder, '/vc_sample_size_',num2str(outer_index), '_loop_index_',num2str(inner_index),'.mat'), 'vc', 'A');
    %save(strcat(output_folder, '/approximate_homo_sample_size_',num2str(outer_index),'_loop_index_',num2str(inner_index),'.mat'));    
end