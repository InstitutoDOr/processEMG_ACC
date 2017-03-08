function [rmsActivation rmsRepouso p ] = calcAndPlotRMS( data, inds_repouso, inds_activation, fs, unit, sig_name, tit, n, k, ylimits, colors )

    if ~exist( 'colors', 'var' )
        colors = { 'r', 'g' };
    end

    % Fixing inds to data size
    if length(data) < max( [inds_repouso inds_activation])
        inds_repouso( inds_repouso > length(data) ) = [];
        inds_activation( inds_activation > length(data) ) = [];
    end
    
    rmsRepouso = calcRMS( data(inds_repouso) );
    rmsActivation = calcRMS( data(inds_activation) );
    
    [h p] = ttest2( abs( data(inds_activation) ), abs( data(inds_repouso) ), 0.05, 'both' );
    
    plotWithSecondsTick( data, fs, unit );        
    title( sprintf( '%s - %s - RMS(Tarefa) = %.2g - RMS(Repouso) = %.2g RMS(Tarefa)/RMS(Repouso)=%2g', sig_name, tit, rmsActivation, rmsRepouso, rmsActivation / rmsRepouso ) )
    
    ylim( ylimits )
    
    start_end_inds_activation = get_start_end_indices( inds_activation );
    start_end_inds_repouso = get_start_end_indices( inds_repouso );
    
    ylims = get(gca,'ylim');
    ylims(2) = ylims(2) * 0.97; 
    line([start_end_inds_activation start_end_inds_activation],ylims,'color',colors{1},'Linewidth', 2)
    line([start_end_inds_repouso start_end_inds_repouso],ylims,'color',colors{2},'Linewidth', 2)

end