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
n = size(points1,2);
% n2 = size(points2,2);
points1_re = points1;
points2_re = points2;

% points1(isnan(points1))=[];
% if numel(points1,2)~= numel(points1_re)
%     points1 = reshape(points1, [3, numel(points1)/3]);
% end
% 
% points2(isnan(points2))=[];
% if numel(points2,2)~= numel(points2_re)
%     points2 = reshape(points2, [3, numel(points2)/3]);
% end

Q = zeros(2*n, 9);
for i =1:n
    xb = points2_re(1,i);
    yb = points2_re(2,i);
    xa = points1_re(1,i);
    ya = points1_re(2,i);
    if (isnan(xb)||isnan(xa))
        alpha = [NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN];
        beta = alpha;
    else
        alpha = [xb,yb,1,0,0,0,-xb*xa, -yb*xa,-xa];
        beta = [0,0,0,xb,yb,1,-xb*ya,-yb*ya,-ya];
    end
    Q(i,:)=alpha;
    Q(i+n,:) = beta;
end

if sum(isnan(Q(:)))
    Q(isnan(Q))=[];
    Q = reshape(Q, [numel(Q)/9,9]);
end


[U, S, V] = svd(Q);
h = V(:,end);
H = reshape(h,[3,3])';


end