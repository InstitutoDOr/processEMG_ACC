function [signal_convolved  hrf] = convolveHRF( signal, srate )

% initiate spm if function does not exist
if exist( 'spm_get_bf' ) ~= 2
    spm( 'fmri')
end

xbf.dt = 1/srate;
xbf.name = 'hrf';
bf = spm_get_bf(xbf);
U.u = signal;
U.name = {'reg'};
% create the regressor convolved with the HRF
signal_convolved = spm_Volterra(U, bf.bf);

hrf = bf.bf;

end

