function [ ima, imb ] = imjoin_sigPoints( imVIS, imIR)
%IMJOIN_SIGPOINTS Spoj� obrazy na z�klad� metody porovn�v�n� v�zna�n�ch bod�
%   imIR - p�edzpracovan� obraz v infra�erven� oblasti
%   imVIS - p�edzpracovan� obraz ve viditeln� oblasti

% Hled�me um�st�n� men��ho obrazu v tom v�t��m
if size(imIR, 1) < size(imVIS, 1)
    imSmall = imIR;
    imLarge = imVIS;
else 
    imSmall = imVIS;
    imLarge = imIR;
end

%% Srovn�n� na z�klad� v�znamn�ch bod�
% Nal�zt v�znamn� body
ptsOriginal = detectSURFFeatures(imLarge);
ptsDistorted = detectSURFFeatures(imSmall);

%% Vykreslit nalezen� body
% figure
% imshow(imLarge); hold on;
% plot(ptsOriginal);
% figure
% imshow(imSmall); hold on;
% plot(ptsDistortedStrong);

%% Extrakce p��znak� v�znamn�ch bod�
[featuresOriginal,  validPtsOriginal]  = extractFeatures(imLarge,ptsOriginal);
[featuresDistorted, validPtsDistorted] = extractFeatures(imSmall,ptsDistorted);
%% Nal�zt shodn� p�ry
indexPairs = matchFeatures(featuresOriginal, featuresDistorted, 'Method', 'NearestNeighborSymmetric');
matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));

%% zobrazit v�echny nalezen� p�ry
figure
showMatchedFeatures(imLarge,imSmall,matchedOriginal,matchedDistorted)
title('Putatively matched points (including outliers)')
legend('ptsOriginal','ptsDistorted')

%% Vypo��tat geometrickou transformaci 
% na z�klad� nalezen�ch p�r� v�znamn�ch bod� v obou obrazech
[tform, inlierDistorted, inlierOriginal] = ...
    estimateGeometricTransform(matchedDistorted,matchedOriginal, 'affine');
figure
showMatchedFeatures(imLarge,imSmall,inlierOriginal,inlierDistorted)
title('Matching points (inliers only)')
legend('ptsOriginal','ptsDistorted')

%% Zobrazit v�sledn� um�st�n� men��ho obrazu ve v�t��m
outputView = imref2d(size(imVIS));
recovered  = imwarp(imIR,tform,'OutputView',outputView);


% figure
% imshowpair(imVIS,recovered)  
ima = imVIS
imb = recovered


end

