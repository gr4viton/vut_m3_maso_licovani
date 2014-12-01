function [ output_args ] = PLOT_it( prefix_tit, tits, im_edits )
%PLOT_IT Summary of this function goes here
%   Detailed explanation goes here
global SI SY SX max_im_edits

% n_im = length(im_edits);

for q = 1:max_im_edits
    im = im_edits{q};
    tit = strcat(prefix_tit, tits{q});
    SI=SI+1; subplot(SY,SX,SI);
    imshow(im,[]); title(tit);
end
end

