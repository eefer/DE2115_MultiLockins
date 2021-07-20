%Plotting histograms from MAFLIA data

%This script can be run after EightLockins_fitter.m is used to process a
%set of MAFLIA data in a .mat file.


%f0 image
figure
imagesc(fitted_params_2(:,:,1))

%f0 histogram
figure
histogram(fitted_params_2(:,:,1))
xlabel('f0 (Hz)')
title('Histogram of f0 values for image from test03-210522.csv')

%Q image
figure
imagesc(fitted_params_2(:,:,2))

%Q histogram
figure
histogram(fitted_params_2(:,:,2),1000000)
xlim([-100 1000])
xlabel('Q (unitless)')
title('Histogram of Q values for image from test03-210522.csv')