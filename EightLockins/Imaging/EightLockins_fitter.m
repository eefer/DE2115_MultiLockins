%% Fit the entire set of eight lockins MAFLIA data using smart fitter 
clear all; clc;
load('test03_210522.mat'); 
f = [62990 67997 73004 78011 83017 88024 92983 97990]; %specific freq values set for MAFLIA for this data set 

%Select the row of XY corresponding to the frame of interest
%Ask the user to indicate which row using listdlg
[numFrames,~] = size(XY);
frameVect = 1:numFrames;
list = string(frameVect);
[frame,tf] = listdlg('ListString',list, 'PromptString',["Select which frame in the file" "you'd like to analyze."]);
if tf == 0 %If the user does not select a number in the listdlg
    return
end

%Resave XY as just the row corresponding to the frame of interest
XY = XY(frame,:);

nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + 1i*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + 1i.*(f0.*f./Q)) .* exp(1i .* phi0);

opts = optimset('display','off');
fitted_params = zeros(length(dataList),4);
sse_mat = zeros(length(dataList),1);
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    Z_sig_vect_scaled = data_px; 
    [A_guess, A_index] = max(abs(Z_sig_vect_scaled));
    f0_guess = f(A_index);
    [~, low_index] = min(abs(abs(Z_sig_vect_scaled(1:A_index))-(A_guess/sqrt(2)))); 
    [~, high_index] = min(abs(abs(Z_sig_vect_scaled(A_index:end))-(A_guess/sqrt(2))));
    width_est = f(high_index + A_index - 1)- f(low_index);
    
    if width_est == 0
        Q_guess = 60;
    else
        Q_guess = f0_guess / width_est;
    end

    initial_guess = [f0_guess,A_guess,Q_guess,pi/2];
    [params_estimated, sse] = fminunc( fitFn, initial_guess,opts);
    fitted_params(ii,:) = params_estimated;
    sse_mat(ii) = sse;
end

fitted_params = reshape(fitted_params,[ny,nx,4]);
sse_mat = reshape(sse_mat,[ny,nx]);

%% save results after smart fitting

save('test03_210522_smart')

%% load results after smart fitting 

load('test03_210522_smart')

fitted_params = reshape(fitted_params,[ny,nx,4]);
sse_mat = reshape(sse_mat,[ny,nx]);

%% plot results after smart fitting

image_array = reshape(fitted_params,[ny,nx,4]);
figure(1);
imagesc(image_array(:,:,1) / 1e6);
caxis([0.15 0.35]);
colorbar;
title('f0, MHz')

figure(2);
imagesc(image_array(:,:,3));
caxis([0 100]);
colorbar
title('Q')

%% prepare data for iterative fitting and run iterative fitting

load('test03_210522_smart');
raw_data = zeros(length(dataList),1);
for ii = 1:length(dataList)
    raw_data(ii) = abs(dataList(ii,1))^2 + abs(dataList(ii,2))^2 + abs(dataList(ii,3))^2 + abs(dataList(ii,4))^2 + abs(dataList(ii,5))^2 + abs(dataList(ii,6))^2 + abs(dataList(ii,7))^2 + abs(dataList(ii,8))^2;  
end

% reshape the parameters of the previous fit into matrix form
fitted_f0 = fitted_params(:,:,1);
fitted_A = fitted_params(:,:,2);
fitted_Q = fitted_params(:,:,3);
fitted_phi = fitted_params(:,:,4);
data_mat_1 = reshape(dataList(:,1),[ny,nx]);
data_mat_2 = reshape(dataList(:,2),[ny,nx]);
data_mat_3 = reshape(dataList(:,3),[ny,nx]);
data_mat_4 = reshape(dataList(:,4),[ny,nx]);
data_mat_5 = reshape(dataList(:,5),[ny,nx]);
data_mat_6 = reshape(dataList(:,6),[ny,nx]);
data_mat_7 = reshape(dataList(:,7),[ny,nx]);
data_mat_8 = reshape(dataList(:,8),[ny,nx]);
raw_data = reshape(raw_data, [ny,nx]);

