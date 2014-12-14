function [ out, outX, outY, outScale ] = imjoin( im1, im2, scale, method)
%IMJOIN Summary of this function goes here
%   Do obrazu Im1 je vlozen Im2 na nejvhodnejsi pozici, vyuziva se korelace
%   hranovych obrazu
%   scale je vektor meritek obrazu Im2, ktera se budou testovat
%   je-li zvolena metoda 'GPU' pouzije se pro vypocet korelace graficka karta
%   !!vypocet muze byt pri vetsich obrazech velmi zdlouhavy!!

% hranova detakce - pomoci sobelova operatoru
Im1Edg = im_edges(im1,0.1);
Im2Edg = im_edges(im2,0.1);

f = fspecial('sobel');
  
% cyklus pres vsechna zadana meritka
for i = 1:length(scale)
    %zmena meritka obrazu im2
    Im2Res = imresize(Im2Edg,scale(i));
    tic;
    % vypocet korelace - pomoci GPU/CPU 
    if strcmp(method,'GPU')        
        gpuIm1 = gpuArray(Im1Edg);
        gpuOut = gpuArray(Im1Edg);
        gpuOut = filter2(Im2Res,gpuIm1,'same');
        c = gather(gpuOut);
    else  %CPU    
        c = imfilter(Im1Edg,Im2Res,'same');
    end 
    toc;
    
    % vypocet diferencniho obrazu - odstraneni souvislych ploch
    c2 = sqrt((imfilter(c,f','symmetric')).^2 + (imfilter(c,f,'symmetric')).^2); 
    %filtrace
    c2 = imfilter(c2,fspecial('gaussian',[15 15],0.7));
    %normalizace
    c2 = c2 - min(c2(:));
    c2 = c2 / max(c2(:));
    c = (c .* c2);
    % kompenzace velikosti meritka
    C(:,:,i) = c / mean(c(:));
end

% hledani maxima
[maxVal maxAtScale] = max(C,[],3);
[m n] = max(maxVal(:));
[ch cw] = size(maxVal);
x = floor(n/ch)+1;
y = n - (x-1)*ch;
outX = x;
outY = y;

% vysledny obraz im2
Im2Scale = scale(maxAtScale(y,x));
outScale = Im2Scale;
Im2Rescale = imresize(im2,Im2Scale);
[i2h i2w] = size(Im2Rescale);

% kombinace obrazu
out = im1;
out(y-floor(i2h/2):y+round(i2h/2)-1,x-floor(i2w/2):x+round(i2w/2)-1) = Im2Rescale;

end

