%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MASO Projekt
% VUT, FEKT, KAM
% Zadání: 
% Autoøi: DAVÍDEK D., SLIŽ J., STØÍTEŽSKÝ V.
% Popis: Navázání obrazu z viditelného obrazu a noèního vidìní
% Hlavní skript - volá všechny ostatní
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Legenda
% aby se pøi zkoušení preprocesingových editù (filtry hist) nemuselo
% pokaždé pøidávat vykreslení pro porovnání
% -> udìlal sem cell-array do kterého se postupnì pøidávají obrázky s
% jednotlivými edity (ir_edits{}, vis_edits{})
% -> a druhý cell-array pro postupné pøidávání titlù k obrázkùm aby bylo jasné
% co se tam dìje (tit_IR{}, tit_VIS{})
% ---> 
% Pøi vykreslování se potom vykresluje prostì z cell-array ve for smyèce
% (funkce PLOT_it)

% pro nový edit vložte prosím nìco takového - pøíklad funkce [gray]
%____________________________________________________
% tit = 'gray';
% 
% ir_edit = rgb2gray( ir_edit );
% vis_edit = rgb2gray( vis_edit );
% 
% ir_edits = cat(1, ir_edits, ir_edit); vis_edits = cat(1, vis_edits, vis_edit); 
% tits_IR = cat(1, tits_IR, tit); tits_VIS = cat(1, tits_VIS, tit); 
%____________________________________________________

%* kde xx_edit je pro zøetìzení naplnìn pøedchozím (posledním editovaným)
% obrázkem
%* a kde poslední dva øádky jsou pouze zøetìzený daných cell-arrayù


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: Zaèátek vlastního kódu:

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: Inicializace

close all; clear all; clc;
addpath('fcn_preprocess', 'fcn_imjoin_corr', 'fcn_imjoin_sigPoints');
% ____________________________________________________
global screen_size screen_full;
% [left, bottom, width, height]:
screen_size = get(0,'ScreenSize');
screen_full = [1 1 screen_size(3) screen_size(4)];
global SI SY SX max_im_edits

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: Load
% load images and scale & make subimage from them
max_im = 7; % change as the max image index is in [im] folder
[imIRs, imVISs] = LOAD_SCALE_SUBIMAGE_all_images(max_im);
% imIRs = cell-array se všemi obrázky ze složky <<<<<<<<<<<<<<<

% a teï dál si vybereme 1 obrázek <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%% the rest of first insert into xx_edits cell-array
% on which from all the loaded images to do the edits
index_im = 1;
% dobrý obrázky - zmenšený a potoèený trošièku
% 1 4 6
% lehký jsou
% 3 5 7
% neostrý
% 2

% cell array of all titles to all image edits
tits_IR = {}; 
tits_VIS = {};

%____________________________________________________
% first edit is original image 

% cell arrays of all image edits
ir_edits = {imIRs{index_im}};
vis_edits = {imVISs{index_im}};

% last ir_edit (one image) is this firts edit
ir_edit = ir_edits{1};
vis_edit = vis_edits{1};

% add next title
tit = 'orig';
tits_IR = cat(1, tits_IR, tit); tits_VIS = cat(1, tits_VIS, tit); 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: Preprocess images

%%
tit = 'gray';

ir_edit = rgb2gray( ir_edit );
vis_edit = rgb2gray( vis_edit );

% add last edit & title
ir_edits = cat(1, ir_edits, ir_edit); vis_edits = cat(1, vis_edits, vis_edit); 
tits_IR = cat(1, tits_IR, tit); tits_VIS = cat(1, tits_VIS, tit); 
%%
tit = 'equalized histogram';

ir_edit = histeq( ir_edit );
vis_edit = histeq( vis_edit );

ir_edits = cat(1, ir_edits, ir_edit); vis_edits = cat(1, vis_edits, vis_edit); 
tits_IR = cat(1, tits_IR, tit); tits_VIS = cat(1, tits_VIS, tit); 
%%
tit = 'median filter';
% good is 100
coef = 100;

s = ceil(max(size(ir_edit))/coef);
siz = [s,s];
ir_edit = medfilt2( ir_edit, siz );

s = ceil(max(size(vis_edit))/coef);
siz = [s,s];
vis_edit = medfilt2( vis_edit, siz);

ir_edits = cat(1, ir_edits, ir_edit); vis_edits = cat(1, vis_edits, vis_edit); 
tits_IR = cat(1, tits_IR, tit); tits_VIS = cat(1, tits_VIS, tit); 

