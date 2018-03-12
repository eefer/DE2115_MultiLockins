%% Script to process CSV data transferred to RPi from the GPIO poins of the FPGA
% Developers: Saurabh Gupta and Jesse Wilson, Wilson Lab, Colorado State University

%%//////////////////////////////////////////////%%%%%%INSTRUCTIONS%%%%%%%////////////////////////////////////////////////////////////////
%   > Copy all the files to the same folder (assisting files contain functions)
%   > Make sure the path to the CSV file is right  ;  Line 15 below
%   > Run THIS script in Matlab
%   > Use the mouse wheel to browse through the image slices
%   > Use the rectangle to assess the average response of a cluster. The rectangle can be moved around and resized
%   > The averaged phase and amplitude response is shown on a plot for all the lockins
%   > HAVE FUN!
%%///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

clc; clear all; close all;

% TODO: MOVE SETTINGS FOR ALL FILE-DEPENDENT PARAMETERS HERE

filename = 'T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\x5.csv';
data = csvread(filename,1,3); % skips header
%
aspectRatio = 2;

%%
for i = 1:16
    xy{i} = data(:,i);
end

% make for loop, apply to all X and Y images
% ii= 1;
for ii = 1:16
% should be 256x256 after accounting for overscan

% data is a list of samples, scan across x first
% we expect a few dummy rows at the top when done
   
    nx = 1997;          % samples per line = (FPGA sample rate) / (AFM line rate)
    ny = floor(length(xy{ii}) / nx);
    startDelay = 0;
    x1_corrected = xy{ii}(1:(nx*ny)); % remove extra pixels if nx*ny < nsamp
    x1_corrected = circshift(x1_corrected,startDelay);
    XY{ii} = reshape(x1_corrected,[nx,ny]).';    
    XY{ii} = fliplr(XY{ii});
%     imagesc(XY{ii});
%     drawnow;

%correct for shear
shear = 0.2039;
tform = maketform('affine',[1 0 0; shear 1 0; 0 0 1]);
XY{ii} = imtransform(XY{ii}, tform);
% 
% clf
% imagesc(XY{ii});
% axis image
% grid on

% handle flyback / reverse every other row
nx_final = 500;     % valid number of samples per line, in a forward scan (should be nx/2*0.8)
x0_forward = 52;
% x0_backward = 174;
X1_forward = XY{ii}(:, x0_forward:(x0_forward+nx_final-1));
% imagesc(X1_forward)
% axis image;
% grid on;

% X1_backward = XY{ii}(:, x0_backward:(x0_backward+nx_final-1));
% X1_backward = fliplr( X1_backward );
% subplot(122);
% imagesc(X1_backward)
% title('backward scan lines')
% axis image


% recombine forward and backward scans
% XY{ii} = zeros(2*ny, nx_final);
% XY{ii}(1:2:end, :) = X1_forward;
% XY{ii}(2:2:end, :) = X1_backward;

% clf
% imagesc(X1_combined)
% axis image;
%ylim([220,440])


% fix aspect ratio
% final combined image
% force a final 256x256 image (might not be valid)
%XY{ii} = imresize(X1_forward,[256, 256]);
XY{ii} = X1_forward;
% figure;
% imagesc(XY{ii});
% axis image;

end


%% calculate amplitude and phase for all lockins
nf = numel(XY)/2;
[ny, nx] = size(XY{1});

for i = 1:nf
   for j = 1:ny
      for k= 1:nx
         lockin_amp{i}(j,k)  = sqrt (((XY{2*i-1}(j,k))^2)+((XY{2*i}(j,k))^2));  
         
         % phase = atan( Y / X ) 
         lockin_phase{i}(j,k)  = atan2 (XY{2*i}(j,k), XY{2*i-1}(j,k));   
         
      end
   end
end

%% prepare data as ny x nx x nf 3D array
lockin_amp_mat = reshape(cell2mat(lockin_amp),[ny,nx,nf]);
lockin_phase_mat = reshape(cell2mat(lockin_phase),[ny,nx,nf]);

%% interactive figure to show all stack frames

% create figure
fig = figure;
ax_ampl=subplot( 2,2,1 );
h = imagesc(lockin_amp{i});
axis image;
set(h,'Tag','ampImage');
colorbar;
set(gca,'DataAspectRatio',[aspectRatio,1,1]);
caxis([0,max(max ([lockin_amp{:}]))]);
hrect = imrect(gca,[20,40,1,1]);

subplot( 2,2,2 );
h_phase = imagesc(lockin_phase{i});
set(h_phase,'Tag','phaseImage');
axis image;
colorbar;
set(gca,'DataAspectRatio',[aspectRatio,1,1]);
caxis([-10,10]);

subplot(2,2,(3:4));
[hAx,hLine1,hLine2] = plotyy(1:nf,squeeze(sum(sum(lockin_amp_mat,1),2)),1:nf,squeeze(sum(sum(lockin_phase_mat,1),2)));
set(hLine1,'Marker','o');
set(hLine2,'Marker','*');
set(hLine1,'Tag','ampLine');
set(hLine2,'Tag','phaseLine');
xlabel('Lockin channel');
legend('Amplitude','Phase');
ylabel(hAx(1),'Amplitude'); % left y-axis
ylabel(hAx(2),'Phase'); % right y-axis
set(hAx(2),'ylim',[-10,10],'ytickmode','auto');
set(hAx(1),'ylimmode','auto','ytickmode','auto');

% store data in the figure
setappdata(fig,'currentFrame',1);
setappdata(fig,'lockin_amp_mat',lockin_amp_mat);
setappdata(fig,'lockin_phase_mat',lockin_phase_mat);
setappdata(fig,'lockin_phase',lockin_phase);

% set up interactive behavior
set(gcf,'WindowScrollWheelFcn', @windowScrollWheelFunction);

% TODO: make a region select / plot amp/phs in another subplot
addNewPositionCallback(hrect,@(p)selectRectangle(p,fig));
fcn = makeConstrainToRectFcn('imrect',get(ax_ampl,'XLim'),get(ax_ampl,'YLim'));
setPositionConstraintFcn(hrect,fcn);

