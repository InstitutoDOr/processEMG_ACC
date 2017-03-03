function [signal R R_blocos] = RMS_accelerometro( accfiles, rootdir, fs_acc, dur_rest_seg, dur_activation_seg, repetitions, plotar )

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

start_index_repouso = 1; % cortado no inicio do run

duration_block_activation_pts = duration_block_activation * fs_acc;
duration_block_repouso_pts = duration_block_repouso * fs_acc;
 
blocks=1:numBlocks;
    
dur_block_pair = duration_block_activation_pts+duration_block_repouso_pts;

start_inds_repouso = [start_index_repouso + (blocks-1)*dur_block_pair];
start_inds_activation = [start_index_repouso+duration_block_repouso_pts+(blocks-1)*dur_block_pair];
    
offset = 2 * fs_acc; % cortar inicio de cada bloco 

inds_repouso = [];
inds_activation = [];

for b=1:length(start_inds_activation)

    inds_repouso_bloco{b}    = start_inds_repouso(b)+offset:start_inds_repouso(b)+duration_block_repouso_pts-2;
    inds_activation_bloco{b} = start_inds_activation(b)+offset:start_inds_activation(b)+duration_block_activation_pts-2;
    
    inds_repouso    = [inds_repouso inds_repouso_bloco{b}];
    inds_activation = [inds_activation inds_activation_bloco{b}];

end

tmp = inds_activation;
inds_activation = inds_repouso;
inds_repouso = tmp;

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

    [rmsRepouso_blocos rmsActivation_blocos p_blocos] = calcRMS_por_bloco( acc, inds_repouso_bloco, inds_activation_bloco );

    if plotar
        [rmsActivation(k,1) rmsRepouso(k,1)] = calcAndPlotRMS( acc, inds_activation, inds_repouso, fs_acc, ' x 9.81 m/s^2 ', 'ACC', tit, length( accfiles ), k, ylimits )
    else
        [rmsActivation(k,1) rmsRepouso(k,1)] = calcRMS_data( acc, inds_activation, inds_repouso );
    end
        
    R{k,1} = tit;
    R{k,2} = rmsActivation(k,1);
    R{k,3} = rmsRepouso(k,1);
    R{k,4} = rmsActivation(k,1)/rmsRepouso(k,1);
    
    R_blocos{k,1} = tit;
    ind=2;
    for ind_b=1:length(rmsActivation_blocos)
        R_blocos{k,ind} = rmsActivation_blocos(ind_b);
        ind=ind+1;
    end
    for ind_b=1:length(rmsRepouso_blocos)
        R_blocos{k,ind} = rmsRepouso_blocos(ind_b);
        ind=ind+1;
    end
    R_blocos{k,ind} = p_blocos;
    
    signal{k} = acc;
    
end

header = {'', 'RMS Ativacao' , 'RMS Repouso' , 'RMS Ativacao/RMS Repouso' };
R = [header; R];

header_bloco = [{''}, [repmat( {'BLOCO ATIVACAO'}, 1, length(rmsActivation_blocos)) ], [repmat( {'BLOCO REPOUSO'}, 1, length(rmsRepouso_blocos)) ] , {'p (unpaired t-test)'} ];
R_blocos = [header_bloco; R_blocos];

