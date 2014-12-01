function [ imIRs, imVISs ] = LOAD_SCALE_SUBIMAGE_all_images( input_args )
%LOAD_ALL_IMAGES - loads all images
%   range_cond - dyz v bunce 0 = nacti range z configu
%              - dyz 1 uzivatel zada novy range kery se ulozi
%              - prvni sloupec IR obrazy, druhy VIS obrazy
%   fld - slozka s obrazky

%% naètení obrazu a selekce podobrazu
prefix_IR = 'IR_';
prefix_VIS = 'VIS_';
extension_IR = '.png';
extension_VIS = '.png';

fld = 'im/'; % folder
max_n = 1; % poèet obrázkù (nejvyšší index - poèítá se od 1)

range_cond = zeros(max_n,2); % znovunastaveni vsech
range_cond = zeros(max_n,2); % nacitani vsech z ulozenych rozsahu
% priklad nemazat!:
% range_cond(4,1:2); % znovunastaveni range u obrazku cislo 4 u IR i VIS


for n_im = 1:max_n
    %% load [n_im]-teho obrázku
    f_imIR = strcat(fld, prefix_IR, num2str(n_im), extension_IR);
    f_imVIS = strcat(fld, prefix_VIS, num2str(n_im), extension_VIS);
        
    imIR = imread( f_imIR );
    imVIS = imread( f_imVIS );
    %% SCALE 
    % the smaller image to the same scale 
%     - (depends on camera to camera ratio)
    
    %% selekce sektoru obrazu
    % pokud [select = 0] - použije naposledy oznaèená data (z uloženého souboru)
    % pokud chceme znovu naklikat range zadame 1 v range_cond na danem radku - viz vyse
    select_IR_subimage = range_cond(n_im,1);
    select_VIS_subimage = range_cond(n_im,2);
    [sub_dims_IR] = SELECT_subimage(select_IR_subimage, imIR, f_imIR);
    [sub_dims_VIS] = SELECT_subimage(select_VIS_subimage, imVIS, f_imVIS);

    %% vytvoøení podobrazù 
    % na základì rozsahù uložených v sub_dims_XX
    [imIR] = CREATE_subimage(imIR, sub_dims_IR);
    [imVIS] = CREATE_subimage(imVIS, sub_dims_VIS);

    %% for later storing of more images
    imIRs{n_im} = imIR;
    imVISs{n_im} = imVIS;
end


end

