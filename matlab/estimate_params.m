function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.

% step 1: compute camera center 
[~, ~, V] = svd(P);
c = V(:, end);

% step 2: compute K and R using QR decomposition
[Q, R] = qr(inv(P(:, 1:3)));
K = inv(Q);

% step 3: compute translation 
t = -R*c(1:3) / c(4);

end