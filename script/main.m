%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MASO Projekt
% VUT, FEKT, KAM
% Zad�n�: 
% Auto�i: DAV�DEK D., SLI� J., ST��TE�SK� V.
% Popis: Nav�z�n� obrazu z viditeln�ho obrazu a no�n�ho vid�n�
% Hlavn� skript - vol� v�echny ostatn�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Legenda
% aby se p�i zkou�en� preprocesingov�ch edit� (filtry hist) nemuselo
% poka�d� p�id�vat vykreslen� pro porovn�n�
% -> ud�lal sem cell-array do kter�ho se postupn� p�id�vaj� obr�zky s
% jednotliv�mi edity (ir_edits{}, vis_edits{})
% -> a druh� cell-array pro postupn� p�id�v�n� titl� k obr�zk�m aby bylo jasn�
% co se tam d�je (tit_IR{}, tit_VIS{})
% ---> 
% P�i vykreslov�n� se potom vykresluje prost� z cell-array ve for smy�ce
% (funkce PLOT_it)

% pro nov� edit vlo�te pros�m n�co takov�ho - p��klad funkce [gray]
%____________________________________________________
% tit = 'gray';
% 
% ir_edit = rgb2gray( ir_edit );
% vis_edit = rgb2gray( vis_edit );
% 
% ir_edits = cat(1, ir_edits, ir_edit); vis_edits = cat(1, vis_edits, vis_edit); 
% tits_IR = cat(1, tits_IR, tit); tits_VIS = cat(1, tits_VIS, tit); 
%____________________________________________________

%* kde xx_edit je pro z�et�zen� napln�n p�edchoz�m (posledn�m editovan�m)
% obr�zkem
%* a kde posledn� dva ��dky jsou pouze z�et�zen� dan�ch cell-array�

%%
% -> �et�� to fakt dost �asu, bo pak u� sta�� p�i nov� "editaci" jenom 
% p�ekop�rovat star� k�d, p�idat tu funkci editace a popisek..
% a ona se pak u� automaticky vykresl�

%%
% -> ostatn� funkce dejte (t�eba nakonec, a� budou hotov�) t�eba do slo�ky 
% fcn_licovani nebo jinak (ale pak ji p�idejte v ��sti Inicializace do path

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: Za��tek vlastn�ho k�du:

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
% imIRs = cell-array se v�emi obr�zky ze slo�ky <<<<<<<<<<<<<<<

% a te� d�l si vybereme 1 obr�zek <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

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

% todle u� si dopl�me jak pot�ebujeme -> bu� do funkce JOIN_images (ve
% slo�ce fcn_licovani, nebo n�kam jinam :)
answer_for_everything = JOIN_images(ir_final, vis_final);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: PLOTTING

% vykreslen� podobr�zk� (t�ch vybran�ch rangem) p�es sebe podle parametr� z
% JOIN_images() funcke

% p�epo�et parametr� tak aby byli aplikovateln� na neo��znut� obr�zky