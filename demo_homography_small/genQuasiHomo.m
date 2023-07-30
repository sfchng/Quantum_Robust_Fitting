function [A, b, c, d] = genQuasiHomo(x1, x2)

    
    num_pts = size(x1,2);
    A = [];
    b = [];
    c = [];
    d = [];
    
    for i=1:num_pts      
       
        xi1 = x1(1,i); xi2 = x1(2,i);
        xj1 = x2(1,i); xj2 = x2(2,i);
        
        ai1 = [ xi1 xi2 1 0 0 0 -xj1*xi1 -xj1*xi2];
        ai2 = [ 0 0 0 xi1 xi2 1 -xj2*xi1 -xj2*xi2];
        
        A = [A; ai1; ai2];
        b = [b [-xj1; -xj2]];
        ci = [0 0 0 0 0 0 xi1 xi2];
        c = [c ci'];
        d = [d 1];
    end
end