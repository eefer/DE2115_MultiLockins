%% Script to process CSV data transferred to RPi from the GPIO poins of the FPGA
% Developers: Saurabh Gupta and Jesse Wilson, Wilson Lab, Colorado State University
%
% modified JWW 2019-09-05 to use trigger to correctly parse line wraparound
% points
% Modified JWW 20210706 for multi-frame support

%%//////////////////////////////////////////////%%%%%%INSTRUCTIONS%%%%%%%////////////////////////////////////////////////////////////////
%   > Copy all the files to the same folder (assisting files contain functions)
%   > Make sure the path to the CSV file is right  ;  Line 18 below
%   > Run THIS script in Matlab
%   > Use the mouse wheel to browse through the image slices
%   > Use the rectangle to assess the average response of a cluster. The rectangle can be moved around and resized
%   > The averaged phase and amplitude response is shown on a plot for all the lockins
%   > HAVE FUN!
%%///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

clc; clear all; close all;

% TODO: MOVE SETTINGS FOR ALL FILE-DEPENDENT PARAMETERS HERE

filename = 'test03_210522.csv';
data = csvread(filename,1,1); % skips header row and index column
%

%%
frametrig = data(:,1); % frame trigger
xtrig = data(:,2); % 3rd column (here index 2) is the line trigger

% sort each lockin's x/y data into separate vectors in a cell array
for i = 1:16
    xy{i} = data(:,i+2);
end

%%
clear XYfb;
min_row_per_frame = 8;
for iChan = 1:16

    iFrame = 1; % current frame index
    xtrig_prev = 0;
    frametrig_prev = 0;
    row = 0;
    col = 0;
    n = length(xtrig);

    for iSample = 1:n

       % look for line trigger, and increment row accordingly
       if (xtrig_prev == 0) && (xtrig(iSample) == 1)
           row = row + 1;
           col = 0;
       end
       xtrig_prev = xtrig(iSample);
       
       % look for frame trigger, and increment frame index accordingly
       if (frametrig_prev == 0) && (frametrig(iSample) == 1) && row > min_row_per_frame
            fprintf('frame trig, iSample %d, frame %d, channel %d, row %d\n', iSample, iFrame, iChan, row);
            if iSample > 1
                % display progress
                imagesc(XYfb{iFrame,iChan});
                title(sprintf('frame %d, channel %d',iFrame,iChan));
                drawnow

                % move on to next frame
                iFrame = iFrame + 1;
                row = 1;
                col = 0;
            end
       end
       frametrig_prev = frametrig(iSample);
       
       % increment column with each new sample
       col = col + 1;

       if row > 0
           XYfb{iFrame,iChan}(row,col) = xy{iChan}(iSample);
       end
    end

end

[nrows,ncols] = size(XYfb{1,1});

%%
% handle flyback / reverse every other row
%
% TODO: update for multi-frame scenario
clear XY;
for i = 1:iFrame
    for ii = 1:16
        %
        %ii=iChan
        
        turnaroundFraction = 0.125; % 12.5 percent of all sample time is spent accelerating (CLARIFY THIS)
        nx_final = floor(ncols/2*(1-turnaroundFraction))     % number of pixels in the linear motion regime
        x0_forward = floor(ncols/2*(turnaroundFraction/2))   % half the number of pixels in the accelerating regime
        x0_backward = floor(ncols/2+ncols/2*(turnaroundFraction/2))   % half the number of pixels in the accelerating regime
        
        X1_forward = XYfb{i,ii}(:, x0_forward:(x0_forward+nx_final-1));     % keep only forward scan pixels in the linear regime
        subplot(211);
        imagesc(X1_forward)
        title('forward scan lines')
        axis image;
        grid on;
        
        X1_backward = XYfb{i,ii}(:, x0_backward:(x0_backward+nx_final-1));
        X1_backward = fliplr(X1_backward);
        subplot(212);
        imagesc(X1_backward)
        title('backward scan lines')
        axis image
        pause(0.5);
        
                
        % clf
        % imagesc(X1_combined)
        % axis image;
        %ylim([220,440])
        
        
        % fix aspect ratio
        % final combined image

        %XY{ii} = X1_forward;
        XY{i,ii} = X1_backward;
        % figure;
        % imagesc(XY{ii});
        % axis image;
        
    end
end

%% save corrected image stack + parameters
save ('z5.mat');




