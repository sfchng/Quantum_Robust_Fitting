function run_feasibility_test_each_point(N, dim, xA, xB, th, sample_index, loop_index)

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
    
    save(strcat('vc_sample_size_',num2str(sample_index), '_loop_index_',num2str(loop_index),'.mat'), 'vc', 'A');
    save(strcat('approximate_homo_sample_size_',num2str(sample_index),'_loop_index_',num2str(loop_index),'.mat'));    
end