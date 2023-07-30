function [hOpt, max_res, B, gamma] = linf_homo(A,b,c,d,h_init)

     optmincon = optimoptions(@fmincon,'Algorithm','sqp', 'MaxIter', 10000,...
       'MaxFunctionEvaluations',20000,'ConstraintTolerance', 1e-9, 'FunctionTolerance', 1e-9,'OptimalityTolerance', 1e-9,'StepTolerance', 1e-9, 'TolConSQP', 1e-9); 
     optmincon = optimoptions(optmincon,'Display', 'off', 'Diagnostics', 'off');
    


     % initialise solution
     xInit = [ h_init; 50];
     p = size(h_init,1);
     
     % set lb/ub
     options.lb = [-100*ones(1,p),1e-4];
     options.ub = [ 100*ones(1,p),100];     
     
     xOpt = fmincon(@obj_fmincon, xInit, [], [], [], [], options.lb, options.ub, @constraints, optmincon);
     gamma = xOpt(end);
     res = eval_residual(xOpt);
     
     B = find(abs(res-max(res))< 1e-4);
     hOpt = xOpt(1:p);
     max_res = max(res(B));
     
% -------------------------------------------------------------------------

        function f = obj_fmincon(x)
            f = x(end);  
        end
    
% -------------------------------------------------------------------------    

        function [cnstr_ineq,cnstr_eq]  = constraints(x)           
            cnstr_ineq = resPseudoConv(A,b,c,d,x);   %c(x)<=0
            cnstr_eq = [];                           %c(x)=0
        end
    
% -------------------------------------------------------------------------    
    
        function resn = eval_residual(x) 
            dim1 = size(A,1)/numel(d);
            AxPb = reshape(A*x(1:end-1),dim1, numel(d))+b;
            Sqrt_AxPb = sqrt(sum(AxPb.^2,1));
            CxPd = (x(1:end-1)'*c + d)+eps;
            resn = zeros(1, dim1);
            resn = Sqrt_AxPb./CxPd;
        end
% -------------------------------------------------------------------------    
end