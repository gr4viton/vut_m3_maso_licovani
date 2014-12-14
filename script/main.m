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


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: Za��tek vlastn�ho k�du:

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
global plots
plots = {'preprocess','after_preproces','after_prescale','joined'};

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: Load
% load images and scale & make subimage from them
max_im = 16; % change as the max image index is in [im] folder
[imIRs, imVISs] = LOAD_SCALE_SUBIMAGE_all_images(max_im);
% imIRs = cell-array se v�emi obr�zky ze slo�ky <<<<<<<<<<<<<<<

% a te� d�l si vybereme 1 obr�zek <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%% the rest of first insert into xx_edits cell-array

%% what to plot
% plots = {'preprocess','after_preproces','after_prescale','joined_image'};
% plots = {'after_prescale','joined'};
plots = {'joined'};

%% popisy obr�zk� s indexy
% 1 - les
% 2 - neostr� laborato�
% 3 - laborato� ve tm�
% 4 - laborato� ve tm� - IR v��ez
% 5 - t�pek ze s��kem 
% 6 - t�pek ze s��kem - IR v��ez a rotace
% 7 - kontinent satelit
% 8 - Dan obli�ej
% 9 - ruka a mobil
% 10- Dan ze s��kem
% 11- Vla�as�v rock-sign
% 12- domky - v��ez okna
% 13- domky - cel�
% 14- domky - v��ez bez oken
% 15- domky - v��ez okno st�echa
% 16- ruka a mobil 2

%% prescale it after preprocessing for quicker computation (default = 1)
prescale = 0.5;
%% :: volba metody
join_method = 'correlation method';
% join_method = 'significant points method';


%% on which images (from all the loaded images) to do the edits
% for index_im = 10:16 % BIG IMAGE LOOP START
for index_im = 10:12 % BIG IMAGE LOOP START
    
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

if find(ismember(plots,'preprocess'))
    
    txt = 'IR & VIS';
    figure('Name',txt,'Position',screen_full); 
    SI=0; SY=2; SX=max_im_edits;

    % ____________________________________________________
    % IR
    PLOT_it('IR->', tits_IR, ir_edits);
    % VIS
    PLOT_it('VIS->', tits_VIS, vis_edits);
    drawnow
end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the final duo after preprocessing
ir_preproc = ir_edit;
vis_preproc = vis_edit;

if find(ismember(plots,'after_preproces'))
    txt = 'IR & VIS after preprocessing';
    figure('Name',txt,'Position',screen_full); 
    SI=0; SY=1; SX=2; 

%% IR
    im = ir_preproc;
    tit = 'IR preprocessed';
    SI=SI+1; subplot(SY,SX,SI);
    imshow(im,[]); title(tit);
%% VIS
    im = vis_preproc;
    tit = 'VIS preprocessed';
    SI=SI+1; subplot(SY,SX,SI);
    imshow(im,[]); title(tit);
   
% for printing the plots before calculation
    drawnow
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: JOIN the images

% prescale for quicker computation
ir_prescal = imresize(im2double(ir_preproc),prescale);
vis_prescal = imresize(im2double(vis_preproc),prescale);
%% plot
if find(ismember(plots,'after_prescale'))
    txt = sprintf('IR & VIS prescaled by [%.2]- for quicker execution',prescale);
    figure('Name',txt,'Position',screen_full); 
    SI=0; SY=1; SX=2; 

    %% IR
        im = ir_prescal;
        tit = 'IR prescaled';
        SI=SI+1; subplot(SY,SX,SI);
        imshow(im,[]); title(tit);
    %% VIS
        im = vis_prescal;
        tit = 'VIS prescaled';
        SI=SI+1; subplot(SY,SX,SI);
        imshow(im,[]); title(tit);

    drawnow
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: korelacni metoda 
if join_method(1) == 'c'
    % vyu�it� v�po�etn� jednotka
    % method = 'GPU'; % s podporoou cuda
    method = 'CPU';

    %% interval a krok zkou�en�ch m���tek
    mins = 0.5; % nevolit p��li� mal� (i.e.<0.5) nebo� jinak bude m�t nejm�n� chyb
    maxs = 2.2; %2.5
    % number of scale iterations
    nums = 5;
    scale = linspace(mins, maxs, nums);
    % scale = 0.5:0.1:2.5;
    % scale = 1.8:0.1:2.2;
    % scael = 1:0.05:1.5;

    %% vlastn� v�po�et
    [ima, imb, x, y, scale] = imjoin_corr(vis_prescal, ir_prescal, scale, method);
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: metoda vyznacn�ch bod�
if join_method(1) == 's'
    [ima, imb] = imjoin_sigPoints(vis_prescal, ir_prescal);
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :: PLOTTING
%% which methods to use to fuse both pictures
fuse_methods = {'falsecolor','blend' 'diff'};
nfus=length(fuse_methods);

if find(ismember(plots,'joined'))
    txt = strcat('IR & VIS joined by [', join_method,']' );
    figure('Name',txt,'Position', screen_full); 
    SI=0; SY=1; SX=nfus; 
end
    
for fus = 1:nfus
    fuse_method = fuse_methods(fus);
    fuse_method = fuse_method{1};
    im_joined = imfuse(ima,imb,fuse_method);

    
if find(ismember(plots,'joined'))
    SI=SI+1; subplot(SY,SX,SI);
    tit = sprintf('%s  - optimal parameters of joinment: scale[%.2f], x=[%.0f], y=[%.0f]',...
        fuse_method,scale,x,y );
    imshow(im_joined,[]);
    title(tit);
    drawnow
end

    %% save images
    fout = 'im_out/';
    fmt = 'png';
    fname = sprintf('%s%i_%s.%s',fout, index_im, fuse_method, fmt);
    imwrite(im_joined,fname,fmt);

end


end % BIG IMAGE LOOP START
    
%% do budoucna?
% p�epo�et parametr� tak aby byli aplikovateln� na neo��znut� obr�zky
