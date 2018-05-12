%%load data
load('T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\FandQ\z5.mat');

%% reshape and plot
image_array = reshape(fit_list_allparams,[ny,nx,4]);
figure(1);
imagesc(image_array(:,:,1) / 1e6);
caxis([0.056,0.067]);
colorbar;
title('f0, MHz')

figure(2);
imagesc(image_array(:,:,3));
caxis([0,60]);
colorbar
title('Q')

error_array = reshape(function_values,[ny,nx]);
figure(3);
imagesc(error_array);
caxis([0,8000000]);
colorbar
title('Sum squared error')