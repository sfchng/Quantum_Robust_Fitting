%-----------------------
% Plot keypoint matches.
%-----------------------
function plot_match_sf(a, X, inliers, flg)

N = size(X, 2); 
outliers_v = 1:N; 
outliers_v(inliers) = []; 
outliers = outliers_v;

im1 = a.im1;
im2 = a.im2;

dh1 = max(size(im2,1)-size(im1,1),0);
dh2 = max(size(im1,1)-size(im2,1),0);

if flg==1

    imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]); hold on;
    o = size(im1,2);
    %plot(a.X1(1, :),a.X1(2, :),'+b', 'MarkerSize',10, 'linewidth', 1.2); 
    %plot(a.X2(1, :)+o,a.X2(2, :),'+y', 'MarkerSize',10, 'linewidth', 1.2);
    
    %line([X(1,inliers);X(4,inliers)+o], [X(2,inliers);X(5,inliers)], 'color', 'g');
    
    plot(a.X1(1, inliers),a.X1(2, inliers),'+b', 'MarkerSize',5, 'linewidth', 1.2);
    %plot(a.X1(1, outliers),a.X1(2, outliers),'+r', 'MarkerSize',10, 'linewidth', 1.2); 
    plot(a.X2(1, inliers)+o,a.X2(2, inliers),'+b', 'MarkerSize',5, 'linewidth', 1.2);    
    %plot(a.X2(1, outliers)+o,a.X2(2, outliers),'+r', 'MarkerSize',10, 'linewidth', 1.2);
    line([X(1,inliers);X(4,inliers)+o], [X(2,inliers);X(5,inliers)], 'color', 'b');
    %line([X(1,outliers);X(4,outliers)+o], [X(2,outliers);X(5,outliers)], 'color', 'r');

    axis image off;
    drawnow;
    
end
if flg ==0
    imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]); hold on;
    o = size(im1,2);
    %plot(a.X1(1, :),a.X1(2, :),'+b', 'MarkerSize',10, 'linewidth', 1.2); 
    %plot(a.X2(1, :)+o,a.X2(2, :),'+y', 'MarkerSize',10, 'linewidth', 1.2);
    
    %line([X(1,inliers);X(4,inliers)+o], [X(2,inliers);X(5,inliers)], 'color', 'g');
    
    %plot(a.X1(1, inliers),a.X1(2, inliers),'+b', 'MarkerSize',10, 'linewidth', 1.2);
    plot(a.X1(1, outliers),a.X1(2, outliers),'+r', 'MarkerSize',5, 'linewidth', 1.2); 
    %plot(a.X2(1, inliers)+o,a.X2(2, inliers),'+b', 'MarkerSize',10, 'linewidth', 1.2);    
    plot(a.X2(1, outliers)+o,a.X2(2, outliers),'+r', 'MarkerSize',5, 'linewidth', 1.2);
    %line([X(1,inliers);X(4,inliers)+o], [X(2,inliers);X(5,inliers)], 'color', 'b');
    line([X(1,outliers);X(4,outliers)+o], [X(2,outliers);X(5,outliers)], 'color', 'r');

    axis image off;
    drawnow;
end
end
