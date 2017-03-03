accfiles = { 'MOTOR_BLIND_20120712_M_TESTE_repouso_Raw Data.dat', ...
    'MOTOR_BLIND_20120712_M_movimento_Raw Data.dat', ...
    'MOTOR_BLIND_20120712_M_isometria_Raw Data.dat', ...
    'MOTOR_BLIND_20120712_M_contraçao leve_Raw Data.dat' };
    
emgfiles = { '../../EMG/MOTOR_BLIND_20120712_M_TESTE_repouso' , ...
    '../../EMG/MOTOR_BLIND_20120712_M_movimento' , ...
    '../../EMG/MOTOR_BLIND_20120712_M_isometria' , ...
    '../../EMG/MOTOR_BLIND_20120712_M_contraçao leve' , ...
    };

tits = {'Repouso', 'Apertar Buzina', 'Contração isométrica', 'Contração leve' };
fs =100;

% index acc, index emg, duration
start_index_duration = [ 1 1 30*fs; ...
                        1200 2900 24*fs; ...
                        1800 3700 63*fs; ...
                        2200 4000 41*fs ];

close all

figure
for k =1 :length( accfiles )

    fs_acc = 100;
    fs_emg = 1000;

    acc = load( accfiles{k} );
    emg = load( emgfiles{k} );
    
    %% equalize sample rate
    emg.data = emg.data( 1 : fs_emg / fs_acc: end );
    fs_emg = fs_acc ;

    %% prepare Acc
    % first column is channel number, x,z, are channel 9, 10 ,11
    acc = acc(9:11,2:end)'; 
    acc = sqrt( sum( acc.*acc, 2 ) ); % calculate 2-norm

    acc = filterpass( acc, 0.5, fs_acc, 'high', 2); % remove baseline
    
    acc = acc / 1000 / 240; % convert units to multiple of g = 9,81 m / s^2

    emg.data = emg.data / 2; % convert in mV (gain was 2000)
    
    %% sincronize acc with emg
%     [c lag] = crosscorr( abs(acc), abs(emg.data), ceil( size( emg.data,1) / 2 ) );
%     [m ind] = max( c );
%     initEMG = lag(ind);
%     emg.data(1:initEMG-1) = [];
    
    
    start_acc = start_index_duration(k,1);
    stop_acc  = start_index_duration(k,1) + start_index_duration(k,3);
    start_emg = start_index_duration(k,2);
    stop_emg  = start_index_duration(k,2) + start_index_duration(k,3);
    
    rms(k,1) = calcRMS( acc(start_acc:stop_acc) );
    rms(k,2) = calcRMS( emg.data(start_emg:stop_emg) );
    
    rmsRepousoInicio(k,1) = calcRMS( acc(1:start_acc) );
    rmsRepousoInicio(k,2) = calcRMS( emg.data(1:start_emg) );
 
    rmsRepousoEnd(k,1) = calcRMS( acc(stop_acc:end) );
    rmsRepousoEnd(k,2) = calcRMS( emg.data(stop_emg:end) );
    
    rmsTotal(k,1) = calcRMS( acc );
    rmsTotal(k,2) = calcRMS( emg.data );
 
    
    subplot( length( accfiles ), 2, 2*k-1);
    plotWithSecondsTick( acc, fs_acc, ' x 9.81 m/s^2 ' );
    title( sprintf( 'Acc - %s - RMS = %.4g - RMS/RMSrep=%4f', tits{k}, rms(k,1), rms(k,1) / rms(1,1) ) )
    line([start_acc start_acc],get(gca,'ylim'),'color','r')
    line([stop_acc stop_acc],get(gca,'ylim'),'color','r')
    
    subplot( length( accfiles ), 2, 2*k);
    plotWithSecondsTick( emg.data, fs_emg, 'mV' );        
    title( sprintf( 'EMG - %s - RMS = %.4g - RMS/RMSrep=%4f', tits{k}, rms(k,2), rms(k,2) / rms(1,2) ) )
    line([start_emg start_emg],get(gca,'ylim'),'color','r')
    line([stop_emg stop_emg],get(gca,'ylim'),'color','r')
    
    

end
%% no final: comparar RMS_tarefa_acc/RMS_repouso_acc com RMS_tarefa_emg/RMS_repouso_emg



% figure
% plot( emg.data );
% hold on
% plot( y, 'k' );
% legend( 'unfiltered', 'high pass' )
