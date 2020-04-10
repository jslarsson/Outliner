% This program is meant for finding outlines of specific type of images 
% having a snail in standard orientation with pink background.

% Path to folder with the script files
addpath C:\Users\Admin\MATLAB\Outlines

% Specify which folder the images are located in and which files
% to consider. For example, the ones ending with '_1.jpg'
cd C:\Users\Admin\Pictures\Shellphotos
listofimages = dir('*.jpg');

% Background color to remove, only works with pink or green
bgcolor = 'pink';

% File to save the outlines in, needs to be .tps
% APPENDS an existing file, does not overwrite it.
savetps = 'C:\Users\Admin\MATLAB\Outlines\samplename_outlines.tps';

% Do you want to interactively check each outline? 1/0
% If yes, do you want to add scale information? 1/0
checkoutline = 1;
addscale = 0;

% If checking each outline, save names of unsatisfactory outlines
% in the following text file. APPENDS file, does not overwrite.
badOutlines = 'C:\Users\Admin\MATLAB\Outlines\samplename_outlines.txt';

% Do you want to save small outlined images for double checking? 1/0 
% If yes, which existing folder?
savingOutlineImage = 1;
outputpath = 'C:\Users\Admin\Pictures\Shellphotos\Output';

% Start or end on specific numbers (alphabetically in folder)
% If you want all, then use: 1 to numel(listofimages)
startNumber = 1;
lastNumber = numel(listofimages); 


% This part runs the program
outliner(listofimages, savetps, badOutlines, checkoutline, addscale,...
    savingOutlineImage, outputpath, startNumber, lastNumber, bgcolor)