function [u, outlier_flag]=generate_outliers_v1(u,num_outliers,outlier_sigma,N_pts, N_views)

 outlier_flag = zeros(N_pts,num_outliers);
 for k = 1:N_pts
    i=0;
    outlier_ind = [];     
  while i < num_outliers  
     r = randi(N_views);     
     if ismember(r, outlier_ind)
        continue;
     else
         u{r}(:,k)= u{r}(:,k)+ outlier_sigma*randn(2,1);
         outlier_flag(k,i+1) = r;
         i=i+1;
     end
     outlier_ind = [outlier_ind; r];    
  end
 end
  
   






end