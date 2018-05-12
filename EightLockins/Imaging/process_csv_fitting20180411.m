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

load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\y5.mat');


%%

aspectRatio = 3;

%% prepare data as ny x nx x nf 3D array
nf = numel(XY)/2;
[ny, nx] = size(XY{1});

lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);

lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;

dataList = reshape(lockin_compl_mat,[ny*nx,nf]); 

%% display
% clf
% subplot(1,2,1)
% imagesc(real(dataList))
% subplot(1,2,2)
% imagesc(imag(dataList))
% 
% %% display a random pixel
% clf
% ind = ceil(rand()*ny*nx);
% plot(abs(dataList(ind,:)),'-')

%% show initial guess
f= 979948:10013:1050043;
%f = linspace(0,1050043,512);
%f= linspace(979948,1050043,512);
%fLorentz = @(f, f0, A, gamma) A ./ (f-f0+i*gamma*f);
fLorentz = @(f0, A, Q, f) f0.^2 .* A ./  ((f0.^2-f.^2) + j.*(f0.*f./Q));
% fLorentz = @(f, f0, A, Q,x0,y0) f0.^2 * A ./  ((f0.^2-f.^2) + j*(f0.*f./Q)) + x0 + i*y0;
params0 = [1009988,1,200];
% plot(f,abs(fLorentz(f, params0(1),params0(2),params0(3))))

%% fit the entire datalist
% calculate sum-squared error, as a function of parameters
warning('off','optim:fminunc:SwitchingMethod');
% figure;
% hold on;
params0 = [1009988,100,90];
fit_list_allparams = [];
tic;
% for ii = 1:size(dataList,1)
ii= 39;

    y1 = dataList(ii,:);
    % apply fit
%     fitFn = @(params) sum(abs(y1 - fLorentz( f, params(1), params(2), params(3))).^2);
%     params_estimated = fminunc( fitFn, params0 );
% using another approach:
    opts = optimoptions(@lsqcurvefit); % reuse the options
    [params_estimated,resnorm] = lsqcurvefit(fLorentz,params0,f',y1,[],[],opts);

%     params0 = params_estimated;

%%     % show fit
    subplot(121);
    plotyy(f, real(y1), f, imag(y1));
    
    y_estimated = fLorentz( f, params_estimated(1), params_estimated(2), params_estimated(3));
    subplot(122);
    plotyy(f, real(y_estimated), f, imag(y_estimated));
    drawnow;
    
    fit_list_allparams(ii,:) = params_estimated;
% end
toc;

%% reshape and plot
image_array = reshape(fit_list_allparams,[ny,nx,3]);
figure(1);
imagesc(image_array(:,:,1) / 1e6);
caxis([.9,1.1]);
colorbar;
title('f0, MHz')

figure(2);
colorbar;
imagesc(image_array(:,:,3));

caxis([0,1e5]);
colorbar
title('Q')
%% arrange into a list of independent measurements


%% calculate amplitude and phase for all lockins
% nf = numel(XY)/2;
% [ny, nx] = size(XY{1});
% 
% for ii = 1:nf
%    for jj = 1:ny
%       for kk= 1:nx
%          lockin_amp{ii}(jj,kk)  = sqrt (((XY{2*ii-1}(jj,kk))^2)+((XY{2*ii}(jj,kk))^2));  
%          
%          % phase = atan( Y / X ) 
%          lockin_phase{ii}(jj,kk)  = atan2 (XY{2*ii}(jj,kk), XY{2*ii-1}(jj,kk));   
%          
%       end
%    end
% end
% 
% 
% 
% %% interactive figure to show all stack frames
% 
% % create figure
% fig = figure;
% ax_ampl=subplot( 2,2,1 );
% h = imagesc(lockin_amp{i});
% axis image;
% set(h,'Tag','ampImage');
% colorbar;
% set(gca,'DataAspectRatio',[aspectRatio,1,1]);
% % caxis([0,max(max ([lockin_amp{:}]))]);
% caxis([0,20000]);
% hrect = imrect(gca,[20,40,1,1]);
% 
% subplot( 2,2,2 );
% h_phase = imagesc(lockin_phase{i});
% set(h_phase,'Tag','phaseImage');
% axis image;
% colorbar;
% set(gca,'DataAspectRatio',[aspectRatio,1,1]);
% caxis([-pi,pi]);
% 
% subplot(2,2,(3:4));
% [hAx,hLine1,hLine2] = plotyy(1:nf,squeeze(sum(sum(lockin_amp_mat,1),2)),1:nf,squeeze(sum(sum(lockin_phase_mat,1),2)));
% set(hLine1,'Marker','o');
% set(hLine2,'Marker','*');
% set(hLine1,'Tag','ampLine');
% set(hLine2,'Tag','phaseLine');
% xlabel('Lockin channel');
% legend('Amplitude','Phase');
% ylabel(hAx(1),'Amplitude'); % left y-axis
% ylabel(hAx(2),'Phase'); % right y-axis
% set(hAx(2),'ylim',[-pi,pi],'ytickmode','auto');
% set(hAx(1),'ylimmode','auto','ytickmode','auto');
% 
% % store data in the figure
% setappdata(fig,'currentFrame',1);
% setappdata(fig,'lockin_amp_mat',lockin_amp_mat);
% setappdata(fig,'lockin_phase_mat',lockin_phase_mat);
% setappdata(fig,'lockin_phase',lockin_phase);
% 
% % set up interactive behavior
% set(gcf,'WindowScrollWheelFcn', @windowScrollWheelFunction);
% 
% % TODO: make a region select / plot amp/phs in another subplot
% addNewPositionCallback(hrect,@(p)selectRectangle(p,fig));
% fcn = makeConstrainToRectFcn('imrect',get(ax_ampl,'XLim'),get(ax_ampl,'YLim'));
% setPositionConstraintFcn(hrect,fcn);

