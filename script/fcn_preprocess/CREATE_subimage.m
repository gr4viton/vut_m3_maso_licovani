function [ imout ] = CREATE_subimage( im, range)
%CREATE_SUBIMAGE - from input image based on range input
%   Subimage

% [x1,y1; x2,y2]
x1 = range(1,1);
y1 = range(1,2);
x2 = range(2,1);
y2 = range(2,2);

imout = im(y1:y2, x1:x2,:);
% range
% figure
% imshow(imout,[])
% size(im)
% size(imout)
%     figure
%     subplot(211);
%     imshow(im);
%     subplot(212);
%     imshow(imout);
    
end

