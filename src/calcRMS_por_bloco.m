function [rmsRepouso rmsActivation p] = calcRMS_por_bloco( data, inds_repouso_bloco, inds_activation_bloco )

rmsRepouso = zeros(length(inds_repouso_bloco),1);
rmsActivation = zeros(length(inds_activation_bloco),1);

for b=1:length(inds_repouso_bloco)
    
    rmsRepouso(b) = calcRMS( data(inds_repouso_bloco{b}) );
    
end

for b=1:length(inds_repouso_bloco)

    rmsActivation(b) = calcRMS( data(inds_activation_bloco{b} ) );
    
end
    
[h p] = ttest2( rmsRepouso, rmsActivation, 0.05, 'both' );

end