fitted_params_2 = zeros(ny,nx,4);
sse_mat_2 = zeros(ny,nx);
initial_guess_list = zeros(ny,nx,4);
lowest_nsse_mat = zeros(ny,nx);
opts =  optimset('display','off');

nsse_mat = zeros(ny,nx);
for jj = 1:ny
    for ii = 1:nx
        nsse = sse_mat(jj,ii)/raw_data(jj,ii);
        nsse_mat(jj,ii) = nsse;
    end
end

% iterative fitting algorithm begins here
for jj = 1:ny
    for ii = 1:nx
        data_px = [data_mat_1(jj,ii) data_mat_2(jj,ii) data_mat_3(jj,ii) data_mat_4(jj,ii) data_mat_5(jj,ii) data_mat_6(jj,ii) data_mat_7(jj,ii) data_mat_8(jj,ii)];
        fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
        
        % choose a specific pixel to obtain the neighborhood of
        if ii == 1 
            x_index = ii : ii + 2; % if x pixel is in the leftmost column, take the following two pixels to form the 3x3 neighborhood
        elseif ii == nx
            x_index = ii - 2 : ii; % if x pixel is in the rightmost column, take the preceding two pixels to form the 3x3 neighborhood
        else
            x_index = ii - 1 : ii + 1; % if x pixel is anywhere other than the two aforementioned conditions, take the preceding and following pixels to form the 3x3 neighborhood         
        end
        
        if jj == 1
            y_index = jj : jj + 2; % if y pixel is in the top column, take the two pixels below it to form the 3x3 neighborhood
        elseif jj == ny
            y_index = jj - 2 : jj; % if y pixel is in the bottom column, take the two pixels over it to form the 3x3 neighborhood
        else
            y_index = jj - 1 : jj + 1; % if y pixel is anywhere other than the two aforementioned conditions, take the preceding and following pixels to form the 3x3 neighborhood         
        end
        
        % obtain the 3x3 neighborhood for the pixel of interest
        error_nhd = nsse_mat(y_index, x_index);
        fitted_f0_nhd = fitted_f0(y_index, x_index);
        fitted_A_nhd = fitted_A(y_index, x_index);
        fitted_Q_nhd = fitted_Q(y_index, x_index);
        fitted_phi_nhd = fitted_phi(y_index, x_index);
        
        % find the pixel in the neighborhood that has the lowest SSE
        minVal = min(error_nhd(:));
        [minPy,minPx] = find(error_nhd == minVal);
        lowest_nsse_mat(jj,ii) = minVal;
         
        % use the pixel index with the lowest SSE to construct the initial guess for the next pixel        
        initial_guess = [fitted_f0_nhd(minPy,minPx), fitted_A_nhd(minPy,minPx), fitted_Q_nhd(minPy,minPx), fitted_phi_nhd(minPy,minPx)];
        initial_guess_list(jj,ii,:) = initial_guess;
        
        % estimate new fitted parameters for this specific pixel and store in a cell array
        [params_estimated, sse] = fminunc(fitFn, initial_guess, opts);
               
        % normalize the SSE found for this pixel        
        nsse = sse/raw_data(jj,ii);
        
        % if the NSSE obtained from 9 pixel neighborhood fit is less than original fit, store the new parameters
        if nsse < nsse_mat(jj,ii)
            fitted_params_2(jj,ii,:) = params_estimated;
            sse_mat_2(jj,ii) = sse;
        else
            fitted_params_2(jj,ii,:) = [fitted_f0(jj,ii) fitted_A(jj,ii) fitted_Q(jj,ii) fitted_phi(jj,ii)];
            sse_mat_2(jj,ii) = sse_mat(jj,ii);            
        end
    end
end


%% reshape some matrices and save the iterative fitted data

