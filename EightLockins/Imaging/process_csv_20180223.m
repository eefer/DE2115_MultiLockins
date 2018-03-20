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

load('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\NIST data 13mar18\z5.mat');


%%

aspectRatio = 3;

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
% caxis([0,max(max ([lockin_amp{:}]))]);
caxis([0,20000]);
hrect = imrect(gca,[20,40,1,1]);

subplot( 2,2,2 );
h_phase = imagesc(lockin_phase{i});
set(h_phase,'Tag','phaseImage');
axis image;
colorbar;
set(gca,'DataAspectRatio',[aspectRatio,1,1]);
caxis([-pi,pi]);

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
set(hAx(2),'ylim',[-pi,pi],'ytickmode','auto');
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

