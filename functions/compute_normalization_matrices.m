% Method:   compute all normalization matrices.  
%           It is: point_norm = norm_matrix * point. The norm_points 
%           have centroid 0 and average distance = sqrt(2))
% 
%           Let N be the number of points and C the number of cameras.
%
% Input:    points2d is a 3xNxC array. Stores un-normalized homogeneous
%           coordinates for points in 2D. The data may have NaN values.
%        
% Output:   norm_mat is a 3x3xC array. Stores the normalization matrices
%           for all cameras, i.e. norm_mat(:,:,c) is the normalization
%           matrix for camera c.

function norm_mat = compute_normalization_matrices( points2d )

%-------------------------
% TODO: FILL IN THIS PART

[~,N,C] = size(points2d);
norm_mat = zeros(3,3,C);
for c =1:C
    points2di = points2d(:,:,c);
    if sum(isnan(points2di(:)))
       points2di(isnan(points2di))=[]; 
       points2di = reshape(points2di, [3,fix(size(points2di,2)/3)]);
    end
    pc = mean(points2di,2);
    dc = sum( sqrt(sum((points2di-pc).^2)))/size(points2di,2);
%     dc1=0;
%     for j=1:size(points2di,2)
%         dc1 = dc1 + norm(points2di(:,j)-pc);
%     end
%     dc1 = dc1/size(points2di,2);
    norm_mat(:,:,c)= (sqrt(2)/dc) * [1, 0, -pc(1);0, 1, -pc(2); 0, 0, dc/sqrt(2)];
end

end


