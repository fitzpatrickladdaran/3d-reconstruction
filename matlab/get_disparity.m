function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.

    [h, w] = size(im1);
    dispM = zeros(h, w);

    half_window = floor(windowSize / 2);

    % pad images to handle border pixels
    im1 = padarray(im1, [half_window, half_window], 'replicate');
    im2 = padarray(im2, [half_window, half_window], 'replicate');

    for row = half_window + 1 : h + half_window
        for col = half_window + 1 : w + half_window
            bestScore = Inf;
            bestDisp = 0;

            % for each disparity value, compute score and keep best one
            for disp = 0 : maxDisp-1
                if col + disp + half_window > w + half_window
                    break;
                end
                
                % compute sum of squared differences (SSD) for current window
                diff = im1(row - half_window : row + half_window, col - half_window : col + half_window) - ...
                       im2(row - half_window : row + half_window, col + disp - half_window : col + disp + half_window);
                score = sum(diff(:).^2);

                if score < bestScore
                    bestScore = score;
                    bestDisp = disp;
                end
            end

            % store best disparity value in output disparity map
            dispM(row - half_window, col - half_window) = bestDisp;
        end
    end

end
