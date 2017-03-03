clear all;

rootdir = 'Z:\PROJETOS\PRJ1206_BLINDNESS\03_PROCS\ACCELEROMETRO\Export';

files( rootdir );

accfiles = { 'MOTOR_BLIND_20120723_PILO0010001_Raw Data.dat', ...
    'MOTOR_BLIND_20120723_PILO0010002_Raw Data.dat', ...
    'MOTOR_BLIND_20120723_PILO0010004_SENTIR_SE_Edit Markers.dat', ...
    'MOTOR_BLIND_20120723_PILO0010005_SENTIR_SE_DEDO_Edit Markers.dat', ...
    'MOTOR_BLIND_20120723_PILO0010005_SENTIR_SE_DEDO_Segment 1.dat'};
    

tits = {'Repouso - Tendão', 'Apertar Buzina - Tendão', 'Sentir-se - Tendão', 'Sentir-se - Dedo', 'Movimento Leve - Dedo'  };

% index acc
start_index_repouso = [ 14000; 5398; 5541; 6650; 1 ];
duration_block = 1000; % 10 seconds
numBlocks = 9;

inds_repouso = [];
inds_activation = [];
    
b=1:numBlocks;
for k=1:length(start_index_repouso)
    
    start_inds_repouso(k,:) = [start_index_repouso(k)+(b-1)*2*duration_block];
    start_inds_activation(k,:) = [start_index_repouso(k)+duration_block+(b-1)*2*duration_block];
    
end

start_inds_activation(5,:) = 0;
start_inds_repouso(5,:) = 0;
offset = 50;
for f=1:size(start_inds_repouso,1)

    inds_repouso{f} = [];
    inds_activation{f} = [];
     
    for b=1:size(start_inds_activation,2)

        inds_repouso{f}    = [inds_repouso{f} start_inds_repouso(f,b)+offset:start_inds_repouso(f,b)+duration_block-offset];
        inds_activation{f} = [inds_activation{f} start_inds_activation(f,b):start_inds_activation(f,b)+duration_block];
        
    end
end

offset = 10;
start_inds_activation(5,:) = [351 605 895 1199 1199 1199 1199 1199 1199];
inds_activation{5} = [351-offset:351+offset  605-offset:605+offset 895-offset:895+offset 1199-offset:1199+offset ];
inds_repouso{5} = [1:500];

close all

figure
for k =1 :length( accfiles )

    fs_acc = 100;

    acc = load( accfiles{k} );

    %% prepare Acc
    % first column is channel number, x,z, are channel 9, 10 ,11
    acc = acc(9:11,2:end)'; 
    acc = sqrt( sum( acc.*acc, 2 ) ); % calculate 2-norm

    acc = filterpass( acc, 0.5, fs_acc, 'high', 2); % remove baseline
    
    acc = acc / 1000 / 240; % convert units to multiple of g = 9,81 m / s^2

    start_acc = start_inds_repouso(k,1);
    stop_acc  = start_inds_activation(k,1);
    
    rmsRepouso(k,1) = calcRMS( acc(inds_repouso{k}) );
    
    rmsActivation(k,1) = calcRMS( acc(inds_activation{k}) );
    
    subplot( length( accfiles ), 1, k);
    plotWithSecondsTick( acc, fs_acc, ' x 9.81 m/s^2 ' );
    title( sprintf( ' %s RMS(tarefa) = %.4g RMS(repouso)=%.4g', tits{k}, rmsActivation(k,1), rmsRepouso(k,1) ) )
    ylim([-1.3 1.3])
    line([start_inds_repouso(k,:); start_inds_repouso(k,:)] , repmat( get(gca,'ylim')', 1, size(start_inds_repouso,2) ) ,'color',[.8 .8 .8])
    line([start_inds_activation(k,:); start_inds_activation(k,:)] , repmat( get(gca,'ylim')', 1, size(start_inds_activation,2) ) ,'color','r')
    
end
%% no final: comparar RMS_tarefa_acc/RMS_repouso_acc com RMS_tarefa_emg/RMS_repouso_emg



% figure
% plot( emg.data );
% hold on
% plot( y, 'k' );
% legend( 'unfiltered', 'high pass' )