fitted_params_2 = reshape(fitted_params_2,[ny,nx,4]);
sse_mat_2 = reshape(sse_mat_2,[ny,nx]);

save('test03_210522_iterative');


%% load iterative fitting results 

load('test03_210522_iterative')

%% plot f0 and Q maps after the iterative fitting
figure(1);
imagesc(fitted_params_2(:,:,1) / 1e6);
caxis([0.15 0.35]);
colorbar;
title('f0, MHz')

figure(2);
imagesc(fitted_params_2(:,:,3));
caxis([0 100]);
colorbar
title('Q')

%% calculate R-squared after iterative fitting

y_est_mat = zeros(ny,nx,8);
rsq = zeros(ny,nx);
for jj = 1:ny
    for ii = 1:nx
    params_estimated = fitted_params_2(jj,ii,:);
    y_est_mat(jj,ii,:) = fLorentz( f, params_estimated(:,:,1), params_estimated(:,:,2), params_estimated(:,:,3), params_estimated(:,:,4));
    end
end

for jj = 1:ny
    for ii = 1:nx
        y_mes_real = real([data_mat_1(jj,ii), data_mat_2(jj,ii), data_mat_3(jj,ii), data_mat_4(jj,ii), data_mat_5(jj,ii), data_mat_6(jj,ii), data_mat_7(jj,ii), data_mat_8(jj,ii)]);
        y_mes_imag = imag([data_mat_1(jj,ii), data_mat_2(jj,ii), data_mat_3(jj,ii), data_mat_4(jj,ii), data_mat_5(jj,ii), data_mat_6(jj,ii), data_mat_7(jj,ii), data_mat_8(jj,ii)]);
        yi_est_real = real([y_est_mat(jj,ii,1), y_est_mat(jj,ii,2), y_est_mat(jj,ii,3), y_est_mat(jj,ii,4), y_est_mat(jj,ii,5), y_est_mat(jj,ii,6), y_est_mat(jj,ii,7), y_est_mat(jj,ii,8)]);
        yi_est_imag = imag([y_est_mat(jj,ii,1), y_est_mat(jj,ii,2), y_est_mat(jj,ii,3), y_est_mat(jj,ii,4), y_est_mat(jj,ii,5), y_est_mat(jj,ii,6), y_est_mat(jj,ii,7), y_est_mat(jj,ii,8)]);
        rsq(jj,ii) = 1 - sum((y_mes_real - yi_est_real).^2 + (y_mes_imag - yi_est_imag).^2)/sum((y_mes_real - mean(y_mes_real)).^2 + (y_mes_imag - mean(y_mes_imag)).^2);
    end
end


%% plot R-squared 

figure(3);
imagesc(rsq);
caxis([0 1]);
colorbar;

%% Magnitude Plots

close all;
for ii = 1:8
    figure(ii);
    imagesc(log(abs(lockin_compl_mat(:,:,ii))));
    colorbar();
    caxis(log([400 16000]));
    title(sprintf('Magnitude for Lockin: %d, Frequency: %d', ii, f(ii)));
end

%% Phase Plots

close all;
for ii = 1:8
    figure(ii);
    imagesc(angle(lockin_compl_mat(:,:,ii)));
    colorbar();
    colormap('hsv')
    caxis([-pi pi]);
    title(sprintf('Phase for Lockin: %d, Frequency: %d', ii, f(ii)));
end

%% sample predictions densely

ff = linspace (f(1),f(8),128);
for jj = 1:ny
    for ii = 1:nx
    params_estimated = fitted_params_2(jj,ii,:);
    y_est_mat_2(jj,ii,:) = fLorentz( ff, params_estimated(:,:,1), params_estimated(:,:,2), params_estimated(:,:,3), params_estimated(:,:,4));
    end
end

%% dynamically look at pixels of fitted f0

hFigSSE = figure;
hImageSSE = imagesc(fitted_params_2(:,:,1)/1e3);
% caxis([200e3 350e3])
colorbar;
title('f0')

