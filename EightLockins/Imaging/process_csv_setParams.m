%% Script to process CSV data transferred to RPi from the GPIO poins of the FPGA
% Developers: Saurabh Gupta and Jesse Wilson, Wilson Lab, Colorado State University

%%//////////////////////////////////////////////%%%%%%INSTRUCTIONS%%%%%%%////////////////////////////////////////////////////////////////
%   > Copy all the files to the same folder (assisting files contain functions)
%   > Make sure the path to the CSV file is right  ;  Line 18 below
%   > Run THIS script in Matlab
%   > Use the mouse wheel to browse through the image slices
%   > Use the rectangle to assess the average response of a cluster. The rectangle can be moved around and resized
%   > The averaged phase and amplitude response is shown on a plot for all the lockins
%   > HAVE FUN!
%%///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

clc; clear all; close all;

% TODO: MOVE SETTINGS FOR ALL FILE-DEPENDENT PARAMETERS HERE

filename = 'T:\projects\WilsonGroup\8 lockins\data\NIST data 13mar18\NIST data 13mar18\z5.csv';
data = csvread(filename,1,3); % skips header
%

%%

for i = 1:16
    xy{i} = data(:,i);
end

% make for loop, apply to all X and Y images
% ii= 15;
for ii = 1:16
% should be 256x256 after accounting for overscan

% data is a list of samples, scan across x first
% we expect a few dummy rows at the top when done
   
    nx = 997;          % samples per line = (FPGA sample rate) / (AFM line rate)
    ny = floor(length(xy{ii}) / nx);
    startDelay = -71;
    x1_corrected = xy{ii}(1:(nx*ny)); % remove extra pixels if nx*ny < nsamp
    x1_corrected = circshift(x1_corrected,startDelay);
    XY{ii} = reshape(x1_corrected,[nx,ny]).';    
    XY{ii} = fliplr(XY{ii});
%     imagesc(XY{ii});
%     drawnow;

%correct for shear
shear = 1.43;
tform = maketform('affine',[1 0 0; shear 1 0; 0 0 1]);
XY{ii} = imtransform(XY{ii}, tform);
% 
clf
imagesc(XY{ii});
axis image
grid on

% handle flyback / reverse every other row
nx_final = 450;     % valid number of samples per line, in a forward scan (should be nx/2*0.8)
x0_forward = 100;
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

%% save corrected image stack + parameters
save ('z5.mat');




