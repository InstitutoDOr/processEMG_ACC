function [rmsActivation rmsRepouso p ] = calcRMS_data( data, inds_repouso, inds_activation )

    rmsRepouso = calcRMS( data(inds_repouso) );
    rmsActivation = calcRMS( data(inds_activation) );
    
    [h p] = ttest2( abs( data(inds_activation) ), abs( data(inds_repouso) ), 0.05, 'both' );
    
end