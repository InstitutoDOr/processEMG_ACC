function calc_plot_RMS( accfiles, fs_acc, inds_repouso, inds_activation, start_inds_repouso, start_inds_activation , tits , ylimits )

figure
for k =1 :length( accfiles )

    acc = load( accfiles{k} );

    %% prepare Acc
    % first column is channel number, x,z, are channel 9, 10 ,11
    acc = acc(9:11,2:end)'; 
    acc = sqrt( sum( acc.*acc, 2 ) ); % calculate 2-norm

    acc = filterpass( acc, 0.5, fs_acc, 'high', 2); % remove baseline
    
    acc = acc / 1000 / 240; % convert units to multiple of g = 9,81 m / s^2
    
    rmsRepouso(k,1) = calcRMS( acc(inds_repouso{k}) );
    
    rmsActivation(k,1) = calcRMS( acc(inds_activation{k}) );
    
    subplot( length( accfiles ), 1, k);
    plotWithSecondsTick( acc, fs_acc, ' x 9.81 m/s^2 ' );
    title( sprintf( ' %s RMS(tarefa) = %.4g RMS(repouso)=%.4g', tits{k}, rmsActivation(k,1), rmsRepouso(k,1) ) )
    ylim( ylimits )
    line([start_inds_repouso(k,:); start_inds_repouso(k,:)] , repmat( get(gca,'ylim')', 1, size(start_inds_repouso,2) ) ,'color',[.8 .8 .8])
    line([start_inds_activation(k,:); start_inds_activation(k,:)] , repmat( get(gca,'ylim')', 1, size(start_inds_activation,2) ) ,'color','r')
    
end