data_est = squeeze(y_est_mat_2(25,25,:));

% create a point object for the GUI
figure(hFigSSE);
if exist('hPoint')
    clear hPoint;
end
hPoint = impoint(gca,25,25);
hPoint.setColor('w');
hFigDataAtPoint = figure();
subplot(121);
hLineDataAbs = line(f,abs(data_px),'marker','o');
hLineEstAbs = line(ff,abs(data_est),'color','r');
legend('Measured Magnitude', 'Estimated Magnitude');
subplot(122);
hLineDataPhase = line(f,angle(data_px),'marker','o');
hLineEstPhase = line(ff,angle(data_est),'color','r');
legend('Measured Phase', 'Estimated Phase');

% set up callback
addNewPositionCallback( hPoint, @(p) pointCallback(p,lockin_compl_mat,y_est_mat_2,hLineDataAbs,hLineDataPhase,hLineEstAbs,hLineEstPhase));


%% dynamically look at pixels of fitted Q

hFigSSE = figure;
hImageSSE = imagesc(fitted_params_2(:,:,3));
caxis([0 50])
colorbar;
title('Q')

data_est = squeeze(y_est_mat_2(25,25,:));

% create a point object for the GUI
figure(hFigSSE);
if exist('hPoint')
    clear hPoint;
end
hPoint = impoint(gca,25,25);
hPoint.setColor('w');
hFigDataAtPoint = figure();
subplot(121);
hLineDataAbs = line(f,abs(data_px),'marker','o');
hLineEstAbs = line(ff,abs(data_est),'color','r');
legend('Measured Magnitude', 'Estimated Magnitude');
subplot(122);
hLineDataPhase = line(f,angle(data_px),'marker','o');
hLineEstPhase = line(ff,angle(data_est),'color','r');
legend('Measured Phase', 'Estimated Phase');

% set up callback
addNewPositionCallback( hPoint, @(p) pointCallback(p,lockin_compl_mat,y_est_mat_2,hLineDataAbs,hLineDataPhase,hLineEstAbs,hLineEstPhase));

%% dynamically look at pixels of r-squared

hFigSSE = figure;
hImageSSE = imagesc(rsq);
caxis([0 1])
colorbar;
title('R-Squared Goodness of Fit Map')

data_est = squeeze(y_est_mat_2(25,25,:));

% create a point object for the GUI
figure(hFigSSE);
if exist('hPoint')
    clear hPoint;
end
hPoint = impoint(gca,25,25);
hPoint.setColor('w');
hFigDataAtPoint = figure();
subplot(121);
hLineDataAbs = line(f,abs(data_px),'marker','o');
hLineEstAbs = line(ff,abs(data_est),'color','r');
legend('Measured Magnitude', 'Estimated Magnitude');
subplot(122);
hLineDataPhase = line(f,angle(data_px),'marker','o');
hLineEstPhase = line(ff,angle(data_est),'color','r');
legend('Measured Phase', 'Estimated Phase');

% set up callback
addNewPositionCallback( hPoint, @(p) pointCallback(p,lockin_compl_mat,y_est_mat_2,hLineDataAbs,hLineDataPhase,hLineEstAbs,hLineEstPhase));
%% callback functions for GUI
function pointCallback(p,lockin_compl_mat,y_est_mat_2,hLineDataAmp,hLineDataPhase,hLineEstAmp,hLineEstPhase)
        
    pxi = round(p(1))
    pxj = round(p(2))
    
    
    data_px = squeeze(lockin_compl_mat(pxj,pxi,:));
    data_est = squeeze(y_est_mat_2(pxj,pxi,:));
    
    set(hLineDataAmp,'YData',abs(data_px));
    set(hLineEstAmp,'YData',abs(data_est));

    set(hLineDataPhase,'YData',angle(data_px));
    set(hLineEstPhase,'YData',angle(data_est));
    drawnow;
end