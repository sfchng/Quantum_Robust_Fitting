function [x_opt, inlier_opt, consensus_opt]=maxcon_MIP(x, y, th, dim, M)

    BigM = M;
    [m,n] = size(x);
     
    A1 = [x, -BigM*eye(m)];
    A2 = [-x, -BigM*eye(m)];
    A = [A1; A2];
    
    b1 = y + repmat(th,m,1); 
    b2 = -y + repmat(th,m,1);
    b = [b1; b2]; 
    
    f = [zeros(dim,1); ones(m,1)];       

    model.A = sparse(A);
    model.obj = f;
    model.rhs = b;
    model.sense = '<';
    model.modelsense = 'min';
    model.vtype = [repmat('c', [dim,1]); repmat('b', [size(A1,2)-dim, 1])]; 
    model.lb = [-inf*ones(m+n, 1)];
    model.ub = [inf*ones(m+n, 1)];    
    
    params=gurobi_tuning_parameters();
    params.BarIterLimit = 50000;
    params.IntFeasTol = 1e-9; 
    params.FeasibilityTol = 1e-9;
    params.OptimalityTol = 1e-9;

    % Optimize
    result = gurobi(model, params);
    x_opt = result.x;
    io = x_opt(dim+1:end);
    inlier_opt = find(io==0);
    consensus_opt = size(inlier_opt,1);
end