function RMS_EMG_IMAG( emgfiles, rootdir, delays, ordem )

addpath( 'load_acq_20110222' );

fs_emg = 1000;
duration_block_activation = 20 ; %  em segundos 
duration_block_repouso = 20; % em segundos 
numBlocks = 4; % numero de pares de blocos


duration_block_activation_pts = duration_block_activation * fs_emg;
duration_block_repouso_pts = duration_block_repouso * fs_emg;
 
blocks=1:numBlocks;
    
dur_block_pair = duration_block_activation_pts+duration_block_repouso_pts;

offset = 2 * fs_emg; % cortar inicio de cada bloco para compensar pelo delay da resposta do sujeito


for k =1 :length( emgfiles )

    % delay
    subjid = str2num( emgfiles(k).name(32:34) );
    subj_ind = find( delays(:,1) == subjid );
    if isempty( subj_ind  ), continue, end;
    
    delay_subject = delays(subj_ind,3) * fs_emg;
    
    if isnan( delay_subject ), continue, end;
    
    start_index_repouso = 1 + delay_subject; % cortado no inicio do run

    start_inds_repouso = [start_index_repouso + (blocks-1)*dur_block_pair];
    start_inds_activation = [start_index_repouso+duration_block_repouso_pts+(blocks-1)*dur_block_pair];

    % two conditions
    inds_repouso{1} = [];
    inds_activation{1} = [];
    
    inds_repouso{2} = [];
    inds_activation{2} = [];
    
    % first two blocks are one imaginary condition
    for b=1:2
        
        inds_repouso{1}    = [inds_repouso{1} start_inds_repouso(b)+offset:start_inds_repouso(b)+duration_block_repouso_pts];
        inds_activation{1} = [inds_activation{1} start_inds_activation(b)+offset:start_inds_activation(b)+duration_block_activation_pts];
        
    end
    
    % last two blocks are other imaginary condition
    for b=3:4
        
        inds_repouso{2}    = [inds_repouso{2} start_inds_repouso(b)+offset:start_inds_repouso(b)+duration_block_repouso_pts];
        inds_activation{2} = [inds_activation{2} start_inds_activation(b)+offset:start_inds_activation(b)+duration_block_activation_pts];
        
    end
    
    % check ordem
    if strcmp( ordem{subj_ind}, '3P' )
        h_rep = inds_repouso{1};
        h_act = inds_activation{1};
        inds_repouso{1}    = inds_repouso{2};
        inds_activation{1} = inds_activation{2};
        inds_repouso{2}    = h_rep;
        inds_activation{2} = h_act;
    end
    
    for cond = 1:2
        
        figure

        emg = load_acq( fullfile( rootdir, emgfiles(k).name ) );
        emg.data = emg.data / 2; % convert in mV (gain was 2000)
        
        tit = makeTitle( emgfiles(k).name );
        
        R{k,1} = tit;

        inds_repouso_subj = inds_repouso{cond};
        inds_activation_subj = inds_activation{cond};
        
        % remove inicial data points
        m = min( inds_repouso_subj ) - offset;
        emg.data(1:m-1) = [];
        
        inds_repouso_subj       = inds_repouso_subj - m+1;
        inds_activation_subj    = inds_activation_subj - m+1;
        
        inds_repouso_subj( inds_repouso_subj > size( emg.data, 1 ) ) = [];
        inds_activation_subj( inds_activation_subj > size( emg.data, 1 ) ) = [] ;
    
        % esse index é usado para cortar o final do sinal
        last_point_index = max( [inds_activation_subj inds_repouso_subj] );
        
        ylimits = [-1 1];
        [rmsActivation(k,1) rmsRepouso(k,1) valor_p ] = calcAndPlotRMS( emg.data(1:last_point_index, 1), inds_repouso_subj, inds_activation_subj, fs_emg, ' mV ', 'EMG', tit, length( emgfiles ), k , ylimits)

        R{k,2+(cond-1)*3} = rmsActivation(k,1);
        R{k,3+(cond-1)*3} = rmsRepouso(k,1);
        R{k,4+(cond-1)*3} = rmsActivation(k,1)/rmsRepouso(k,1);
        
    end
    
end

header = {'', 'RMS_Ativacao_1P' , 'RMS_Repouso_1P' , 'RMS_Ativacao_1P/RMS_Repouso_1P', 'RMS_Ativacao_3P' , 'RMS_Repouso_3P' , 'RMS_Ativacao_3P/RMS_Repouso_3P' };
R = [header; R];

xlswrite( ['EMG-' datestr( now, 'yyyymmdd-HHMMSS' )], R);

