function RMS_EMG_EXE( emgfiles, rootdir, delays )

addpath( 'load_acq_20110222' );


figure
for k =1 :length( emgfiles )

    fs_emg = 1000;
    duration_block_activation = 20 ; %  em segundos 
    duration_block_repouso = 20; % em segundos 
    numBlocks = 2; % numero de pares de blocos

    % delay
    subjid = str2num( emgfiles(k).name(32:34) );
    subj_ind = find( delays(:,1) == subjid );
    if isempty( subj_ind  ), continue, end;
    
    delay_subject = delays(subj_ind,2) * fs_emg;
    
    if isnan( delay_subject ), continue, end;
    
    start_index_repouso = 1 + delay_subject; % cortado no inicio do run

    duration_block_activation_pts = duration_block_activation * fs_emg;
    duration_block_repouso_pts = duration_block_repouso * fs_emg;

    blocks=1:numBlocks;

    dur_block_pair = duration_block_activation_pts+duration_block_repouso_pts;

    start_inds_repouso = [start_index_repouso + (blocks-1)*dur_block_pair];
    start_inds_activation = [start_index_repouso+duration_block_repouso_pts+(blocks-1)*dur_block_pair];

    offset = 2 * fs_emg; % cortar inicio de cada bloco para compensar pelo delay da resposta do sujeito

    inds_repouso = [];
    inds_activation = [];

    for b=1:length(start_inds_activation)

        inds_repouso    = [inds_repouso start_inds_repouso(b)+offset:start_inds_repouso(b)+duration_block_repouso_pts];
        inds_activation = [inds_activation start_inds_activation(b)+offset:start_inds_activation(b)+duration_block_activation_pts];

    end


    emg = load_acq( fullfile( rootdir, emgfiles(k).name ) );
    emg.data = emg.data / 2; % convert in mV (gain was 2000)
    
    
    inds_repouso_subj = inds_repouso;
    inds_activation_subj = inds_activation;

    % remove inicial data points
    m = min( inds_repouso_subj ) - offset;
    emg.data(1:m-1) = [];
    
    inds_repouso_subj       = inds_repouso_subj - m+1;
    inds_activation_subj    = inds_activation_subj - m+1;
    
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

