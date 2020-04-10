function outliner(listofimages, savetps, nonsaved, checkoutline, addscale, savingOutlineImage, outputpath, startNumber, lastNumber, bgcolor)
% Do not display warning about size of images
warning('off', 'Images:initSize:adjustingMag');

if ~checkoutline
    set(0,'DefaultFigureVisible','off');
end

figure
% Loop through all the images
for i = startNumber:lastNumber
    
    % Make a binarized image
    imagename = listofimages(i).name;
    snailImage = imread(imagename);
    BWim = removeBG(snailImage,bgcolor);
    
    BW2 = bwperim(BWim,4);
    [row, col] = find(BW2);
    [starty,yind] = min(row);
    startx = col(yind);
    
    % Extract the contour coordinates
    contour = bwtraceboundary(BWim(:,:,1),[starty startx],'E',8,Inf,'clockwise');
    
    % Remove 9 out of 10 pixels to smooth out slightly
    outlinex = contour(1:10:end,2);
    outliney = contour(1:10:end,1);
    x = [outlinex; outlinex(1)];
    y = -[outliney; outliney(1)];
    
    thisoutline = [x,y];
    
    
    % Show image with outline

    imshow(snailImage)
    
    %set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    hold on
    plot(x,-y, 'b','linewidth',1.5)
    
    if checkoutline
        texttoshow = strcat('Is this good enough for ', imagename);
        goodenough = questdlg(texttoshow,...
            'Scale','Yes','No','Quit','Yes');
    else
        goodenough = 'Yes';
    end
    switch goodenough
        case 'Yes'
            % Ask user for scale input
            if addscale == true
                getscale = false;
                while getscale == false
                    [sx,sy] = getpts;
                    pt = scatter(sx,sy,20,'r','filled');
                    nSquares = inputdlg('How many mm is this?',...
                        'Scale');
                    scale = str2double(nSquares{:})/norm([sx(1)-sx(2),sy(1)-sy(2)]);
                    measured = scale*norm([sx(1)-sx(2),sy(1)-sy(2)]);
                    l = plot(sx,sy,'g','LineWidth',2);
                    rightscale = questdlg(['Is this ',num2str(measured),' mm?'],...
                        'Scale',...
                        'Yes','No','Yes');
                    
                    % Finish or redo scale step
                    switch rightscale
                        case 'Yes'
                            getscale = true;
                        case 'No'
                            delete(l)
                            delete(pt)
                    end
                end
            else
                scale = 1;
            end
            
            % Make strings to include in tps-files
            nPoints = ['POINTS=',num2str(length(thisoutline))];
            filename = ['IMAGE=',imagename];
            textscale = ['SCALE=',num2str(scale)];
            
            % Writes/appends the outline file
            fid = fopen(savetps,'at');
            fprintf(fid, '%s\n', 'LM=0');
            fprintf(fid, '%s\n', 'OUTLINES=1');
            fprintf(fid, '%s\n', nPoints);
            dlmwrite(savetps,thisoutline,'delimiter',' ','-append','precision','%d');
            fprintf(fid, '\n%s\n', filename);
            fprintf(fid, '%s\n', textscale);
            fclose(fid);
            
            % Displays file info
            disp(['Saved outline and image of number ',num2str(i)])
            disp(imagename)
        case 'No'            
            % Record which outlines were not a good fit
            f2id = fopen(nonsaved,'at');
            fprintf(f2id, '%s\n', [num2str(i),' = ', imagename]);
            fclose(f2id);
            % Displays file info
            disp(['Saved image but not outline of number ',num2str(i)])
            disp(imagename)
            
        case 'Quit'
            disp(['Number ',num2str(i),' was cancelled, not saved.'])
            disp(['This was image: ',imagename])
            break
    end
    
    % Save image with outline
    if savingOutlineImage && ~strcmp(goodenough,'Quit') 
        savename = strcat(outputpath,'\outline_',imagename);
        print(gcf, savename, '-djpeg', '-r200' )
    end
    clf
end
close all
set(0,'DefaultFigureVisible','on');
if i == lastNumber
    disp('Done!')
end