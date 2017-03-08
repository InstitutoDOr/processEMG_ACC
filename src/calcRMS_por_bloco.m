function [rmsRepouso rmsActivation p] = calcRMS_por_bloco( data, inds_repouso_bloco, inds_activation_bloco )

rmsRepouso = zeros(length(inds_repouso_bloco),1);
rmsActivation = zeros(length(inds_activation_bloco),1);

% Checking problems with data
data_len = length(data);
all_inds = [inds_repouso_bloco{:} inds_activation_bloco{:}];
thr = round(max(all_inds)*0.95);
if data_len < thr
    error('Corrupted data.');
elseif  any(all_inds > data_len)
    warning( sprintf('Data with fewer elements (%d).', data_len), 'rms:datasize');
end


for b=1:length(inds_repouso_bloco)
    % Fixing size
    inds_repouso_bloco{b}(inds_repouso_bloco{b} > data_len) = [];
    
    rmsRepouso(b) = calcRMS( data(inds_repouso_bloco{b}) );
end

for b=1:length(inds_activation_bloco)   
    % Fixing size
    inds_activation_bloco{b}(inds_activation_bloco{b} > data_len) = [];
    
    rmsActivation(b) = calcRMS( data(inds_activation_bloco{b} ) );
end
    
[h p] = ttest2( rmsRepouso, rmsActivation, 0.05, 'both' );

end