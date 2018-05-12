%% modified on 19th Apr for complex fitting. 
clc; clear all; close all;

load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\x5.mat');
f= 200080:19979:339937; % freq in Hertz, for x5
initial_guess = [280000,100,12,0,0];

%% prepare complex matrix
% prepare data as ny x nx x nf 3D array
nf = numel(XY)/2;
[ny, nx] = size(XY{1});

lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);

lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;

dataList = reshape(lockin_compl_mat,[ny*nx,nf]);

%% fit the entire datalist

% fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e4)); %Adding linear phase term

opts=  optimset('display','off');

fit_list_allparams = [];
tic;
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4), params(5))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
%     initial_guess = params_estimated;
end
toc;

%% reshape and plot
image_array = reshape(fit_list_allparams,[ny,nx,5]);
figure(1);
imagesc(image_array(:,:,1) / 1e6);
caxis([0.29,.32]);
colorbar;
title('f0, MHz')

figure(2);
imagesc(image_array(:,:,3));
caxis([0,14]);
colorbar
title('Q')

error_array = reshape(function_values,[ny,nx]);
figure(3);
imagesc(error_array);
caxis([0,2000000]);
colorbar
title('Sum squared error')
