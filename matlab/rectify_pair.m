function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = ...
                        rectify_pair(K1, K2, R1, R2, t1, t2)
% RECTIFY_PAIR takes left and right camera paramters (K, R, T) and returns left
%   and right rectification matrices (M1, M2) and updated camera parameters. You
%   can test your function using the provided script q4rectify.m

% step 1: compute optical center c1, c2 of each camera 
c1 = -inv(K1 * R1) * K1 * t1;
c2 = -inv(K2 * R2) * K2 * t2;

% step 2: compute new rotation matrix: orthonormal vectors

% compute x-axis: abs(c1 - c2) to keep orientation upright
r1 = abs(c1 - c2) / norm(c1 - c2);

% compute y-axis
r2 = cross(R1(3, :), r1);
r2 = r2 / norm(r2);

% compute z-axis
r3 = cross(r1, r2);

% compute rotation matrix R_tilde
R_tilde = [r1.'; r2; r3];
R1n = R_tilde;
R2n = R_tilde;

% step 3: compute new intrinsic parameter 
K_tilde = K2;
K1n = K_tilde;
K2n = K_tilde;

% step 4: compute new translations
t1n = -R_tilde * c1;
t2n = -R_tilde * c2;

% step 5: compute rectification matrix 
M1 = (K_tilde * R_tilde) * inv(K1 * R1);
M2 = (K_tilde * R_tilde) * inv(K2 * R2);