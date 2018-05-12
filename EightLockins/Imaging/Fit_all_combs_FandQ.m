%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\x5.mat'); %%CHANGE
f= 200080:19979:339937; %%change
initial_guess = [280000,100,12,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\FandQ\x5.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\y1.mat'); %%CHANGE
f= 1692581:2479:1709938; %%change
initial_guess = [1700000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\FandQ\y1.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\y2.mat'); %%CHANGE
f= 313568:2479:330924; %%change
initial_guess = [321000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\FandQ\y2.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\y3.mat'); %%CHANGE
f= 982570:2479:999927; %%change
initial_guess = [990000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\FandQ\y3.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\y4.mat'); %%CHANGE
f= 1002550:2479:1019906; %%change
initial_guess = [1010000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\FandQ\y4.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\y5.mat'); %%CHANGE
f= 979948:10013:1050043; %%change
initial_guess = [1010000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\FandQ\y5.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\y6.mat'); %%CHANGE
f= 749921:50020:1100063; %%change
initial_guess = [900000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\FandQ\y6.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\NIST data 13mar18\x0.mat'); %%CHANGE
f= 147961:5006:183010; %%change
initial_guess = [163000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\FandQ\x0.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\NIST data 13mar18\x1.mat'); %%CHANGE
f= 132942:10013:203037; %%change
initial_guess = [163000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\FandQ\x1.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\NIST data 13mar18\x2.mat'); %%CHANGE
f= 144958:10013:215053; %%change
initial_guess = [175000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\FandQ\x2.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\NIST data 13mar18\z2.mat'); %%CHANGE
f= 300073:19979:439929; %%change
initial_guess = [360000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\FandQ\z2.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\NIST data 13mar18\z3.mat'); %%CHANGE
f= 270000:29993:479984; %%change
initial_guess = [360000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\FandQ\z3.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\NIST data 13mar18\z4.mat'); %%CHANGE
f= 57983:1001:64992; %%change
initial_guess = [60987,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\FandQ\z4.mat'); %%change
%%
clear all;
load('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\NIST data 13mar18\z5.mat'); %%CHANGE
f= 60987:1001:67996; %%change
initial_guess = [64000,100,50,0]; %%change
nf = numel(XY)/2;
[ny, nx] = size(XY{1});
lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);
lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;
dataList = reshape(lockin_compl_mat,[ny*nx,nf]);
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
% fLorentz = @(f, f0, A, Q, phi0, phiLin) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* (phi0 + f.*phiLin./1e6)); %Adding linear phase term
opts=  optimset('display','off');
fit_list_allparams = [];
for ii = 1:size(dataList,1)
    data_px = dataList(ii,:);
    fitFn = @(params) sum(abs(data_px - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
    [params_estimated,fval] = fminunc( fitFn, initial_guess,opts);
    fit_list_allparams(ii,:) = params_estimated;
    function_values(ii,:) = fval;
end
save ('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\FandQ\z5.mat'); %%change
