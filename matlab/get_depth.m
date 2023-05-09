function depthM = get_depth(dispM, K1, K2, R1, R2, t1, t2)
% GET_DEPTH creates a depth map from a disparity map (DISPM).

% compute distance between the optical centers of the cameras
c1 = -inv(K1 * R1) * K1 * t1;
c2 = -inv(K2 * R2) * K2 * t2;
b = norm(c1 - c2);

% compute focal length of the camera
f = K1(1, 1);

% compute depth map
depthM = b * f ./ dispM;

% set depth to 0 where disparity == 0
depthM(dispM == 0) = 0;
end