function [rmsRepouso rmsActivation p] = calcRMS_por_bloco( data, inds_repouso_bloco, inds_activation_bloco )

rmsRepouso = zeros(length(inds_repouso_bloco),1);
rmsActivation = zeros(length(inds_activation_bloco),1);

% Alerting about possible error
data_len = length(data);
fix = false;
if  data_len > 19000 && any([inds_repouso_bloco{:} inds_activation_bloco{:}] > data_len)
    fix = true;
    warning( sprintf('Data with fewer elements (%d).', data_len), 'rms:datasize');
end


for b=1:length(inds_repouso_bloco)
    % Fixing size
    if fix
        inds_repouso_bloco{b}(inds_repouso_bloco{b} > data_len) = [];
    end
    
    rmsRepouso(b) = calcRMS( data(inds_repouso_bloco{b}) );
end

for b=1:length(inds_activation_bloco)   
    % Fixing size
    if fix
        inds_activation_bloco{b}(inds_activation_bloco{b} > data_len) = [];
    end
    
    rmsActivation(b) = calcRMS( data(inds_activation_bloco{b} ) );
end
    
[h p] = ttest2( rmsRepouso, rmsActivation, 0.05, 'both' );

end