function [signal R R_blocos] = RMS_accelerometro_IMAG_MINI_BLOCO( accfiles, rootdir, fs_acc, dur_rest_seg, dur_activation_seg, repetitions, plotar )

R_blocos = [];

if nargin < 4
    duration_block_repouso = 20; % em segundos 
else
    duration_block_repouso = dur_rest_seg;
end

if nargin < 5
    duration_block_activation = 20 ; %  em segundos 
else
    duration_block_activation = dur_activation_seg;
end

if nargin < 6
    numBlocks = 10; % numero de pares de blocos\
else
    numBlocks = repetitions;
end

start_index_repouso = 1;

duration_block_activation_pts = duration_block_activation * fs_acc;
duration_block_repouso_pts = duration_block_repouso * fs_acc;
 
blocks=1:numBlocks;
    
dur_block_pair = duration_block_activation_pts+duration_block_repouso_pts;

start_inds_repouso = [start_index_repouso + (blocks-1)*dur_block_pair];
start_inds_activation = [start_index_repouso+duration_block_repouso_pts+(blocks-1)*dur_block_pair];
    
offset = 2 * fs_acc; % cortar inicio de cada bloco 

inds_repouso_123 = [];
inds_activation_123 = [];

inds_repouso_456 = [];
inds_activation_456 = [];

for b=1:length(start_inds_activation)

    if sum( b == [1 2 3 7 8 9 ] ) > 0
        
        inds_repouso_bloco_123{b}    = start_inds_repouso(b)+offset:start_inds_repouso(b)+duration_block_repouso_pts-2;
        inds_activation_bloco_123{b} = start_inds_activation(b)+offset:start_inds_activation(b)+duration_block_activation_pts-2;
    
        inds_repouso_123    = [inds_repouso_123 inds_repouso_bloco_123{b}];
        inds_activation_123 = [inds_activation_123 inds_activation_bloco_123{b}];

    elseif sum( b == [4 5 6 10 11 12 ] ) > 0
        
        inds_repouso_bloco_456{b}    = start_inds_repouso(b)+offset:start_inds_repouso(b)+duration_block_repouso_pts-2;
        inds_activation_bloco_456{b} = start_inds_activation(b)+offset:start_inds_activation(b)+duration_block_activation_pts-2;
    
        inds_repouso_456    = [inds_repouso_456 inds_repouso_bloco_456{b}];
        inds_activation_456 = [inds_activation_456 inds_activation_bloco_456{b}];
    end
end

% tmp = inds_activation;
% inds_activation = inds_repouso;
% inds_repouso = tmp;

figure

for k =1 :length( accfiles )

    acc = load( fullfile( rootdir, accfiles(k).name ) );

    %% prepare Acc
    % first column is channel number, x,z, are channel 9, 10 ,11
    if size(acc,1) >=11 % recorded with 11 channels
        acc = acc(9:11,2:end)'; 
    else % recorded with 3 channels
        acc = acc(:,2:end)'; 
    end
    acc = sqrt( sum( acc.*acc, 2 ) ); % calculate 2-norm

    acc = filterpass( acc, 0.5, fs_acc, 'high', 2); % remove baseline
    
    % especificacao da unidade do acelerometro: 420mV por g
    acc = acc / 1000 / 420; % convert units to multiple of g = 9,81 m / s^2
        
    tit = makeTitle( accfiles(k).name );

    ylimits = [ -3 3 ];

    n = length( accfiles )
    subplot( n, 1, k);

    for pass=1:2

        % se o subject id for par, comeca com 3P
        if ( mod( str2num( accfiles(k).name(32:34) ) , 2 ) == 0 && pass == 1 && strcmp( accfiles(k).name(41:44), 'RUN2' ) ) || ...
           ( mod( str2num( accfiles(k).name(32:34) ) , 2 ) == 1 && pass == 2 && strcmp( accfiles(k).name(41:44), 'RUN2' ) ) || ...
           ( mod( str2num( accfiles(k).name(32:34) ) , 2 ) == 1 && pass == 1 && strcmp( accfiles(k).name(41:44), 'RUN3' ) ) || ...
           ( mod( str2num( accfiles(k).name(32:34) ) , 2 ) == 0 && pass == 2 && strcmp( accfiles(k).name(41:44), 'RUN3' ) )
            
            inds_repouso_bloco      = inds_repouso_bloco_456;
            inds_activation_bloco   = inds_activation_bloco_456;
            inds_repouso            = inds_repouso_456;
            inds_activation         = inds_activation_456;

            column_offset = 3;

        elseif ( mod( str2num( accfiles(k).name(32:34) ) , 2 ) == 1 && pass == 1 && strcmp( accfiles(k).name(41:44), 'RUN2' ) ) || ...
               ( mod( str2num( accfiles(k).name(32:34) ) , 2 ) == 0 && pass == 2 && strcmp( accfiles(k).name(41:44), 'RUN2' ) ) || ...
               ( mod( str2num( accfiles(k).name(32:34) ) , 2 ) == 0 && pass == 1 && strcmp( accfiles(k).name(41:44), 'RUN3' ) ) || ...
               ( mod( str2num( accfiles(k).name(32:34) ) , 2 ) == 1 && pass == 2 && strcmp( accfiles(k).name(41:44), 'RUN3' ) ) 
            
            inds_repouso_bloco      = inds_repouso_bloco_123;
            inds_activation_bloco   = inds_activation_bloco_123;
            inds_repouso            = inds_repouso_123;
            inds_activation         = inds_activation_123;
            
            column_offset = 0;
            
        end
                
        if plotar
            
            if column_offset == 0
                colors = { 'r', 'g' };
            else column_offset == 3
                colors = { 'r', 'k' };
            end
                
            [rmsActivation(k,1) rmsRepouso(k,1)] = calcAndPlotRMS( acc, inds_activation, inds_repouso, fs_acc, ' x 9.81 m/s^2 ', 'ACC', tit, length( accfiles ), k, ylimits, colors )
            hold on,
        else
            [rmsActivation(k,1) rmsRepouso(k,1)] = calcRMS_data( acc, inds_activation, inds_repouso );
        end
        
        R{k,1} = tit;
        R{k,2+column_offset} = rmsActivation(k,1);
        R{k,3+column_offset} = rmsRepouso(k,1);
        R{k,4+column_offset} = rmsActivation(k,1)/rmsRepouso(k,1);
        
        
        signal{k} = acc;
        
    end
    
end

header = {'', 'RMS_Ativacao_1P' , 'RMS_Repouso_1P' , 'RMS_Ativacao_1P/RMS_Repouso_1P', 'RMS_Ativacao_3P' , 'RMS_Repouso_3P' , 'RMS_Ativacao_3P/RMS_Repouso_3P' };
R = [header; R];

