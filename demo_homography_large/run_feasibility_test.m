function run_feasibility_test(N, dim, xA, xB, th, sample_index)

    % run for 100 times
    for i=1:100  
        fprintf('Running sample index: %d iteration %d\n', sample_index, i);
        run_feasibility_test_each_point(N, dim, xA, xB, th, sample_index, i);   
    end
end