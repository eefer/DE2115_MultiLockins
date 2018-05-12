%% from single point DART mathcad sheet
clc; clear all; close all;

load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\x5.mat');

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
%% select the right frequencies from the max amplitude and compute
f= 200080:19979:339937; % freq in Hertz, for x5
for ii = 1:nx
    for jj = 1:ny
        [first_max_amplitude,first_index] = max (lockin_amp_mat(jj,ii,:));
        first_max_phase = lockin_phase_mat(jj,ii,first_index);
        first_max_freq = f(first_index);
        if (first_index == 1)
            second_max_amplitude = lockin_amp_mat(jj,ii,2);
            second_max_phase = lockin_phase_mat(jj,ii,2);
            second_max_freq = f(2);
        elseif(first_index == 8)
            second_max_amplitude = lockin_amp_mat(jj,ii,7);
            second_max_phase = lockin_phase_mat(jj,ii,7);
            second_max_freq = f(7);            
        else
            if (lockin_amp_mat(jj,ii,first_index-1) > lockin_amp_mat(jj,ii,first_index+1))
                second_max_amplitude = lockin_amp_mat(jj,ii,first_index-1);
                second_max_phase = lockin_phase_mat(jj,ii,first_index-1);
                second_max_freq = f(first_index-1);        
            else
                second_max_amplitude = lockin_amp_mat(jj,ii,first_index+1);
                second_max_phase = lockin_phase_mat(jj,ii,first_index+1);
                second_max_freq = f(first_index+1);                
            end
        end
        % two maximum amplitudes, freqs and phase available now ; do the computation
        %% computation
        F1 = first_max_freq;
        F2 = second_max_freq;
        A1 = first_max_amplitude;
        A2 = second_max_amplitude;
        p1 = first_max_phase;
        p2 = second_max_phase;
        omega = F1*A1/(F2*A2);
        fi = tan (p2-p1);
        X1 = (-1+ ((sign(fi))/omega)*sqrt(1+fi^2))/fi;
        X2 = (1- (sign(fi))*omega* sqrt(1+fi^2))/fi;
        f0(jj,ii) = sqrt(F1*F2*(F2*X1-F1*X2)/(F1*X1-F2*X2));
        Q(jj,ii) = sqrt(F1*F2*(F2*X1-F1*X2)*(F1*X1-F2*X2))/(F2^2-F1^2);
    end
end

%% Plot

figure(1);
imagesc(abs(f0)/1e6);
caxis([.29,0.32]);
colorbar;
title('f0, MHz');

figure(2);
colorbar;
imagesc(abs(Q));
caxis([0,14]);
colorbar;
title('Q');