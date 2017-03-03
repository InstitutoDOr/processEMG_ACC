function [signal_convolved] = RMS_accelerometro_convolve( accfiles, signal, srate )

figure,

for k=1:length( signal )
   
    [signal_convolved{k} hrf] = convolveHRF( signal{k}, srate );

    subplot(length(signal),1,k)
    plotWithSecondsTick( signal{k}, srate, '' );    
    hold on
    plot( signal_convolved{k}, 'r' , 'Linewidth', 2)
    plot( hrf, 'k', 'Linewidth', 2)
    legend( {'RMS ACC', 'RMS ACC * HRF', 'HRF' } )

end

end