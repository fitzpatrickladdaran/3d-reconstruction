function F = eightpoint(pts1, pts2)

% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'

% reference: https://www5.cs.fau.de/fileadmin/lectures/2014s/Lecture.2014s.IMIP/exercises/4/exercise4.pdf

% calculate means
mu1 = mean(pts1, 1);
mu2 = mean(pts2, 1);

% shift coordinates to origin
pts1= pts1 - mu1;
pts2 = pts2 - mu2;

% calculate the average distance from the centroid
avg_dist1 = mean(sqrt(sum(pts1.^2, 2)));
avg_dist2 = mean(sqrt(sum(pts2.^2, 2)));

% scale coordinates to have unit average distance from origin
scale1 = sqrt(2) / avg_dist1;
scale2 = sqrt(2) / avg_dist2;
T1 = [scale1, 0, -scale1 * mu1(1); 
      0, scale1, -scale1 * mu1(2); 
      0, 0, 1];
T2 = [scale2, 0, -scale2 * mu2(1); 
      0, scale2, -scale2 * mu2(2); 
      0, 0, 1];

% convert to homogeneous coordinates
pts1 = [pts1, ones(size(pts1, 1), 1)];
pts2 = [pts2, ones(size(pts2, 1), 1)];

% calculate normalized coordinates
pts1 = (T1 * pts1')';
pts2 = (T2 * pts2')';

% construct A matrix
N = size(pts1, 1);
A = zeros(N, 9);
for i = 1:N
    x = pts1(i, 1);
    y = pts1(i, 2);
    xprime = pts2(i, 1);
    yprime = pts2(i, 2);
    A(i,:) = [x * xprime, x * yprime, x, ...
              y * xprime, y * yprime, y, ...
              xprime, yprime, 1];
end

% initial estimate F
[~, ~, V] = svd(A);
F = reshape(V(:, end), [3, 3])';

% enforce rank-2 constraint
[U, S, V] = svd(F);
S(3, 3) = 0;
F = U * S * V';

% refine F
F = refineF(F, pts1(:, 1:2), pts2(:, 1:2));

% denormalize F
F = T2' * F * T1;

end