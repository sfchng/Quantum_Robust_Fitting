function [u, outlier_flag]=generate_outliers_homo(u,num_outliers,outlier_sigma,N_pts, N_views)

 outlier_ind = randsample(N_pts, num_outliers);
 outlier_ind = sort(outlier_ind);
 outlier_flag = zeros(N_pts,1);
 outlier_flag(outlier_ind) = 1;
 for k=1:N_pts
     if outlier_flag(k,1) == 1
         % perturb with noise
         u{1}(:,k) = u{1}(:,k)+outlier_sigma*randn(2,1);
     end
 end
end