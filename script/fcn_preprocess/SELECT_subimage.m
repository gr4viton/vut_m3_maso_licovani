function [ subimg_dim  ] = SELECT_subimage( select_subimage_condition, im , f_im)
%SELECT_SUBIMAGE - selects range from user input
% 
% select_subimage_condition - condition
% im - loaded image
% f_imIR - path to file of picture

%% init
global screen_full;

%% script
sufix_config = '.mat';
f_config = strcat(f_im, sufix_config);

if select_subimage_condition == 0
% if not select manually
% load old values from saved file
    exist_config = exist(f_config, 'file');
%     exist_config
%     exist_config = 0;
    if exist_config == 0
%       config file not found
        disp('Ranges not saved, select them now, please!')
        select_subimage_condition = 1;
    else
%       load config file
        range = [1,1,size(im,2),size(im,2)]; %% get whole im if config is broken
        load(f_config);
        subimg_dim = range;
    end
end

if select_subimage_condition == 1
    txt = 'Please click to [left-top] and [bottom-right] corners of image to use';
    disp(txt);
    %% make figure fullscreen
    f = figure('Name', txt, 'Position', screen_full);
    imshow(im,[]);
    %% get range
    [x,y] = ginput(2);
    close(f);
    %% store range
    range = round([x,y]);
    subimg_dim = range;
    save(f_config, 'range');
end

end

