%% Script to process CSV data transferred to RPi from the GPIO poins of the FPGA
% Developer: Saurabh Gupta, Colorado State University
clc; clear all; close all;
data = csvread('C:\Users\saurabhg\Desktop\temp\ru2.csv',1,3); % skips header
x1 = data(:,1);
y1 = data(:,2);
x2 = data(:,3);
y2 = data(:,4);
x3 = data(:,5);
y3 = data(:,6);
x4 = data(:,7);
y4 = data(:,8);
x5 = data(:,9);
y5 = data(:,10);
x6 = data(:,11);
y6 = data(:,12);
x7 = data(:,13);
y7 = data(:,14);
x8 = data(:,15);
y8 = data(:,16);
pix = sqrt (size(data,1));

%% calculate amplitudes
for i = (1:size(data,1))
    lockin_1_amp(i,1) = sqrt (x1(i,1)^2)+(y1(i,1)^2);
    lockin_2_amp(i,1) = sqrt (x2(i,1)^2)+(y2(i,1)^2);
    lockin_3_amp(i,1) = sqrt (x3(i,1)^2)+(y3(i,1)^2);
    lockin_4_amp(i,1) = sqrt (x4(i,1)^2)+(y4(i,1)^2);
    lockin_5_amp(i,1) = sqrt (x5(i,1)^2)+(y5(i,1)^2);
    lockin_6_amp(i,1) = sqrt (x6(i,1)^2)+(y6(i,1)^2);
    lockin_7_amp(i,1) = sqrt (x7(i,1)^2)+(y7(i,1)^2);
    lockin_8_amp(i,1) = sqrt (x8(i,1)^2)+(y8(i,1)^2);
end

% calculate phase
for i = (1:size(data,1))
    lockin_1_phase(i,1) = atan(y1(i,1)/x1(i,1));
    lockin_2_phase(i,1) = atan(y2(i,1)/x2(i,1));
    lockin_3_phase(i,1) = atan(y3(i,1)/x3(i,1));
    lockin_4_phase(i,1) = atan(y4(i,1)/x4(i,1));
    lockin_5_phase(i,1) = atan(y5(i,1)/x5(i,1));
    lockin_6_phase(i,1) = atan(y6(i,1)/x6(i,1));
    lockin_7_phase(i,1) = atan(y7(i,1)/x7(i,1));
    lockin_8_phase(i,1) = atan(y8(i,1)/x8(i,1));
    
end

%% Plot outputs
figure;
lockin_1_amp = reshape(lockin_1_amp,pix,[]);
imagesc(lockin_1_amp);
colorbar;
title ('Lockin 1 amplitude');

figure;
lockin_1_phase = reshape(lockin_1_phase,pix,[]);
imagesc(lockin_1_phase);
colorbar;
title ('Lockin 1 phase in rad');

figure;
lockin_2_amp = reshape(lockin_2_amp,pix,[]);
imagesc(lockin_2_amp);
colorbar;
title ('Lockin 2 amplitude');

figure;
lockin_2_phase = reshape(lockin_2_phase,pix,[]);
imagesc(lockin_2_phase);
colorbar;
title ('Lockin 2 phase in rad');

figure;
lockin_3_amp = reshape(lockin_3_amp,pix,[]);
imagesc(lockin_3_amp);
colorbar;
title ('Lockin 3 amplitude');

figure;
lockin_3_phase = reshape(lockin_3_phase,pix,[]);
imagesc(lockin_3_phase);
colorbar;
title ('Lockin 3 phase in rad');

figure;
lockin_4_amp = reshape(lockin_4_amp,pix,[]);
imagesc(lockin_4_amp);
colorbar;
title ('Lockin 4 amplitude');

figure;
lockin_4_phase = reshape(lockin_4_phase,pix,[]);
imagesc(lockin_4_phase);
colorbar;
title ('Lockin 4 phase in rad');

figure;
lockin_5_amp = reshape(lockin_5_amp,pix,[]);
imagesc(lockin_5_amp);
colorbar;
title ('Lockin 5 amplitude');

figure;
lockin_5_phase = reshape(lockin_5_phase,pix,[]);
imagesc(lockin_5_phase);
colorbar;
title ('Lockin 5 phase in rad');

figure;
lockin_6_amp = reshape(lockin_6_amp,pix,[]);
imagesc(lockin_6_amp);
colorbar;
title ('Lockin 6 amplitude');

figure;
lockin_6_phase = reshape(lockin_6_phase,pix,[]);
imagesc(lockin_6_phase);
colorbar;
title ('Lockin 6 phase in rad');

figure;
lockin_7_amp = reshape(lockin_7_amp,pix,[]);
imagesc(lockin_7_amp);
colorbar;
title ('Lockin 7 amplitude');

figure;
lockin_7_phase = reshape(lockin_7_phase,pix,[]);
imagesc(lockin_7_phase);
colorbar;
title ('Lockin 7 phase in rad');

figure;
lockin_8_amp = reshape(lockin_8_amp,pix,[]);
imagesc(lockin_8_amp);
colorbar;
title ('Lockin 8 amplitude');

figure;
lockin_8_phase = reshape(lockin_8_phase,pix,[]);
imagesc(lockin_8_phase);
colorbar;
title ('Lockin 8 phase in rad');