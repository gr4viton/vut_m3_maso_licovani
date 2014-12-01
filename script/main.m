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

%%
% -> šetøí to fakt dost èasu, bo pak už staèí pøi nové "editaci" jenom 
% pøekopírovat starý kód, pøidat tu funkci editace a popisek..
% a ona se pak už automaticky vykreslí

%%
% -> ostatní funkce dejte (tøeba nakonec, až budou hotový) tøeba do složky 
% fcn_licovani nebo jinak (ale pak ji pøidejte v èásti Inicializace do path

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: Zaèátek vlastního kódu:

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: Inicializace

close all; clear all; clc;
addpath('fcn_preprocess', 'fcn_licovani');
% ____________________________________________________
global screen_size screen_full;
% [left, bottom, width, height]:
screen_size = get(0,'ScreenSize');
screen_full = [1 1 screen_size(3) screen_size(4)];
global SI SY SX max_im_edits

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: Load
% load images and scale & make subimage from them
[imIRs, imVISs] = LOAD_SCALE_SUBIMAGE_all_images();
% imIRs = cell-array se všemi obrázky ze složky <<<<<<<<<<<<<<<

% a teï dál si vybereme 1 obrázek <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%% the rest of first insert into xx_edits cell-array
% on which from all the loaded images to do the edits
index_im = 1;

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

siz = [5,5];
ir_edit = medfilt2( ir_edit, siz );

siz = [10,10];
vis_edit = medfilt2( vis_edit, siz);

ir_edits = cat(1, ir_edits, ir_edit); vis_edits = cat(1, vis_edits, vis_edit); 
tits_IR = cat(1, tits_IR, tit); tits_VIS = cat(1, tits_VIS, tit); 

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
    tit = 'IR final';
    SI=SI+1; subplot(SY,SX,SI);
    imshow(im,[]); title(tit);
%% VIS
    im = vis_final;
    tit = 'VIS final';
    SI=SI+1; subplot(SY,SX,SI);
    imshow(im,[]); title(tit);
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: JOIN the images

% todle už si doplòme jak potøebujeme -> buï do funkce JOIN_images (ve
% složce fcn_licovani, nebo nìkam jinam :)
answer_for_everything = JOIN_images(ir_final, vis_final);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: PLOTTING

% vykreslení podobrázkù (tìch vybraných rangem) pøes sebe podle parametrù z
% JOIN_images() funcke

% pøepoèet parametrù tak aby byli aplikovatelné na neoøíznuté obrázky