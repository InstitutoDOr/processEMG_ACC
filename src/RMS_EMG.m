function RMS_EMG( emgfiles, rootdir )

addpath( 'load_acq_20110222' );

fs_emg = 1000;
duration_block_activation = 20 ; %  em segundos 
duration_block_repouso = 20; % em segundos 
numBlocks = 2; % numero de pares de blocos
start_index_repouso = 1; % cortado no inicio do run


duration_block_activation_pts = duration_block_activation * fs_emg;
duration_block_repouso_pts = duration_block_repouso * fs_emg;
 
blocks=1:numBlocks;
    
dur_block_pair = duration_block_activation_pts+duration_block_repouso_pts;

start_inds_repouso = [start_index_repouso + (blocks-1)*dur_block_pair];
start_inds_activation = [start_index_repouso+duration_block_repouso_pts+(blocks-1)*dur_block_pair];
    

offset = 1 * fs_emg; % cortar inicio de cada bloco para compensar pelo delay da resposta do sujeito

inds_repouso = [];
inds_activation = [];

for b=1:length(start_inds_activation)

    inds_repouso    = [inds_repouso start_inds_repouso(b)+offset:start_inds_repouso(b)+duration_block_repouso_pts];
    inds_activation = [inds_activation start_inds_activation(b)+offset:start_inds_activation(b)+duration_block_activation_pts];

end

figure
for k =1 :length( emgfiles )
    
    emg = load_acq( fullfile( rootdir, emgfiles(k).name ) );
    emg.data = emg.data / 2; % convert in mV (gain was 2000)
    
    % tratamento especial para o sujeito 1 que teve um protocolo diferente
    % (repouso maior)
    if strfind( emgfiles(k).name , 'SUBJ001' )
        bloco_repouso_a_cortar = emg.data( 40*fs_emg+1:70*fs_emg, 1 );
        emg.data( 90*fs_emg+1:end, :) = [];
        emg.data( 40*fs_emg+1:70*fs_emg, : ) = [];
        emg.data = [emg.data ; bloco_repouso_a_cortar];
    end
    
    % tratamento especial para o sujeito 1 e 2 que tem ordem repouso e
    % ativacao trocado 
    if ~isempty(strfind( emgfiles(k).name , 'SUBJ001' )) || ~isempty(strfind( emgfiles(k).name , 'SUBJ002' ))
        inds_repouso_subj = inds_activation;
        inds_activation_subj = inds_repouso;
    else
        inds_repouso_subj = inds_repouso;
        inds_activation_subj = inds_activation;
    end
    
    
    inds_repouso_subj( inds_repouso_subj > size( emg.data, 1 ) ) = [];
    inds_activation_subj( inds_activation_subj > size( emg.data, 1 ) ) = [] ;
    
    % esse index é usado para cortar o final do sinal
    last_point_index = max( [inds_activation_subj inds_repouso_subj] );
    
    tit = makeTitle( emgfiles(k).name );

    ylimits = [-1 1];
    [rmsActivation(k,1) rmsRepouso(k,1) valor_p ] = calcAndPlotRMS( emg.data(1:last_point_index, 1), inds_repouso_subj, inds_activation_subj, fs_emg, ' mV ', 'EMG', tit, length( emgfiles ), k , ylimits)

    R{k,1} = tit;
    R{k,2} = rmsActivation(k,1);
    R{k,3} = rmsRepouso(k,1);
    R{k,4} = rmsActivation(k,1)/rmsRepouso(k,1);
    R{k,5} = sprintf('%.2g', valor_p);
    
end

header = {'', 'RMS Ativacao' , 'RMS Repouso' , 'RMS Ativacao/RMS Repouso', 'valor p do teste t do sinal retificado' };
R = [header; R];

xlswrite( ['EMG-' datestr( now, 'yyyymmdd-HHMMSS' )], R);

