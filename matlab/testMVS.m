clear all;
close all;

% Key hyper parameters.
% For a patch of 5x5, set radius to be 2. For a patch of 7x7, set radius to be 3, etc.
patch_radius = 2;
patch_width = 2 * patch_radius + 1;

% Read camera parameters and image data.
data = importdata('../data/templeR_par.txt');
num_images = size(data.data, 1);
num_neighboring_images = num_images - 1;

projection_matrices = zeros(3, 4, num_images);
images = struct('I0', nan, 'I1', nan, 'I2', nan, 'I3', nan, 'I4', nan);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Write code here to set projection_matrices and images %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Compute min_depth and max_depth, by calculating the depths of the 8 grid points and taking their min/max.
% Set depth_step so that we sample depth values properly, which should be around 0.001 - 0.004.
min_depth = 0.0;
max_depth = 0.0;
depth_step = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%
%%% Write code here %%%
%%%%%%%%%%%%%%%%%%%%%%%


% Compute a depthmap for the first image by using the remaining images.
[height, width] = size(images.I0, 1, 2);
depthmap = zeros(height, width);


fileID = fopen('../data/mvs.obj', 'w');

for x = 1 : width
    if mod(x, 10) == 0
       fprintf('x = %d / %d\n', x, width);
    end
    for y = 1 : height
	% A heuristics to skip black pixels that are background.
        if images.I0(y, x, 1) <= 50 || images.I0(y, x, 2) <= 50 || images.I0(y, x, 3) <= 50
            continue
        end

        xyz = [0 0 0];
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Write code here to set depthmap(y, x) and xyz %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        % Saving a point cloud in an OBJ format, which you can open
        % with a software such as MeshLab to visualize.
        fprintf(fileID, 'v %f %f %f\n', xyz(1), xyz(2), xyz(3));	      
    end
end

fclose(fileID);

% This command should show you a depthmap-image like in a hand-out.
imshow(uint8(max(0, depthmap - min_depth) * 255 / (max_depth - min_depth)));
