function [ ima, imb, outX, outY, outScale ] = imjoin( im1, im2, scale, method)
%IMJOIN - Do obrazu Im1 je vlozen Im2 na nejvhodnejsi pozici, 
% vyuziva se korelace hranovych obrazu
%   scale - vektor meritek obrazu Im2, ktera se budou testovat
%   method - je-li zvolena metoda 'GPU' pouzije se pro vypocet korelace graficka karta
%   !!vypocet muze byt pri vetsich obrazech velmi zdlouhavy!!


imax = length(scale);

%% hranova detakce - pomoci sobelova operatoru
Im1Edg = im_edges(im1,0.1);
Im2Edg = im_edges(im2,0.1);

f = fspecial('sobel');
%% waitbar
waitbar_prc = @(i) (i-1)/imax*100;
waitbar_txt = @(i) sprintf('Joining images [%.2f]%% done, current scale [%.2f]',...
    waitbar_prc(i), scale(i));

wb = waitbar(0,'Joining images [0]% done');

tim = zeros(1,imax);

%% cyklus pres vsechna zadana meritka
for i = 1:imax
    
    wb = waitbar(waitbar_prc(i)/100, wb, waitbar_txt(i));
    disp(sprintf('%i/%i', i,imax));
    disp(waitbar_txt(i));
    
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
    tim(i) = toc;
    
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
    
    tim_mean = mean(tim(1:i));
%     tim_end_in = (imax - i) * tim_mean ;
    tim_end_in = (imax - i) * tim(i) * 10; % nejak to neodpovida.. neva
    txt = sprintf('\t[%.0f]s - this scale calculation time\n\t[%.0f]s - estimated end in\n\t[%.0f]s - mean time of one scale calculation', ...
        tim(i), tim_end_in, tim_mean);
%     txt1 = strcat('Took [', num2str(tim(i)), ']seconds. ',...
%         '\n\tEstimated end in [', num2str(tim_end_in), ']seconds. ',...
%         '\n\tMean time of one scale calculation [', num2str(tim_mean), ']seconds. ');
    disp(txt);
end

%% end waitbar
close(wb)
tim_all = sum(tim);
txt = sprintf('All [%i] scales computation took [%.2f] seconds alltogether',...
    imax, tim_all);
disp(txt);

%% hledani maxima
[maxVal maxAtScale] = max(C,[],3);
[m n] = max(maxVal(:));
[ch cw] = size(maxVal);
x = floor(n/ch)+1;
y = n - (x-1)*ch;
outX = x;
outY = y;

%% vysledny obraz im2
Im2Scale = scale(maxAtScale(y,x));
outScale = Im2Scale;
im2_rescaled = imresize(im2,Im2Scale);

[i1h, i1w] = size(im1);
[i2h, i2w] = size(im2_rescaled);

%% kombinace obrazu

% "paper" offset
[yoff_pap, xoff_pap] = size(im1);
imzero = zeros(3*size(im1));

ima = imzero;
imb = imzero;

ima( (1+yoff_pap):(yoff_pap+i1h), (1+xoff_pap):(xoff_pap+i1w) ) = im1;

y2half = floor(i2h/2);
x2half = floor(i2w/2);

yoff = y - y2half;
xoff = x - x2half;
imb( ...
(yoff_pap + yoff) : (yoff_pap + yoff + i2h-1), ...
(xoff_pap + xoff) : (xoff_pap + xoff + i2w-1) ...
    ) = im2_rescaled;

% cut the edges
%____________________________________________________
% image a
imout = ima;

% bottom
if (yoff+i2h)>i1h
    imout = imout( 1:(yoff_pap+i2h+yoff ), : );
else
    imout = imout( 1:(yoff_pap+i1h), :);
end
% right
if (xoff+i2w)>i1w
    imout = imout( :, 1:(xoff_pap+i2w+xoff ) );
else
    imout = imout( :, 1:(xoff_pap+i1w));
end
% left
if xoff<0
    imout = imout( :, (xoff_pap+x-x2half):end );
else
    imout = imout( :, (1+xoff_pap):end);
end
% up
if (y-y2half)<0
    imout = imout( (yoff_pap+y-y2half):end ,: );
else
    imout = imout( (1+yoff_pap):end, :);
end
ima = imout;

% ____________________________________________________
% image b
imout = imb;
% bottom
if (yoff+i2h)>i1h
    imout = imout( 1:(yoff_pap+i2h+yoff ), : );
else
    imout = imout( 1:(yoff_pap+i1h), :);
end
% right
if (xoff+i2w)>i1w
    imout = imout( :, 1:(xoff_pap+i2w+xoff ) );
else
    imout = imout( :, 1:(xoff_pap+i1w));
end
% left
if xoff<0
    imout = imout( :, (xoff_pap+x-x2half):end );
else
    imout = imout( :, (1+xoff_pap):end);
end
% up
if (y-y2half)<0
    imout = imout( (yoff_pap+y-y2half):end ,: );
else
    imout = imout( (1+yoff_pap):end, :);
end
imb = imout;
 
end

