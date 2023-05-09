function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]
 
N = size(x, 2);
A = [];

% create A matrix
for i = 1:N
    px = x(1, i);
    py = x(2, i);
    A = [A;
         X(:, i).', 1, 0, 0, 0, 0, -px * [X(:, i).', 1];
         0, 0, 0, 0, X(:, i).', 1, -py * [X(:, i).', 1]];
end

% svd
[~, ~, v] = svd(A);
P = v(:, size(v, 2));
P = reshape(P, 4, 3)';
end