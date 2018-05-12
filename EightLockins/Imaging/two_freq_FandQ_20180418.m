%% from single point DART mathcad sheet
clc; clear all; close all;

load('T:\projects\WilsonGroup\8 lockins\data\NIST Data 2018_03_05\NIST Data\x5.mat');
f= 200080:19979:339937; % freq in Hertz, for Y5

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

%% Trial run amp fitting on a selected pixel
% extract the amp from a random pixel 
pxi = 700;
pxj = 200;
amp = squeeze(lockin_amp_mat(pxj,pxi,:));
%figure (1);
plot (f,amp,'o','markersize',14);
xlabel('Frequencies in Hz');
ylabel('Amp arbitrary');


% define the lorentzian for the amplitude and plot the initial guess
fLorentz= @(f, f0, A, Q) f0.^2 .* A ./ sqrt ((f0.^2-f.^2).^2+(f0.*f./Q).^2);
ff =linspace (f(1),f(8),128);
line(ff,fLorentz(ff,2.7e5,34,10),'Color','r');


% fit it!
params0 = [2.7e5,34,10];
fitFn = @(params) sum(abs(amp' - fLorentz( f, params(1), params(2), params(3))).^2);
params_estimated = fminunc( fitFn, params0 );
y_estimated = fLorentz( ff, params_estimated(1), params_estimated(2), params_estimated(3));
line (ff,y_estimated,'Color','k');

f0est = params_estimated(1);
Aest = params_estimated(2);
Qest = params_estimated(3);

legend('measured data','initial guess','fit')
title(sprintf('Fit pixel (%i,%i): f0=%0.2f MHz, A=%0.1f, Q=%0.1f',pxi,pxj,f0est/1e6,Aest,Qest))

%% select the right frequencies from the max amplitude and compute
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
imagesc(real(f0)/1e6);
caxis([.2,.45]);
colorbar;
title('f0, MHz');

figure(2);
colorbar;
imagesc(real(Q));
caxis([0,100]);
colorbar;
title('Q');