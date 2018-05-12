%% modified on 19th Apr for complex fitting. 
clc; clear all; close all;

load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\y5.mat');
f= 979948:10013:1050043; % freq in Hertz, for Y5

%% prepare complex matrix
% prepare data as ny x nx x nf 3D array
nf = numel(XY)/2;
[ny, nx] = size(XY{1});

lockin_XY_mat = reshape(cell2mat(XY),[ny,nx,2*nf]);
lockin_X_mat = lockin_XY_mat(:,:,1:2:2*nf); 
lockin_Y_mat = lockin_XY_mat(:,:,2:2:2*nf);

lockin_compl_mat = lockin_X_mat + j*lockin_Y_mat;

%% Trial run amp fitting on a selected pixel
% extract the amp from a random pixel 
pxi = 25;
pxj = 200;
data_px = squeeze(lockin_compl_mat(pxj,pxi,:));

% define the complex lorentzian and plot the initial guess
% fLorentz = @(f, f0, A, Q) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q));
fLorentz = @(f, f0, A, Q, phi0 ) f0.^2 .* (A/Q) ./  ((f0.^2-f.^2) + j.*(f0.*f./Q)) .* exp(j .* phi0);
ff =linspace (f(1),f(8),128);
initial_guess = [1.01e6,100,60,-1.25];
data_est = fLorentz(ff,initial_guess(1),initial_guess(2),initial_guess(3),initial_guess(4));
% figure (1);
% plot (f,real(data_px));
% xlabel('Frequencies in Hz');
% ylabel('Amp arbitrary');
% title('Real part');
% line(f,real(data_est),'Color','r');
% legend ('Measured data','Guessed value');
% ylim([-350,100]);
% 
% 
% figure (2);
% plot (f,imag(data_px));
% xlabel('Frequencies in Hz');
% ylabel('Amp arbitrary');
% title('Imaginary');
% line(f,imag(data_est),'Color','r');
% legend ('Measured data','Guessed value');
% 
% figure (3);
% plot(f, real( data_px.' - data_est ) )
% xlabel('Frequencies in Hz');
% title('Residual: Real');
% ylim([-350,100]);
% 
% figure (4);
% plot(f, imag( data_px.' - data_est ) )
% xlabel('Frequencies in Hz');
% title('Residual: Imaginary');
% ylim([-200,200]);
% 
% 
% figure (5);
% plot(f, abs (data_px) )
% xlabel('Frequencies in Hz');
% title('Magnitude');
% line (f,abs(data_est),'color','r');
% legend ('Measured data','Guessed value');
% 
% figure (6);
% plot(f, phase (data_px) )
% xlabel('Frequencies in Hz');
% title('Phase');
% line (f,phase(data_est),'color','r');
% legend ('Measured data','Guessed value');
%%
% fit it!
fitFn = @(params) sum(abs(data_px.' - fLorentz( f, params(1), params(2), params(3), params(4))).^2);
params_estimated = fminunc( fitFn, initial_guess );
y_estimated = fLorentz( ff, params_estimated(1), params_estimated(2), params_estimated(3), params_estimated(4));

f0est = params_estimated(1);
Aest = params_estimated(2);
Qest = params_estimated(3);
Phi0est = params_estimated(4);

figure (7);
plot(f, abs (data_px),'o','markersize',14);
xlabel('Frequencies in Hz');
ylabel('Magnitude arb');
title(sprintf('Magnitude: Fit pixel (%i,%i): f0=%0.2f MHz, A=%0.1f, Q=%0.1f, Phi =%0.1f rad',pxi,pxj,f0est/1e6,Aest,Qest,Phi0est));
line (ff,abs(data_est),'color','r');
line (ff,abs(y_estimated),'color','k');
legend ('Measured data','Guessed value','Fit');

figure (8);
plot(f, phase (data_px),'o','markersize',14);
xlabel('Frequencies in Hz');
ylabel('Phase rad');
title(sprintf('Phase: Fit pixel (%i,%i): f0=%0.2f MHz, A=%0.1f, Q=%0.1f, Phi =%0.1f rad',pxi,pxj,f0est/1e6,Aest,Qest,Phi0est));
line (ff,phase(data_est),'color','r');
line (ff,phase(y_estimated),'color','k');
legend ('Measured data','Guessed value','Fit');
