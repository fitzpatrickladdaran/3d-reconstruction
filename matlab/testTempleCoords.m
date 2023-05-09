load('../data/someCorresp.mat');

% step 1: load both images% step 1: load both images
img1 = imread('../data/im1.png');
img2 = imread('../data/im1.png');

% step 2: run eightpoint to compute F
F = eightpoint(pts1, pts2);

% step 3: load points in image1 contained in templateCoords.mat,
%         then run epipolarCorrespondences
load('../data/templeCoords.mat');
pts2 = zeros(size(pts1));
for i = 1:size(pts1, 1)
    pts2(i, :) = epipolarCorrespondence(img1, img2, F, pts1(i, :));
end

% step 4: load intrinsics.mat and compute E
load('../data/intrinsics.mat');
E = essentialMatrix(F, K1, K2);

% step 5: compute P1, and compute the four candidates for P2 using
%         camera2.m
P1 = K1 * [eye(3), zeros(3, 1)];
P2 = camera2(E);
least_cost = 1e10;

% step 6: for each candidate, run triangulate function 
counter = size(pts1, 1);
for i = 1:size(P2, 3)
    P2(:, :, i) = K2 * P2(:, :, i);    
    pts3d = triangulate(P1, pts1, P2(:, :, i), pts2);

    % step 7: figure out correct P2 and corresponding 3D points
    neg = sum(pts3d(:, 3) < 0);
    if neg < counter
        counter = neg;
        res = pts3d;
        res_p2 = P2(:, :, i);
    end
end

% step 8: use plot3, and enter 'axis equal'
plot3(res(:, 1), res(:, 2), res(:, 3), 'r.', Color = "red");
axis equal

% step 9: save extrinsic parameters for dense reconstruction
R1 = K1 \ P1(1:3, 1:3);
t1 = K1 \ P1(:, 4);
R2 = K2 \ res_p2(1:3, 1:3);
t2 = K2 \ res_p2(:, 4);
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');