%%
tit = 'gauss';

type = tit;
coef = 50;

s = ceil(max(size(ir_edit))/coef);
h = fspecial(type, [s,s]);
ir_edit = imfilter( ir_edit, h );

s = ceil(max(size(vis_edit))/coef);
h = fspecial(type, [s,s]);
vis_edit = imfilter( vis_edit, h );

ir_edits = cat(1, ir_edits, ir_edit); vis_edits = cat(1, vis_edits, vis_edit); 
tits_IR = cat(1, tits_IR, tit); tits_VIS = cat(1, tits_VIS, tit); 

%%
% tit = 'sobel';
% 
% type = tit;
% 
% % s = ceil(max(size(ir_edit))/100);
% % siz = [s,s];
% h = fspecial(type);
% im_double = im2double(ir_edit);
% horiz = imfilter( im_double, h );
% verti = imfilter( im_double, h' );
% ir_edit = sqrt(horiz.^2 + verti.^2);
% 
% % s = ceil(max(size(vis_edit))/100);
% % siz = [s,s];
% h = fspecial(type);
% im_double = im2double(vis_edit);
% horiz = imfilter( im_double, h );
% verti = imfilter( im_double, h' );
% vis_edit = sqrt(horiz.^2 + verti.^2);
% 
% 
% ir_edits = cat(1, ir_edits, ir_edit); vis_edits = cat(1, vis_edits, vis_edit); 
% tits_IR = cat(1, tits_IR, tit); tits_VIS = cat(1, tits_VIS, tit); 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: PLOTTING
max_IR = length(ir_edits);
max_VIS = length(vis_edits);

if max_IR < max_VIS
    max_im_edits = max_VIS;
else
    max_im_edits = max_IR;
end

txt = 'IR & VIS';
figure('Name',txt,'Position',screen_full); 
SI=0; SY=2; SX=max_im_edits;

% ____________________________________________________
% IR
PLOT_it('IR->', tits_IR, ir_edits);
% VIS
PLOT_it('VIS->', tits_VIS, vis_edits);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the final duo after preprocessing
ir_final = ir_edit;
vis_final = vis_edit;

txt = 'IR & VIS after preprocessing';
figure('Name',txt,'Position',screen_full); 
SI=0; SY=1; SX=2; 

%% IR
    im = ir_final;
    tit = 'IR preprocessed';
    SI=SI+1; subplot(SY,SX,SI);
    imshow(im,[]); title(tit);
%% VIS
    im = vis_final;
    tit = 'VIS preprocessed';
    SI=SI+1; subplot(SY,SX,SI);
    imshow(im,[]); title(tit);
   
% for printing the plots before calculation
drawnow

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: JOIN the images
prescale = 0.3;
i1 = imresize(im2double(ir_final),prescale);
v1 = imresize(im2double(vis_final),prescale);
%% plot
if prescale ~= 1;
    txt = sprintf('IR & VIS prescaled by [%.2]- for quicker execution',prescale);
    figure('Name',txt,'Position',screen_full); 
    SI=0; SY=1; SX=2; 

    %% IR
        im = ir_final;
        tit = 'IR prescaled';
        SI=SI+1; subplot(SY,SX,SI);
        imshow(im,[]); title(tit);
    %% VIS
        im = vis_final;
        tit = 'VIS prescaled';
        SI=SI+1; subplot(SY,SX,SI);
        imshow(im,[]); title(tit);

    drawnow
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: korelacni metoda
method_type = 'correlation method';
% využitá výpoèetní jednotka
% method = 'GPU';
method = 'CPU';

% interval a krok zkoušených mìøítek
mins = 0.5;
maxs = 2.5;
% number of scales iterations
nums = 5;
scale = linspace(mins, maxs, nums);
% scale = 0.5:0.1:2.5;
% scale = 1.8:0.1:2.2;
% scael = 1:0.05:1.5;

% vlastní výpoèet
[im_joined, x, y, scale] = imjoin_corr(v1, i1, scale, method);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: PLOTTING

txt = strcat('IR & VIS joined by [',method_type,']');
figure('Name',txt,'Position',screen_full); 
SI=0; SY=1; SX=2; 

tit = strcat('Optimal parameters of joinment: scale[',...
    num2str(scale),'], x=[',num2str(x),'], y=[',num2str(y),']');
imshow(im_joined,[]);
title(tit);


%% do budoucna?
% pøepoèet parametrù tak aby byli aplikovatelné na neoøíznuté obrázky
