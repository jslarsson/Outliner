function BWim = removeBG(image,BGcolor)
% Convert rgb to LAB for better separation of intensity
if strcmp(BGcolor,'pink')
    I = rgb2lab(image);
    [mhist, edges] = histcounts(I(:,:,2));
    % Find a good separation value of intensity
    [~,maxpt1] = max(mhist(edges < 35));
    Mhist = mhist;
    Mhist(edges < 35) = 0;
    [~,maxpt2] = max(Mhist);
    
    
    mind = (maxpt1:1:maxpt2);
    [lowval, ~] = min(mhist(mind));
    [~, lowpts] = find(mhist(mind) < lowval*1.2);
    cutoffpt = lowpts(end);
%     
%     figure
%     plot(edges(1:end-1),mhist)
%     hold on
%     plot(edges(mind(lowpts)),mhist(mind(lowpts)),'rx')
%     plot(edges(mind(lowpoint)),mhist(mind(lowpoint)),'g*')
    
    intensity = edges(mind(cutoffpt));
    BW = (I(:,:,2) >= intensity);
    
elseif strcmp(BGcolor,'green')
    I = rgb2lab(image);
    [mhist, edges] = histcounts(I(:,:,2));
    
    [~,maxpt1] = max(mhist(edges < -30));
    Mhist = mhist;
    Mhist(edges < -30) = 0;
    [~,maxpt2] = max(Mhist);
    
    
    mind = (maxpt1:1:maxpt2);
    [lowval, ~] = min(mhist(mind));
    [~, lowpts] = find(mhist(mind) < lowval*1.2);
    cutoffpt = lowpts(1);
    
%     figure
%     plot(edges(1:end-1),mhist)
%     hold on
%     plot(edges(mind(lowpts)),mhist(mind(lowpts)),'rx')
%     plot(edges(mind(cutoffpt)),mhist(mind(cutoffpt)),'g*')
%     
    intensity = edges(mind(cutoffpt));
    BW = (I(:,:,2) <= intensity);
end

% if strcmp(intensity,'auto')
%     
% end

%BW = (I(:,:,2) >= intensity);


% Initialize output masked image based on input image.
maskedImage = image;

% Set background pixels where BW is false to zero.
maskedImage(repmat(BW,[1 1 3])) = 0;

% Convert to grayscale
grayscale = rgb2gray(maskedImage);

% Create new empty mask.
BW = false(size(grayscale));

% Get bg color region
addedRegion = imbinarize(grayscale,0);
addedRegion = imcomplement(addedRegion);
BW = BW | addedRegion;

% Invert mask
BW = imcomplement(BW);

% Clear borders
BW = imclearborder(BW);

% figure
% imshow(BW)
% pause


% Adds small removed parts of shell
se = strel('disk', 10);
BW = imclose(BW, se);

% Invert mask
BW = imcomplement(BW);

% figure
% imshow(BW)
% pause

% Close mask with disks, i.e. remove small parts that
% should be in the background
se = strel('disk', 50);
BW = imclose(BW, se);
BW = imcomplement(BW);

% figure
% imshow(BW)
% pause



[row, col] = find(BW);
% Choose only bottom component in the image?
%[starty,yind] = max(row);
%startx = col(yind); 

% Choose only left component in the image?
[startx,xind] = min(col);
starty = row(xind); 

CC = bwconncomp(BW);
labeledImage = bwlabel(BW);
idx = labeledImage(starty,startx);

BWim = zeros(size(BW));
BWim(CC.PixelIdxList{idx}) = 1;

% figure
% imshowpair(BWim,image,'montage')
% pause
% close all
