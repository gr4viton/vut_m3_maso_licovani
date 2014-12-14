function [ out ] = im_edges( image, saturation )
%IM_EDGES Summary of this function goes here
%   upravena detakce hran
%   saturation udava jaka cast obrazu ma byt saturovana (obvykle 5-10%)

% hranovy operator
f = fspecial('sobel');

% normalizace
image = image - min(image(:));
image = image / max(image(:));

% vypocet intenzity hran - nelinearni
out = (imfilter(image,f','symmetric')).^2 + (imfilter(image,f,'symmetric')).^2; 

%normalizace
out = out - min(out(:));
out = out / max(out(:));

% vypocet kumulovaneho histogramu
CHist = cumsum(imhist(out));
% nalezeni pozadovaneho prahu saturace
Tresh = length(CHist(CHist(:) < (1-saturation)*length(out(:))))/length(CHist(:));

% aplikace saturacniho prahu
out(out(:) > Tresh(1)) = Tresh(1);
out = out / Tresh(1);
out = out - 0.1; % maly posun pod nulu - kvuli koralaci

end

