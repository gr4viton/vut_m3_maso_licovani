function [ ima, imb ] = imjoin_sigPoints( imVIS, imIR)
%IMJOIN_SIGPOINTS Spojí obrazy na základì metody porovnávání vüznaèných bodù
%   imIR - pøedzpracovaný obraz v infraèervené oblasti
%   imVIS - pøedzpracovaný obraz ve viditelné oblasti

% Hledáme umístìní menšího obrazu v tom vìtším
if size(imIR, 1) < size(imVIS, 1)
    imSmall = imIR;
    imLarge = imVIS;
else 
    imSmall = imVIS;
    imLarge = imIR;
end

%% Srovnání na základì významných bodù
% Nalézt významné body
ptsOriginal = detectSURFFeatures(imLarge);
ptsDistorted = detectSURFFeatures(imSmall);

%% Vykreslit nalezené body
% figure
% imshow(imLarge); hold on;
% plot(ptsOriginal);
% figure
% imshow(imSmall); hold on;
% plot(ptsDistortedStrong);

%% Extrakce pøíznakù významných bodù
[featuresOriginal,  validPtsOriginal]  = extractFeatures(imLarge,ptsOriginal);
[featuresDistorted, validPtsDistorted] = extractFeatures(imSmall,ptsDistorted);
%% Nalézt shodné páry
indexPairs = matchFeatures(featuresOriginal, featuresDistorted, 'Method', 'NearestNeighborSymmetric');
matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));

%% zobrazit všechny nalezené páry
figure
showMatchedFeatures(imLarge,imSmall,matchedOriginal,matchedDistorted)
title('Putatively matched points (including outliers)')
legend('ptsOriginal','ptsDistorted')

%% Vypoèítat geometrickou transformaci 
% na základì nalezených párù významných bodù v obou obrazech
[tform, inlierDistorted, inlierOriginal] = ...
    estimateGeometricTransform(matchedDistorted,matchedOriginal, 'affine');
figure
showMatchedFeatures(imLarge,imSmall,inlierOriginal,inlierDistorted)
title('Matching points (inliers only)')
legend('ptsOriginal','ptsDistorted')

%% Zobrazit výsledné umístìní menšího obrazu ve vìtším
outputView = imref2d(size(imVIS));
recovered  = imwarp(imIR,tform,'OutputView',outputView);


% figure
% imshowpair(imVIS,recovered)  
ima = imVIS
imb = recovered


end

