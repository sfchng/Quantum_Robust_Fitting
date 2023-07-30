function approximate_influence(M, N, x, y, dim, th, vgurobi)

    num_iterations = M / 100;
    for k = 1 : num_iterations
        fprintf('Status: Sampling size %d\n', k*100);
        
        % Sample triples
        ind = randsample(N, dim+1);
      
        if k <= 1
            R(k).vc = zeros(N,1);  % violation cnt
            R(k).A = zeros(N,1);   % sampled (d+t) size
            R(k).io = zeros(N,1);  % inlier? outlier?        
        else
            R(k).vc = R(k-1).vc; 
            R(k).A = R(k-1).A; 
            R(k).io = R(k-1).io;             
        end
        
        for j=1:N
            % outlier=1, inlier =0
            
            fprintf('Status: Sampling size %d | Point %d\n', k*100, j);
            LIO = ismember(j, vgurobi);
            if LIO == 1
                R(k).io(j) = 1;
            else
                R(k).io(j) = 0;
            end
            

            i=1;
            while i <= 100

               % sample triplets   
               ind = randsample(N,dim+1);
               LIJ = ismember(j, ind);
               if LIJ == 1
                   % j is in the coverage set
                   continue;
               else
                   % Chebycheff estimate
                   [~, w, ~] = FitByChebyshev(x(ind,:), y(ind));

                   % Verify feasibility
                   if w > th
                      % Feasible solution not found
                      feasible = 1; 
                   else
                       % Feasible solution is found
                      feasible = 0;
                   end

                    R(k).A(j) = R(k).A(j)+1;  

                    % P = B U ith point
                    S = union(ind, j);
                    S = sort(S);
                    % Chebycheff estimate
                    [~, w_S, ~] = FitByChebyshev(x(S,:), y(S));       

                    % Verify feasibility of set P
                    if w_S > th
                        % feasible solution not found
                        feasible_S = 1; 
                    else
                        % feasible solution is found
                        feasible_S = 0;
                    end 

                    % Increase the violation cnt if the feasibiliy test
                    % changes
                    if feasible ~= feasible_S
                        R(k).vc(j) = R(k).vc(j) + 1;
                    end 

                    i=i+1;
               end

            end
        end        

    end
    
    % compute influence
    for i=1:size(R,2)
        % clear ind
        o_ind = 1;
        i_ind = 1;

        for j=1:N      
            % compute influence function
            influence(j,i) = R(i).vc(j)/R(i).A(j);  
            indicator(j,i) = R(i).io(j);

            if R(i).io(j) == 1         
                % storage array of outlier
                R_outlier(i,o_ind) = influence(j,i);
                o_ind = o_ind+1;
            else
                % storage array of inlier
                R_inlier(i,i_ind) = influence(j,i);
                i_ind = i_ind+1;        
            end
        end
    end


    
    % compute normalised influence
    for i = 1 : size(influence,2)
        den = max(influence(:,i)) - min(influence(:,i));
        
        for j = 1 : N        
            normalised_influence(i, j) = (influence(j,i)-min(influence(:,i)))/den;  
        end
        
        
    end


    figure;
    hold on;
    iv = sort(normalised_influence(end,:), 'descend');
    plot(iv, 'ro');
    ylabel('Normalised Influence');
    xlabel('Point index');
    
    
end