%-----------------------
% Plot keypoint matches.
%-----------------------
function plot_match(a, X, inliers, flg)

N = size(X, 2); 
outliers = 1:N; 
outliers(inliers) = []; 

im1 = a.im1;
im2 = a.im2;

dh1 = max(size(im2,1)-size(im1,1),0);
dh2 = max(size(im1,1)-size(im2,1),0);

if flg
%     subplot(2,1,1)
%     imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]);
%     o = size(im1,2);
%     line([a.X1(1,:);a.X2(1,:)+o], [a.X1(2,:);a.X2(2,:)], 'color', 'g');
%     axis image off;

    subplot(1,1,1)
    imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]); hold on;
    o = size(im1,2);
    plot(a.X1(1, :),a.X1(2, :),'b+', 'MarkerSize',10, 'linewidth', 1.2); 
    plot(a.X2(1, :)+o,a.X2(2, :),'b+', 'MarkerSize',10, 'linewidth', 1.2);
    
    line([X(1,inliers);X(4,inliers)+o], [X(2,inliers);X(5,inliers)], 'color', 'y');
    line([X(1,outliers);X(4,outliers)+o], [X(2,outliers);X(5,outliers)], 'color', 'r');

    axis image off;
    drawnow;
    %title('Putative Pairwise Correspondences between Two Views');
%     hold off; 
else

    imagesc(im2); hold on;
    plot(a.X1(1, :),a.X1(2, :),'+g');
    hl = line([a.X1(1, inliers); a.X2(1, inliers)],[a.X1(2, inliers); a.X2(2, inliers)],'color','y');
    hl = line([a.X1(1, outliers); a.X2(1, outliers)],[a.X1(2, outliers); a.X2(2, outliers)],'color','r');
%     title('Correspondences');
    axis off;
%     hold off; 
end
end
