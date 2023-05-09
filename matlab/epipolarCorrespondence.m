function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1 -> 640x480x3
%       im2:    Image 2 -> 640x480x3
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2

% convert to homogeneous coordinates
pts1 = [pts1, ones(size(pts1, 1), 1)];

% compute epipolar line in second image
l_prime = (F * pts1')';

%% generate candidate points along epipolar line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% limits
y_range = size(im2, 1); % 640
x_range = size(im2, 2); % 480

% possible x candidates
x_candidate = 1:x_range; % 1x480, integers from 1 to 480

% possible y candidates -> solve: l_prime(1) * x + l_prime(2) * y + l_prime(3) = 0
% note: rounded because these are pixel values
y_candidate = round((-l_prime(:, 1) .* x_candidate - ...
                     l_prime(:, 3)) ./ l_prime(:, 2));

% check validity of pixel value
valid_indices = (y_candidate > 0) & (y_candidate <= y_range);

% candidate points
x_candidate = x_candidate(valid_indices);
y_candidate = y_candidate(valid_indices);
candidate_points = [x_candidate', y_candidate'];

% compute similarity score, using L2-norm
scores = pdist2(pts1(:, 1:2), candidate_points, 'euclidean');
[~, best_idx] = min(scores);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% obtain epipolar correspondence
pts2 = candidate_points(best_idx, :);