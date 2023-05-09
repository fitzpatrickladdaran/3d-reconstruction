clear all ;

% load image and parameters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
load('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');
maxDisp = 20; 
windowSize = 3;

% before rectification...

% get disparity map
dispM = get_disparity(im1, im2, maxDisp, windowSize);

% get depth map
depthM = get_depth(dispM, K1n, K2n, R1n, R2n, t1n, t2n);

% display 
figure; imagesc(dispM.*(im1>40)); colormap(gray); axis image;
figure; imagesc(depthM.*(im1>40)); colormap(gray); axis image;

% ----------------------------------------------------------------- %

% after rectification...
[M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = rectify_pair(K1n, K2n, R1n, R2n, t1n, t2n);
[JL, JR, bbL, bbR] = warp_stereo(im1, im2, M1, M2) ;

% get disparity map
dispM_r = get_disparity(JL, JR, maxDisp, windowSize);

% get depth map
depthM_r = get_depth(dispM_r, K1n, K2n, R1n, R2n, t1n, t2n);

% display
figure; imagesc(dispM_r .* (JL > 40)); colormap(gray); axis image;
figure; imagesc(depthM_r .* (JL > 40)); colormap(gray); axis image;