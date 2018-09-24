% H = compute_homography(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input:  points1, points2 are of the form (3,n) with 
%         n is the number of points.
%         The points should be normalized for 
%         better performance.
% 
% Output: H 3x3 matrix 
%

function H = compute_homography( points1, points2 )

%-------------------------
% TODO: FILL IN THIS PART

n_ori2 = size(points2,2);
points2(isnan(points2))=[];
if n_ori2~=size(points2,2)
    points2 = reshape(points2, [3,fix(size(points2,2)/3)]);
end

% n_ori1 = size(points1,2);
% points1(isnan(points1))=[];
% if n_ori1~=size(points1,2)
%     points1 = reshape(points1, [3,fix(size(points1,2)/3)]);
% end

n = min(size(points1,2),size(points2,2)) ;
Q = zeros(2*n, 9);
for i =1:n
    xb = points1(1,i);
    yb = points1(2,i);
    xa = points2(1,i);
    ya = points2(2,i);
    
    alpha = [xb,yb,1,0,0,0,-xb*xa, -yb*xa,-xa];
    beta = [0,0,0,xb,yb,1,-xb*ya,-yb*ya,-ya];
    Q(i,:)=alpha;
    Q(i+n,:) = beta;
end
[U, S, V] = svd(Q);
h = V(:,end);
H = reshape(h,[3,3])';


end