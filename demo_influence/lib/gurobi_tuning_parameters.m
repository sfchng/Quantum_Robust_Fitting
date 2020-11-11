function params = gurobi_tuning_parameters()

    params.FeasibilityTol = 1e-7;
    params.IntFeasTol = 1e-7;           % only affect MIP model
    params.OptimalityTol = 1e-7;
    params.MarkowitzTol=1e-4;
    params.NormAdjust = 0;
    params.ScaleFlag = 1;
    params.PerturbValue = 0;    
    params.OutputFlag = 0;
    params.Cuts = 0;
    params.PreSolve = 0;
    params.Presolve = 0;
    
    %params.DualReductions=0;
    params.Heuristics=0;                % only affect mip model
    %params.Threads=1;
    %params.LazyConstraints=1;
    params.BarIterLimit = 50000;
    %params.TimeLimit=5;
end