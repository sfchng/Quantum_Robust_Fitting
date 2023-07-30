clear; clc;

% path
dataset_path = '/Users/shinfang/Documents/PhD/Boolean_Function/MVG/Homography_P/data/groundtruth/';
dataset_name = 'keble';

load (strcat(dataset_path, dataset_name, '.mat'));


N=17;
result_path_v1 =strcat('/Users/shinfang/Documents/PhD/Boolean_Function/MVG/Homography_P/result_',num2str(N),'/');
%load (strcat(result_path_v1,'keble_result_',num2str(N),'.mat'));
load (strcat(result_path_v1,'keble_result.mat'));

% compute residual values using groundtruth Homography
H_gt = data.H;
H_gt = H_gt/norm(H_gt);
for i=1:size(xB,2)
    a1 = H_gt(1:2,:)*xA(1:3,i);
    b1 = H_gt(3,:)*xA(1:3,i);
    A = a1/b1;
    res(i) = norm(A-xB(1:2,i));
end


for i=1:size(violation_cnt,1)
    influence(i) = violation_cnt(i)/total_samples(i);
end

den = max(influence)-min(influence);

for i=1:size(influence,2)
   influence_n(i) = (influence(1,i)-min(influence) )/den;
end

% sort influence
[iv, ia]=sort(influence,'descend');
[iv_n, ia_n] = sort(influence_n, 'descend');

% find the location of true outlier
[~,iloc]=ismember(subsampled_olrs_ind, subsampled_ind);

% find the sorted location of true outlier
sorted_iloc = [];
for i=1:size(subsampled_olrs_ind,2)
    aa = find(iloc(i) == ia_n);
    sorted_iloc = [sorted_iloc; aa];
end

%% Plot
% -----------------------------------------------------------------------
% influence
figure;
hold on;
plot(iv_n, 'b^');
plot(sorted_iloc, iv_n(sorted_iloc), 'b^', 'MarkerFaceColor', 'g');
title('Exact Influence of each measurement');
xlabel('Point Index'); ylabel('Influence');
hold off;
set(gcf, 'color','w');
%saveas(gcf,strcat(result_path_v1,'Exact_Influence_Function.png'));

figure;

olrs = [];
for i=1:size(subsampled_ind,2)
    LIA = ismember(subsampled_ind(i), subsampled_olrs_ind);
    if LIA == 1
        olrs = [olrs; i];
    end
end
assert(isequal(subsampled_ind(olrs) , sort(subsampled_olrs_ind)));
inlrs = 1:N;
inlrs(olrs)=[];
plot_match(subsampled_data.matches, X, inlrs,1, 1000); 








