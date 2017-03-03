accfiles = { ...
    'MOTOR_BLIND_20120726_DEDO_MEDIO_DEDO_MEIO_CONTRACAO_LEVE_Raw Data.dat'; ...
    'MOTOR_BLIND_20120726_DEDO_MEDIO_POLEGAR_CONTRACAO_LEVE_Raw Data.dat'; ...
    'MOTOR_BLIND_20120726_TENDAO_DEDO_MEDIO_CONTRACAO_LEVE_Raw Data.dat'; ...
    'MOTOR_BLIND_20120726_TENDAO_DEDO_MINIMO_CONTRACAO_LEVE_Raw Data.dat'; ...
    'MOTOR_BLIND_20120726_TENDAO_POLEGAR_CONTRACAO_LEVE_Raw Data.dat' };
    
    
tits = { 'Dedo - Mov. leve Dedo Medio', 'Dedo - Mov. leve Polegar', 'Tendao - Mov. leve Dedo Medio' , 'Tendao - Mov. leve Dedo minimo', 'Tendao - Mov. leve Polegar' }
fs_acc = 100;
duration_block = 10*fs_acc;

start_inds_repouso    = [1 : 2*duration_block : 2*4*duration_block];
start_inds_activation = start_inds_repouso + duration_block;

start_inds_repouso = repmat( start_inds_repouso, length(accfiles), 1);
start_inds_activation = repmat( start_inds_activation, length(accfiles), 1);


offset = 50;
for f=1:size(start_inds_repouso,1)

    inds_repouso{f} = [];
    inds_activation{f} = [];
     
    for b=1:size(start_inds_activation,2)

        inds_repouso{f}    = [inds_repouso{f} start_inds_repouso(f,b)+offset:start_inds_repouso(f,b)+duration_block-offset];
        inds_activation{f} = [inds_activation{f} start_inds_activation(f,b):start_inds_activation(f,b)+duration_block];
        
    end
end

ylimits = [-0.3 0.3];
calc_plot_RMS( accfiles, fs_acc, inds_repouso, inds_activation, start_inds_repouso, start_inds_activation, tits, ylimits )
